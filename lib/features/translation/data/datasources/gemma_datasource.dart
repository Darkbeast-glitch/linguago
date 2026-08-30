import 'dart:io';
import 'dart:typed_data';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/constants/model_config.dart';
import '../../../../core/errors/app_exception.dart';
import '../models/language.dart';

/// Shared across the setup and translation features so the ~2.6 GB model is
/// loaded once and reused, never loaded twice.
final gemmaDataSourceProvider = Provider<GemmaDataSource>((ref) {
  final dataSource = GemmaDataSource();
  ref.onDispose(dataSource.dispose);
  return dataSource;
});

/// The only file in the app that talks to `flutter_gemma`.
///
/// Everything above this (repository → ViewModel → View) works in terms of
/// plain Dart types, so swapping the runtime or the model never reaches the
/// UI layer (PRD §14).
///
/// Lifecycle: [isInstalled] → [download] → [load] → [translateAudio], and
/// [dispose] on teardown. [FlutterGemma.initialize] is *not* called here — it
/// is app-level and runs once in `main()`.
class GemmaDataSource {
  InferenceModel? _model;

  bool get isLoaded => _model != null;

  /// Restores the manager's persisted state — crucially the *active model*
  /// identity — from storage.
  ///
  /// Required before reading anything about the active model. Neither
  /// `getActiveModel()` nor `isModelInstalled()` calls this for you, and
  /// without it a freshly-launched app reports "No active inference model set"
  /// even though the model is installed. Idempotent.
  Future<void> _ensureManagerReady() =>
      FlutterGemmaPlugin.instance.modelManager.ensureInitialized();

  /// Whether the model file is already on disk from a previous run.
  ///
  /// Note this is *file presence*, which is not the same as the model being
  /// the active one — see [load].
  Future<bool> isInstalled() async {
    await _ensureManagerReady();
    return FlutterGemma.isModelInstalled(ModelConfig.fileName);
  }

  /// Downloads the ~2.6 GB model. Reports 0–100 through [onProgress].
  ///
  /// [cancelToken] lets the setup screen abort an in-flight download.
  /// `foreground: true` runs it under an Android foreground service, which is
  /// required for a file this size — background downloads are killed at the
  /// 9-minute mark. Note the HF CDN does not support resuming, so a failed
  /// download restarts from zero.
  Future<void> download({
    required void Function(int percent) onProgress,
    CancelToken? cancelToken,
  }) async {
    await _purgeStaleDownloadTasks();

    final builder = FlutterGemma.installModel(
      modelType: ModelConfig.modelType,
      // Must be litertlm: .task builds have no audio encoder.
      fileType: ModelConfig.fileType,
    ).fromNetwork(ModelConfig.downloadUrl, foreground: true).withProgress(onProgress);

    if (cancelToken != null) {
      builder.withCancelToken(cancelToken);
    }

    await builder.install();
  }

  /// Clears download bookkeeping left behind by a previous attempt.
  ///
  /// Works around a `flutter_gemma` bug: when a download is interrupted, its
  /// task record survives in `background_downloader`'s database. The next
  /// attempt takes the "attach to an existing task" path, finds that dead
  /// record, reports `Existing download failed: TaskStatus.canceled` — and
  /// returns *without deleting it*. So every retry re-attaches to the same
  /// corpse and fails instantly, leaving the user permanently stuck until they
  /// reinstall the app.
  ///
  /// Purging every record is safe here because model downloads are the only
  /// downloads this app performs. Scoping to the package's private
  /// `smart_downloads` group would silently stop working if it were renamed.
  Future<void> _purgeStaleDownloadTasks() async {
    try {
      final downloader = FileDownloader();
      final records = await downloader.database.allRecords();
      for (final record in records) {
        // Cancel first: deleting the record alone would leave the native task
        // running and it would re-register itself.
        await downloader.cancelTaskWithId(record.taskId);
      }
      await downloader.database.deleteAllRecords();
    } catch (_) {
      // Best-effort housekeeping — never block a download because cleanup
      // failed. A fresh download works whether or not this succeeded.
    }
  }

  /// Looks for a model file copied onto the device by hand, bypassing the
  /// in-app download entirely.
  ///
  /// Worth having because Hugging Face downloads **cannot resume**:
  /// `flutter_gemma` sets `allowPause: false` for any `huggingface.co` URL
  /// (HF serves weak ETags, so a byte-range resume risks silent corruption),
  /// which means any interruption restarts all 2.6 GB from zero. Fetching the
  /// file on a desktop — where `curl -C -` *can* resume — and pushing it over
  /// USB avoids that entirely.
  ///
  ///   Android: `adb push <file> /sdcard/Android/data/<applicationId>/files/`
  ///   iOS:     drag the file into the app's Documents via Finder
  ///
  /// Both destinations are readable without any storage permission.
  Future<String?> findSideloadedModel() async {
    final directories = <Directory?>[
      // Android app-private external storage — writable by adb, no permission.
      if (Platform.isAndroid) await getExternalStorageDirectory(),
      // iOS: exposed to Finder because UIFileSharingEnabled is set.
      await getApplicationDocumentsDirectory(),
    ];

    for (final directory in directories) {
      if (directory == null) continue;
      final candidate = File('${directory.path}/${ModelConfig.fileName}');
      if (await candidate.exists()) return candidate.path;
    }
    return null;
  }

  /// Registers an already-present model file. The file is referenced in place,
  /// not copied, so this costs no extra storage.
  Future<void> installFromFile(String path) async {
    await FlutterGemma.installModel(
      modelType: ModelConfig.modelType,
      fileType: ModelConfig.fileType,
    ).fromFile(path).install();
  }

  /// Loads the installed model into memory and prepares it for audio input.
  ///
  /// `supportAudio` must be set here *and* per-session; omitting either leaves
  /// the audio encoder unloaded and speech input silently unavailable.
  Future<void> load() async {
    if (_model != null) return;

    await _ensureManagerReady();

    // Being installed and being *active* are separate state. A model can sit
    // on disk with no active identity — after a sideload, or if the identity
    // was cleared — and `getActiveModel()` throws a bare StateError in that
    // case. Re-register it from its own file to make it active again.
    if (!FlutterGemma.hasActiveModel() && !await _reactivateInstalledModel()) {
      throw const ModelUnavailableException();
    }

    _model = await FlutterGemma.getActiveModel(
      maxTokens: ModelConfig.maxTokens,
      // On Android GPU is both faster *and* lighter than CPU — Google's E2B
      // figures for a Galaxy S26 Ultra are 3808 vs 557 tok/s prefill and
      // 676 MB vs 1733 MB resident. (The trade-off inverts on iPhone: CPU
      // 607 MB / GPU 1450 MB.) Devices without the RAM to load the model at
      // all are turned away by `DeviceCapability` before this point.
      preferredBackend: PreferredBackend.gpu,
      supportAudio: true,
    );
  }

  /// Makes an already-present model file the active one again.
  ///
  /// Returns false when there's genuinely nothing to activate, which the
  /// caller treats as "the model still needs downloading".
  Future<bool> _reactivateInstalledModel() async {
    try {
      // A hand-copied file takes priority: it's the one the user just put
      // there, and it may not be registered at all yet.
      final sideloaded = await findSideloadedModel();
      if (sideloaded != null) {
        await installFromFile(sideloaded);
        return FlutterGemma.hasActiveModel();
      }

      if (!await FlutterGemma.isModelInstalled(ModelConfig.fileName)) {
        return false;
      }

      final path = await FlutterGemma.getModelPath(ModelConfig.fileName);
      if (!await File(path).exists()) {
        // Registered but the bytes are gone — a partial or cleaned-up
        // download. Treat as not installed so setup offers the download.
        return false;
      }

      await installFromFile(path);
      return FlutterGemma.hasActiveModel();
    } catch (_) {
      return false;
    }
  }

  /// Transcribes [audioBytes] and translates it in a single pass.
  ///
  /// [audioBytes] must be 16 kHz mono WAV, at most
  /// [ModelConfig.maxAudioSeconds] long.
  ///
  /// Each call runs in its own session so translations stay independent — a
  /// long-lived chat would accumulate history, growing context and letting
  /// earlier phrases bias later ones.
  Future<String> translateAudio({
    required Uint8List audioBytes,
    required Language source,
    required Language target,
  }) {
    return _runInSession(
      (session) => session.addQueryChunk(
        // Gemma 4's audio-speech-translation template requires the audio to
        // follow the text, which is the order Message.withAudio produces.
        Message.withAudio(
          text: _buildPrompt(source: source, target: target),
          audioBytes: audioBytes,
          isUser: true,
        ),
      ),
    );
  }

  /// Translates already-known [text] with no audio involved.
  ///
  /// Used when the user types a phrase, or corrects a transcription the model
  /// misheard — re-running the corrected text is far better than making them
  /// say it again and hope.
  Future<String> translateText({
    required String text,
    required Language source,
    required Language target,
  }) {
    return _runInSession(
      (session) => session.addQueryChunk(
        Message.text(
          text: _buildTextPrompt(text: text, source: source, target: target),
          isUser: true,
        ),
      ),
    );
  }

  /// Text-only inference. Used to smoke-test that the model loads and
  /// generates before the microphone exists (Milestone 2).
  Future<String> generateText(String prompt) {
    return _runInSession(
      (session) => session.addQueryChunk(Message.text(text: prompt, isUser: true)),
    );
  }

  Future<String> _runInSession(
    Future<void> Function(InferenceModelSession session) addQuery,
  ) async {
    final model = _model;
    if (model == null) {
      throw const ModelUnavailableException();
    }

    final session = await model.createSession(
      temperature: ModelConfig.temperature,
      topK: ModelConfig.topK,
      topP: ModelConfig.topP,
      enableAudioModality: true,
      maxOutputTokens: ModelConfig.maxOutputTokens,
    );

    try {
      await addQuery(session);
      return await session.getResponse();
    } finally {
      await session.close();
    }
  }

  /// PRD §11: transcription + translation only, no commentary, no answering
  /// the speaker.
  ///
  /// The labelled two-line shape is what [TranslationOutputParser] reads back.
  /// Labels are pinned to English regardless of the languages involved, so the
  /// parser doesn't have to chase every language's word for "translation".
  /// Text-in, text-out. Asks for the translation alone — there is nothing to
  /// transcribe, and the caller already has the source text.
  String _buildTextPrompt({
    required String text,
    required Language source,
    required Language target,
  }) {
    return 'Translate the following ${source.displayName} text into '
        '${target.displayName}. '
        "Preserve the writer's meaning accurately and naturally. "
        'Do not add explanations, notes, or alternatives. '
        'Reply with the ${target.displayName} translation only, on a single '
        'line, with no label.\n\n'
        '$text';
  }

  String _buildPrompt({required Language source, required Language target}) {
    return 'Transcribe the following speech segment in ${source.displayName}, '
        'then translate it into ${target.displayName}. '
        "Preserve the speaker's meaning accurately and naturally. "
        'Do not add explanations and do not answer the speaker.\n'
        'Respond with exactly these two lines and nothing else:\n'
        'Transcription: <what was said in ${source.displayName}>\n'
        'Translation: <the same meaning in ${target.displayName}>';
  }

  Future<void> dispose() async {
    await _model?.close();
    _model = null;
  }
}
