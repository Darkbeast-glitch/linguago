// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  preferredSourceLanguageCode:
      json['preferredSourceLanguageCode'] as String? ?? 'en',
  preferredTargetLanguageCode:
      json['preferredTargetLanguageCode'] as String? ?? 'fr',
  autoPlayTranslatedSpeech: json['autoPlayTranslatedSpeech'] as bool? ?? true,
  speechRate: (json['speechRate'] as num?)?.toDouble() ?? 0.45,
  speechVoiceIdsByLanguageCode:
      (json['speechVoiceIdsByLanguageCode'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'preferredSourceLanguageCode': instance.preferredSourceLanguageCode,
      'preferredTargetLanguageCode': instance.preferredTargetLanguageCode,
      'autoPlayTranslatedSpeech': instance.autoPlayTranslatedSpeech,
      'speechRate': instance.speechRate,
      'speechVoiceIdsByLanguageCode': instance.speechVoiceIdsByLanguageCode,
    };
