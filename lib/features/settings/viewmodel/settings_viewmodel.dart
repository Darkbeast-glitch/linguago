import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/app_preferences.dart';
import '../data/models/app_settings.dart';

final settingsViewModelProvider =
    NotifierProvider<SettingsViewModel, AppSettings>(SettingsViewModel.new);

/// Owns the settings screen's state, persisted across launches so a preference
/// the user changes once stays changed.
class SettingsViewModel extends Notifier<AppSettings> {
  late final AppPreferences _preferences;

  @override
  AppSettings build() {
    _preferences = ref.watch(appPreferencesProvider);
    return AppSettings(
      autoPlayTranslatedSpeech: _preferences.autoPlayTranslatedSpeech,
      preferredSourceLanguageCode: _preferences.sourceLanguageCode,
      preferredTargetLanguageCode: _preferences.targetLanguageCode,
    );
  }

  Future<void> setAutoPlay(bool value) async {
    state = state.copyWith(autoPlayTranslatedSpeech: value);
    await _preferences.setAutoPlayTranslatedSpeech(value);
  }

  /// Remembers the pair the user last translated between, so the app reopens
  /// on it rather than resetting to English → French every launch.
  Future<void> setLanguagePair({required String source, required String target}) async {
    state = state.copyWith(
      preferredSourceLanguageCode: source,
      preferredTargetLanguageCode: target,
    );
    await _preferences.setLanguagePair(source: source, target: target);
  }
}
