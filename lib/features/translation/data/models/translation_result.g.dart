// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranslationResultImpl _$$TranslationResultImplFromJson(
  Map<String, dynamic> json,
) => _$TranslationResultImpl(
  sourceLanguage: json['sourceLanguage'] as String,
  targetLanguage: json['targetLanguage'] as String,
  transcription: json['transcription'] as String,
  translation: json['translation'] as String,
  processingDurationMs: (json['processingDurationMs'] as num?)?.toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$TranslationResultImplToJson(
  _$TranslationResultImpl instance,
) => <String, dynamic>{
  'sourceLanguage': instance.sourceLanguage,
  'targetLanguage': instance.targetLanguage,
  'transcription': instance.transcription,
  'translation': instance.translation,
  'processingDurationMs': instance.processingDurationMs,
  'createdAt': instance.createdAt?.toIso8601String(),
};
