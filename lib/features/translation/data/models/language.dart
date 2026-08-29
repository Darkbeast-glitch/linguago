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
class Language with _$Language {
  const factory Language({
    /// BCP-47-ish language code, e.g. "en", "fr".
    required String code,
    required String displayName,
    required String flagEmoji,
    @Default(true) bool supportsAsr,
    @Default(true) bool supportsTts,
    @Default(true) bool isEnabled,
  }) = _Language;

  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);
}

/// The MVP's fixed language set (PRD §3, §7): English + French, with a
/// configurable-but-disabled third language.
abstract final class SupportedLanguages {
  static const english = Language(code: 'en', displayName: 'English', flagEmoji: '🇬🇧');

  static const french = Language(code: 'fr', displayName: 'French', flagEmoji: '🇫🇷');

  /// Disabled until the offline pipeline is validated for English ↔ French.
  static const ewe = Language(
    code: 'ee',
    displayName: 'Ewe',
    flagEmoji: '🇬🇭',
    isEnabled: false,
  );

  static const all = [english, french, ewe];

  static List<Language> get enabled => all.where((l) => l.isEnabled).toList();
}
