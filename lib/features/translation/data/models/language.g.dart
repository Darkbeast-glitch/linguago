// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Language _$LanguageFromJson(Map<String, dynamic> json) => _Language(
  code: json['code'] as String,
  displayName: json['displayName'] as String,
  flagAsset: json['flagAsset'] as String?,
  ttsLocale: json['ttsLocale'] as String,
  isRtl: json['isRtl'] as bool? ?? false,
  supportsAsr: json['supportsAsr'] as bool? ?? true,
  supportsTts: json['supportsTts'] as bool? ?? true,
  isEnabled: json['isEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$LanguageToJson(_Language instance) => <String, dynamic>{
  'code': instance.code,
  'displayName': instance.displayName,
  'flagAsset': instance.flagAsset,
  'ttsLocale': instance.ttsLocale,
  'isRtl': instance.isRtl,
  'supportsAsr': instance.supportsAsr,
  'supportsTts': instance.supportsTts,
  'isEnabled': instance.isEnabled,
};
