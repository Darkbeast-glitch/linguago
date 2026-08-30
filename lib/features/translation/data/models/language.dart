import 'package:freezed_annotation/freezed_annotation.dart';

part 'language.freezed.dart';
part 'language.g.dart';

/// A selectable language, per PRD §7: "Create a Language model/enum
/// containing display name, locale/code, and capability information."
///
/// Third languages (e.g. Ewe) exist in [SupportedLanguages] but ship with
/// [isEnabled] false until the full speech → translation → TTS pipeline has
/// been proven end to end (PRD §7).
@freezed
abstract class Language with _$Language {
  const factory Language({
    /// BCP-47-ish language code, e.g. "en", "fr".
    required String code,
    required String displayName,
    required String flagEmoji,

    /// Full locale handed to the offline TTS engine, e.g. "en-US". Platform
    /// speech engines match on region, so a bare "en" is not enough.
    required String ttsLocale,
    @Default(true) bool supportsAsr,
    @Default(true) bool supportsTts,
    @Default(true) bool isEnabled,
  }) = _Language;

  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);
}

/// The MVP's fixed language set (PRD §3, §7): English + French, with a
/// configurable-but-disabled third language.
abstract final class SupportedLanguages {
  static const english = Language(
    code: 'en',
    displayName: 'English',
    flagEmoji: '🇬🇧',
    ttsLocale: 'en-US',
  );

  static const french = Language(
    code: 'fr',
    displayName: 'French',
    flagEmoji: '🇫🇷',
    ttsLocale: 'fr-FR',
  );

  /// Disabled until the offline pipeline is validated for English ↔ French.
  ///
  /// `supportsTts: false` is not a placeholder — no mainstream platform speech
  /// engine ships an Ewe voice, so this is a real capability gap the UI must
  /// show rather than a missing implementation (PRD §13).
  static const ewe = Language(
    code: 'ee',
    displayName: 'Ewe',
    flagEmoji: '🇬🇭',
    ttsLocale: 'ee-GH',
    supportsTts: false,
    isEnabled: false,
  );

  static const all = [english, french, ewe];

  static List<Language> get enabled => all.where((l) => l.isEnabled).toList();

  /// Looks up a language by its code, falling back to English rather than
  /// throwing — a stale or unknown code in stored preferences shouldn't be
  /// able to stop the app from starting.
  static Language byCode(String code) {
    return all.firstWhere(
      (l) => l.code == code && l.isEnabled,
      orElse: () => english,
    );
  }

  /// Case-insensitive search over display names and codes, used by the home
  /// screen's search. Disabled languages are included deliberately so the user
  /// can see that a language exists but isn't ready yet, rather than wondering
  /// whether they typed it wrong.
  static List<Language> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all
        .where((l) =>
            l.displayName.toLowerCase().contains(q) || l.code.toLowerCase().startsWith(q))
        .toList();
  }
}
