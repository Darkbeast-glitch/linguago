import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/app_preferences.dart';
import '../../translation/data/models/language.dart';

final homeViewModelProvider =
    NotifierProvider<HomeViewModel, List<Language>>(HomeViewModel.new);

/// Provides the home screen's "Searched languages" list.
///
/// State is a plain [List<Language>] — most-recent first — hydrated from
/// [AppPreferences.recentLanguageCodes] on first build and refreshed via
/// [refresh] whenever a new translation completes.
class HomeViewModel extends Notifier<List<Language>> {
  late final AppPreferences _prefs;

  @override
  List<Language> build() {
    _prefs = ref.watch(appPreferencesProvider);
    return _resolve(_prefs.recentLanguageCodes);
  }

  /// Called by [TranslationViewModel] after every successful translation to
  /// persist the target language and immediately update this list in the UI.
  Future<void> recordLanguageUsed(String code) async {
    await _prefs.addRecentLanguage(code);
    // Re-read from prefs so the state is always the single source of truth.
    state = _resolve(_prefs.recentLanguageCodes);
  }

  /// Refreshes the list from storage — useful after a cold start where another
  /// part of the app may have written to prefs before this notifier built.
  void refresh() {
    state = _resolve(_prefs.recentLanguageCodes);
  }

  /// Turns a list of language codes into the corresponding [Language] objects,
  /// skipping any code that [SupportedLanguages.byCode] can't match (which
  /// falls back to English — filtering keeps English from appearing under a
  /// stale code's slot).
  static List<Language> _resolve(List<String> codes) {
    return codes
        .map(SupportedLanguages.byCode)
        .where((lang) => codes.contains(lang.code))
        .toList();
  }
}
