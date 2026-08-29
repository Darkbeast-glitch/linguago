import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/models/language.dart';

part 'translation_state.freezed.dart';

/// PRD §16: idle / recording / processing / success / error.
enum TranslationStatus { idle, recording, processing, success, error }

/// UI state for the translator screen (PRD §16). Not JSON-serialized — this
/// is transient in-memory state, not a wire model.
@freezed
class TranslationState with _$TranslationState {
  const factory TranslationState({
    @Default(TranslationStatus.idle) TranslationStatus status,
    required Language sourceLanguage,
    required Language targetLanguage,
    String? transcription,
    String? translation,
    @Default(false) bool isSpeaking,
    @Default(false) bool isModelReady,
    String? errorMessage,
  }) = _TranslationState;

  factory TranslationState.initial() => const TranslationState(
        sourceLanguage: SupportedLanguages.english,
        targetLanguage: SupportedLanguages.french,
      );
}
