import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../../core/errors/app_exception.dart';
import '../models/language.dart';

final ttsDataSourceProvider = Provider<TtsDataSource>((ref) {
  final dataSource = TtsDataSource();
  ref.onDispose(dataSource.dispose);
  return dataSource;
});

/// The only file in the app that performs speech synthesis.
///
/// Uses the platform's own engine — Android's `TextToSpeech`, iOS's
/// `AVSpeechSynthesizer` — which speaks **offline** once the voice data for a
/// language is installed on the device. No cloud voice, ever: PRD §13 is
/// explicit that a missing voice is a *capability gap to surface*, not a
/// reason to reach for the network.
class TtsDataSource {
  TtsDataSource({FlutterTts? tts}) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;
  bool _configured = false;

  Future<void> _configure() async {
    if (_configured) return;
    // Makes `speak()` complete when playback finishes rather than when it
    // starts — without this the UI's "speaking" indicator clears instantly.
    await _tts.awaitSpeakCompletion(true);
    _configured = true;
  }

  /// Whether a voice for [language] is usable offline.
  ///
  /// Checks `isLanguageInstalled` first — that's the strict "voice data is on
  /// this device" answer — but falls back to `isLanguageAvailable`, because
  /// engines disagree about the first one: Samsung's and Google's return false
  /// for locales they can nonetheless speak, which would wrongly deny playback.
  /// Preferring a real attempt over a pessimistic gate matters here, since the
  /// failure mode of guessing wrong is silently refusing a working voice.
  Future<bool> isAvailable(Language language) async {
    if (!language.supportsTts) return false;

    // Each probe is guarded separately, and deliberately so: iOS does not
    // implement `isLanguageInstalled` at all — there is no handler for it in
    // SwiftFlutterTtsPlugin — so it throws MissingPluginException there. A
    // single try/catch around both would swallow that and return false,
    // silently making speech permanently "unavailable" on every iPhone even
    // when a perfectly good voice exists.
    if (await _probe(() => _tts.isLanguageInstalled(language.ttsLocale))) {
      return true;
    }
    // The broader check, and the only one iOS answers. On Android it can be
    // true for a voice that still needs downloading — attempting playback and
    // reporting a real failure beats refusing up front.
    return _probe(() => _tts.isLanguageAvailable(language.ttsLocale));
  }

  /// Runs one platform check, treating "not implemented here" as "no answer"
  /// rather than as "no".
  Future<bool> _probe(Future<dynamic> Function() check) async {
    try {
      return await check() == true;
    } catch (_) {
      return false;
    }
  }

  /// Dumps what the platform engine actually reports, so a "voice unavailable"
  /// message can be traced to the device rather than guessed at. Debug only.
  Future<void> debugDumpVoices(Language language) async {
    if (!kDebugMode) return;

    // Every call is isolated: several of these are implemented on only one
    // platform (`getEngines` and `isLanguageInstalled` are Android-only), and
    // one unsupported call must not stop the rest of the diagnostic from
    // printing — that would leave the exact failure we're trying to explain
    // unexplained.
    Future<Object?> probe(Future<dynamic> Function() call) async {
      try {
        return await call();
      } catch (e) {
        return 'unsupported on this platform ($e)';
      }
    }

    await probe(_configure);
    final languages = await probe(() async => _tts.getLanguages);
    final matching = languages is List
        ? languages.where((l) => '$l'.toLowerCase().startsWith(language.code)).toList()
        : languages;

    debugPrint(
      '[Linguago/TTS] locale=${language.ttsLocale}\n'
      '  isLanguageInstalled: ${await probe(() => _tts.isLanguageInstalled(language.ttsLocale))}\n'
      '  isLanguageAvailable: ${await probe(() => _tts.isLanguageAvailable(language.ttsLocale))}\n'
      '  engines: ${await probe(() async => _tts.getEngines)}\n'
      '  locales matching "${language.code}": $matching',
    );
  }

  /// Speaks [text] in [language], returning once playback has finished.
  ///
  /// Throws [TtsUnavailableException] when no offline voice is installed —
  /// the translation itself is still valid and stays on screen (PRD §22).
  Future<void> speak(String text, Language language) async {
    if (text.trim().isEmpty) return;

    await _configure();

    if (!await isAvailable(language)) {
      await debugDumpVoices(language);
      throw const TtsUnavailableException();
    }

    try {
      await _tts.setLanguage(language.ttsLocale);
      // Slightly under the default: translated phrases are often unfamiliar to
      // the listener, and the platform default reads them too fast to follow.
      await _tts.setSpeechRate(0.45);
      await _tts.speak(text);
    } on TtsUnavailableException {
      rethrow;
    } catch (_) {
      throw const TtsUnavailableException();
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {
      // Stopping a synthesizer that isn't speaking is not an error worth
      // surfacing.
    }
  }

  Future<void> dispose() => stop();
}
