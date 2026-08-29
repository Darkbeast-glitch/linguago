// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LanguageImpl _$$LanguageImplFromJson(Map<String, dynamic> json) =>
    _$LanguageImpl(
      code: json['code'] as String,
      displayName: json['displayName'] as String,
      flagEmoji: json['flagEmoji'] as String,
      supportsAsr: json['supportsAsr'] as bool? ?? true,
      supportsTts: json['supportsTts'] as bool? ?? true,
      isEnabled: json['isEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$$LanguageImplToJson(_$LanguageImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'displayName': instance.displayName,
      'flagEmoji': instance.flagEmoji,
      'supportsAsr': instance.supportsAsr,
      'supportsTts': instance.supportsTts,
      'isEnabled': instance.isEnabled,
    };
