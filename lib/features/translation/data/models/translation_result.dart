import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation_result.freezed.dart';
part 'translation_result.g.dart';

/// The structured output of one offline translation pass (PRD §12).
@freezed
abstract class TranslationResult with _$TranslationResult {
  const factory TranslationResult({
    required String sourceLanguage,
    required String targetLanguage,
    required String transcription,
    required String translation,
    int? processingDurationMs,
    DateTime? createdAt,
  }) = _TranslationResult;

  factory TranslationResult.fromJson(Map<String, dynamic> json) =>
      _$TranslationResultFromJson(json);
}
