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
    try {
      if (await _tts.isLanguageInstalled(language.ttsLocale) == true) return true;
      return await _tts.isLanguageAvailable(language.ttsLocale) == true;
    } catch (_) {
      return false;
    }
  }

  /// Dumps what the platform engine actually reports, so a "voice unavailable"
  /// message can be traced to the device rather than guessed at. Debug only.
  Future<void> debugDumpVoices(Language language) async {
    if (!kDebugMode) return;
    try {
      await _configure();
      final engines = await _tts.getEngines;
      final languages = await _tts.getLanguages;
      final installed = await _tts.isLanguageInstalled(language.ttsLocale);
      final available = await _tts.isLanguageAvailable(language.ttsLocale);
      final matching = (languages is List)
          ? languages.where((l) => '$l'.toLowerCase().startsWith(language.code)).toList()
          : languages;
      debugPrint(
        '[Linguago/TTS] locale=${language.ttsLocale} '
        'installed=$installed available=$available\n'
        '  engines=$engines\n'
        '  matching "${language.code}" locales=$matching',
      );
    } catch (e) {
      debugPrint('[Linguago/TTS] probe failed: $e');
    }
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
