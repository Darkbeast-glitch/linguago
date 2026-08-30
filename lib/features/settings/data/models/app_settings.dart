import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// Kept minimal per PRD §25: language preferences, auto-play, voice
/// selection, model status, about, privacy.
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default('en') String preferredSourceLanguageCode,
    @Default('fr') String preferredTargetLanguageCode,
    @Default(true) bool autoPlayTranslatedSpeech,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
