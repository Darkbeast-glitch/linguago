// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      preferredSourceLanguageCode:
          json['preferredSourceLanguageCode'] as String? ?? 'en',
      preferredTargetLanguageCode:
          json['preferredTargetLanguageCode'] as String? ?? 'fr',
      autoPlayTranslatedSpeech:
          json['autoPlayTranslatedSpeech'] as bool? ?? true,
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'preferredSourceLanguageCode': instance.preferredSourceLanguageCode,
      'preferredTargetLanguageCode': instance.preferredTargetLanguageCode,
      'autoPlayTranslatedSpeech': instance.autoPlayTranslatedSpeech,
    };
