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
    /// Path to a flag image in `assets/Images/`, or null when one hasn't been
    /// drawn yet — the UI then falls back to a lettered badge rather than an
    /// emoji, whose rendering varies wildly across platforms and is banned on
    /// some of them.
    String? flagAsset,

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

/// The languages the app offers.
///
/// Gemma 4 E2B understands 140+ languages, so adding one here is a data change
/// rather than a model change — nothing else in the app is hardcoded to a
/// particular pair. The set below is limited to high-resource languages that
/// (a) the model handles well and (b) have base text-to-speech voices on both
/// iOS and Android, so the promise of hearing the result back actually holds.
///
/// Adding a language is cheap; *trusting* it is not. Speech-recognition quality
/// varies widely — Gemma's CoVoST average of 33.47 hides a wide spread — so
/// test a new entry on a real device before treating it as supported.
abstract final class SupportedLanguages {
  static const english = Language(
    code: 'en',
    displayName: 'English',
    flagAsset: 'assets/Images/uk.png',
    ttsLocale: 'en-US',
  );

  static const french = Language(
    code: 'fr',
    displayName: 'French',
    flagAsset: 'assets/Images/france.png',
    ttsLocale: 'fr-FR',
  );

  static const spanish = Language(
    code: 'es',
    displayName: 'Spanish',
    flagAsset: 'assets/Images/spain.png',
    ttsLocale: 'es-ES',
  );

  static const german = Language(
    code: 'de',
    displayName: 'German',
    flagAsset: 'assets/Images/german.png',
    ttsLocale: 'de-DE',
  );

  static const italian = Language(
    code: 'it',
    displayName: 'Italian',
    flagAsset: 'assets/Images/italian.png',
    ttsLocale: 'it-IT',
  );

  /// Brazilian Portuguese: far more speakers than the European variant, and
  /// the voice both platforms ship by default.
  static const portuguese = Language(
    code: 'pt',
    displayName: 'Portuguese',
    flagAsset: 'assets/Images/portugal.png',
    ttsLocale: 'pt-BR',
  );

  static const dutch = Language(
    code: 'nl',
    displayName: 'Dutch',
    flagAsset: 'assets/Images/dutch.png',
    ttsLocale: 'nl-NL',
  );

  static const russian = Language(
    code: 'ru',
    displayName: 'Russian',
    flagAsset: 'assets/Images/russian.png',
    ttsLocale: 'ru-RU',
  );

  /// Right-to-left. Flutter renders the script correctly, but the translation
  /// card is laid out left-aligned, so Arabic text sits on the wrong side.
  /// Cosmetic, and worth fixing with a `Directionality` wrapper keyed to the
  /// language.
  static const arabic = Language(
    code: 'ar',
    displayName: 'Arabic',
    flagAsset: 'assets/Images/arab.png',
    ttsLocale: 'ar-SA',
  );

  static const hindi = Language(
    code: 'hi',
    displayName: 'Hindi',
    flagAsset: 'assets/Images/hindi.png',
    ttsLocale: 'hi-IN',
  );

  static const chinese = Language(
    code: 'zh',
    displayName: 'Chinese',
    flagAsset: 'assets/Images/chineese.png',
    ttsLocale: 'zh-CN',
  );

  static const japanese = Language(
    code: 'ja',
    displayName: 'Japanese',
    flagAsset: 'assets/Images/japan.png',
    ttsLocale: 'ja-JP',
  );

  static const korean = Language(
    code: 'ko',
    displayName: 'Korean',
    flagAsset: 'assets/Images/korean.png',
    ttsLocale: 'ko-KR',
  );

  static const turkish = Language(
    code: 'tr',
    displayName: 'Turkish',
    flagAsset: 'assets/Images/turkish.png',
    ttsLocale: 'tr-TR',
  );

  static const polish = Language(
    code: 'pl',
    displayName: 'Polish',
    flagAsset: 'assets/Images/polish.png',
    ttsLocale: 'pl-PL',
  );

  /// Disabled until the offline pipeline is validated for English ↔ French.
  ///
  /// `supportsTts: false` is not a placeholder — no mainstream platform speech
  /// engine ships an Ewe voice, so this is a real capability gap the UI must
  /// show rather than a missing implementation (PRD §13).
  static const ewe = Language(
    code: 'ee',
    displayName: 'Ewe',
    ttsLocale: 'ee-GH',
    supportsTts: false,
    isEnabled: false,
  );

  /// Order matters: this is the order the picker and search results show.
  /// English and French lead because they're the pair the pipeline was proven
  /// on; the rest follow roughly by number of speakers.
  static const all = [
    english,
    french,
    spanish,
    german,
    italian,
    portuguese,
    dutch,
    russian,
    arabic,
    hindi,
    chinese,
    japanese,
    korean,
    turkish,
    polish,
    ewe,
  ];

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
