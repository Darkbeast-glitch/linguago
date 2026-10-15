import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/storage/app_preferences.dart';
import '../models/language.dart';
import '../models/tts_voice.dart';

final ttsDataSourceProvider = Provider<TtsDataSource>((ref) {
  final dataSource = TtsDataSource(
    preferences: ref.watch(appPreferencesProvider),
  );
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
  TtsDataSource({required this.preferences, FlutterTts? tts})
    : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;
  final AppPreferences preferences;
  bool _configured = false;

  Future<void> _configure() async {
    if (_configured) return;
    // Makes `speak()` complete when playback finishes rather than when it
    // starts — without this the UI's "speaking" indicator clears instantly.
    await _tts.awaitSpeakCompletion(true);
    _configured = true;
  }

  /// Whether a local voice for [language] is available.
  Future<bool> isAvailable(Language language) async {
    return (await availableVoices(language)).isNotEmpty;
  }

  /// Lists local voices matching [language]. Android reports network-dependent
  /// voices alongside local ones, so those are excluded before they reach UI.
  Future<List<TtsVoice>> availableVoices(Language language) async {
    if (!language.supportsTts) return const [];

    try {
      final voices = await _tts.getVoices;
      if (voices is! List) return const [];

      final result = <TtsVoice>[];
      for (final value in voices) {
        if (value is! Map) continue;
        final networkRequired = value['network_required'];
        final requiresNetwork =
            '$networkRequired' == '1' ||
            '$networkRequired'.toLowerCase() == 'true';
        if (requiresNetwork) continue;

        try {
          final voice = TtsVoice.fromPlatformMap(value);
          final localeLanguage = voice.locale.split('-').first.toLowerCase();
          if (localeLanguage == language.code.toLowerCase()) {
            result.add(voice);
          }
        } on TypeError {
          continue;
        }
      }
      result.sort((a, b) => a.name.compareTo(b.name));
      return result;
    } catch (_) {
      throw const TtsUnavailableException();
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
        ? languages
              .where((l) => '$l'.toLowerCase().startsWith(language.code))
              .toList()
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
    final voices = await availableVoices(language);
    if (voices.isEmpty) {
      await debugDumpVoices(language);
      throw const TtsUnavailableException();
    }

    try {
      final selectedVoiceId = preferences.speechVoiceId(language.code);
      final voice = selectedVoiceId == null
          ? voices.first
          : _findVoice(voices, selectedVoiceId);
      if (voice == null) throw const TtsUnavailableException();

      final voiceApplied = await _tts.setVoice(voice.toPlatformMap());
      if (voiceApplied == 0 || voiceApplied == false) {
        throw const TtsUnavailableException();
      }
      await _tts.setSpeechRate(preferences.speechRate);
      await _tts.speak(text);
    } on TtsUnavailableException {
      rethrow;
    } catch (_) {
      throw const TtsUnavailableException();
    }
  }

  TtsVoice? _findVoice(List<TtsVoice> voices, String voiceId) {
    for (final voice in voices) {
      if (voice.id == voiceId) return voice;
    }
    return null;
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
