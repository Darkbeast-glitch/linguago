import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/models/language.dart';

part 'translation_state.freezed.dart';

/// PRD §16: idle / recording / processing / success / error.
enum TranslationStatus { idle, recording, processing, success, error }

/// UI state for the translator screen (PRD §16). Not JSON-serialized — this
/// is transient in-memory state, not a wire model.
@freezed
abstract class TranslationState with _$TranslationState {
  const factory TranslationState({
    @Default(TranslationStatus.idle) TranslationStatus status,
    required Language sourceLanguage,
    required Language targetLanguage,
    String? transcription,
    String? translation,
    @Default(false) bool isSpeaking,
    @Default(false) bool isModelReady,
    String? errorMessage,

    /// True when [errorMessage] describes a missing capability (no offline
    /// voice for this language) rather than a failure. The translation is
    /// still valid and stays on screen, so this shouldn't be dressed up as an
    /// error — PRD §22 asks for an explanation, not an alarm.
    @Default(false) bool errorIsCapabilityGap,
  }) = _TranslationState;

  factory TranslationState.initial() => const TranslationState(
    sourceLanguage: SupportedLanguages.english,
    targetLanguage: SupportedLanguages.french,
  );
}
