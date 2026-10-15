import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/app_preferences.dart';
import '../../translation/data/models/language.dart';
import '../../translation/data/models/tts_voice.dart';
import '../../translation/data/translation_repository.dart';
import '../../translation/data/translation_repository_provider.dart';
import '../data/models/app_settings.dart';

final settingsViewModelProvider =
    NotifierProvider<SettingsViewModel, AppSettings>(SettingsViewModel.new);

final speechVoicesProvider = FutureProvider.family<List<TtsVoice>, String>((
  ref,
  languageCode,
) {
  return ref
      .watch(translationRepositoryProvider)
      .availableVoices(SupportedLanguages.byCode(languageCode));
});

/// Owns the settings screen's state, persisted across launches so a preference
/// the user changes once stays changed.
class SettingsViewModel extends Notifier<AppSettings> {
  late final AppPreferences _preferences;
  late final TranslationRepository _repository;

  @override
  AppSettings build() {
    _preferences = ref.watch(appPreferencesProvider);
    _repository = ref.watch(translationRepositoryProvider);
    final voiceIds = <String, String>{};
    for (final language in SupportedLanguages.enabled) {
      final voiceId = _preferences.speechVoiceId(language.code);
      if (voiceId != null) voiceIds[language.code] = voiceId;
    }
    return AppSettings(
      autoPlayTranslatedSpeech: _preferences.autoPlayTranslatedSpeech,
      preferredSourceLanguageCode: _preferences.sourceLanguageCode,
      preferredTargetLanguageCode: _preferences.targetLanguageCode,
      speechRate: _preferences.speechRate,
      speechVoiceIdsByLanguageCode: voiceIds,
    );
  }

  Future<void> setAutoPlay(bool value) async {
    state = state.copyWith(autoPlayTranslatedSpeech: value);
    await _preferences.setAutoPlayTranslatedSpeech(value);
  }

  Future<void> setSpeechRate(double value) async {
    final rate = value
        .clamp(AppPreferences.minSpeechRate, AppPreferences.maxSpeechRate)
        .toDouble();
    state = state.copyWith(speechRate: rate);
    await _preferences.setSpeechRate(rate);
  }

  Future<void> setSpeechVoice(Language language, String? voiceId) async {
    final voices = Map<String, String>.of(state.speechVoiceIdsByLanguageCode);
    if (voiceId == null) {
      voices.remove(language.code);
    } else {
      voices[language.code] = voiceId;
    }
    state = state.copyWith(speechVoiceIdsByLanguageCode: voices);
    await _preferences.setSpeechVoiceId(
      languageCode: language.code,
      voiceId: voiceId,
    );
  }

  Future<void> previewSpeech(Language language) async {
    final examples = <String, String>{
      'en': 'Hello there.',
      'fr': 'Bonjour !',
      'es': 'Hola.',
      'de': 'Hallo.',
      'it': 'Ciao.',
      'pt': 'Olá.',
      'nl': 'Hallo.',
      'ru': 'Привет.',
      'ar': 'مرحبا.',
      'hi': 'नमस्ते।',
      'zh': '你好。',
      'ja': 'こんにちは。',
      'ko': '안녕하세요.',
      'tr': 'Merhaba.',
      'pl': 'Cześć.',
    };
    await _repository.speak(
      examples[language.code] ?? language.displayName,
      language,
    );
  }

  /// Remembers the pair the user last translated between, so the app reopens
  /// on it rather than resetting to English → French every launch.
  Future<void> setLanguagePair({
    required String source,
    required String target,
  }) async {
    state = state.copyWith(
      preferredSourceLanguageCode: source,
      preferredTargetLanguageCode: target,
    );
    await _preferences.setLanguagePair(source: source, target: target);
  }
}
