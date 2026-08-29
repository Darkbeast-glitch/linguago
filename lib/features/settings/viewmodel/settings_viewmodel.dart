import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/app_settings.dart';

final settingsViewModelProvider =
    NotifierProvider<SettingsViewModel, AppSettings>(SettingsViewModel.new);

/// Owns the settings screen's state. Milestone 1 keeps this in memory only;
/// persistence (shared_preferences or similar) is out of scope until a later
/// milestone needs it.
class SettingsViewModel extends Notifier<AppSettings> {
  @override
  AppSettings build() => const AppSettings();

  void setAutoPlay(bool value) {
    state = state.copyWith(autoPlayTranslatedSpeech: value);
  }
}
