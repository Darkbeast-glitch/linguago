import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import 'datasources/audio_datasource.dart';
import 'datasources/gemma_datasource.dart';
import 'datasources/tts_datasource.dart';
import 'models/language.dart';
import 'models/translation_result.dart';
import 'translation_output_parser.dart';
import 'translation_repository.dart';

/// The real [TranslationRepository]: microphone → local Gemma → parsed result.
///
/// Orchestration lives here rather than in either data source, so neither the
/// mic nor the model needs to know the other exists (PRD §14).
class GemmaTranslationRepositoryImpl implements TranslationRepository {
  GemmaTranslationRepositoryImpl(this._audio, this._gemma, this._tts);

  final AudioDataSource _audio;
  final GemmaDataSource _gemma;
  final TtsDataSource _tts;

  /// Held between [stopRecording] and [translate] — the ViewModel stops the
  /// recording first, then asks for the translation.
  Uint8List? _pendingAudio;

  @override
  Future<void> initialize() => _gemma.load();

  @override
  Future<void> startRecording() async {
    _pendingAudio = null;
    await _audio.startRecording();
  }

  @override
  Future<void> stopRecording() async {
    _pendingAudio = await _audio.stopRecording();
  }

  @override
  Future<TranslationResult> translate({
    required Language source,
    required Language target,
  }) async {
    final audio = _pendingAudio;
    if (audio == null) {
      throw const RecordingFailedException();
    }

    final stopwatch = Stopwatch()..start();
    try {
      final raw = await _gemma.translateAudio(
        audioBytes: audio,
        source: source,
        target: target,
      );
      stopwatch.stop();

      // The model's exact reply, before parsing. Debug builds only — this is
      // the transcript of what someone said, and it must never reach a release
      // log (PRD §23). Invaluable while the prompt is still being tuned: a
      // parse failure is almost always a formatting mismatch, and this is the
      // only way to see what the model really returned.
      if (kDebugMode) {
        debugPrint(
          '[Linguago] audio=${audio.lengthInBytes}B '
          '${source.code}->${target.code} in ${stopwatch.elapsedMilliseconds}ms\n'
          '--- raw model reply ---\n$raw\n-----------------------',
        );
      }

      final parsed = TranslationOutputParser.parse(
        raw,
        sourceName: source.displayName,
        targetName: target.displayName,
      );

      // The model sometimes transcribes the speech and stops, returning no
      // translation — reproducible on fr->en. Rather than making the user
      // repeat themselves, translate the text it did give us in a second
      // pass. Costs about a second and turns a dead end into a result.
      var translation = parsed.translation;
      if (translation == null || translation.isEmpty) {
        if (kDebugMode) {
          debugPrint('[Linguago] audio pass returned no translation — '
              'retrying as text');
        }
        final retry = await _gemma.translateText(
          text: parsed.transcription,
          source: source,
          target: target,
        );
        translation = TranslationOutputParser.parseTranslationOnly(
          retry,
          targetName: target.displayName,
        );
      }

      return TranslationResult(
        sourceLanguage: source.code,
        targetLanguage: target.code,
        transcription: parsed.transcription,
        translation: translation,
        processingDurationMs: stopwatch.elapsedMilliseconds,
        createdAt: DateTime.now(),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      // Anything the runtime throws surfaces as a retryable failure rather
      // than an unhandled crash (PRD §22).
      if (kDebugMode) {
        debugPrint('[Linguago] inference threw: $e');
      }
      throw const TranslationFailedException();
    } finally {
      // Audio is single-use: never reuse a clip for a second translation.
      _pendingAudio = null;
    }
  }

  @override
  Future<TranslationResult> translateText({
    required String text,
    required Language source,
    required Language target,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw const EmptySpeechException();
    }

    final stopwatch = Stopwatch()..start();
    try {
      final raw = await _gemma.translateText(
        text: trimmed,
        source: source,
        target: target,
      );
      stopwatch.stop();

      if (kDebugMode) {
        debugPrint(
          '[Linguago] text ${source.code}->${target.code} '
          'in ${stopwatch.elapsedMilliseconds}ms\n'
          '--- raw model reply ---\n$raw\n-----------------------',
        );
      }

      final translation = TranslationOutputParser.parseTranslationOnly(
        raw,
        targetName: target.displayName,
      );

      return TranslationResult(
        sourceLanguage: source.code,
        targetLanguage: target.code,
        // The user supplied the source text, so it needs no transcribing.
        transcription: trimmed,
        translation: translation,
        processingDurationMs: stopwatch.elapsedMilliseconds,
        createdAt: DateTime.now(),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      if (kDebugMode) debugPrint('[Linguago] text inference threw: $e');
      throw const TranslationFailedException();
    }
  }

  @override
  Future<void> speak(String text, Language language) => _tts.speak(text, language);

  @override
  Future<void> stopSpeaking() => _tts.stop();
}
