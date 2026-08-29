import 'models/language.dart';
import 'models/translation_result.dart';

/// The clean-application-operations contract the ViewModel depends on
/// (PRD §14, §18). Hides whether the implementation behind it is fake data
/// (Milestone 1) or real Gemma/audio/TTS data sources (Milestone 2+).
abstract class TranslationRepository {
  /// Prepares local model/runtime assets. Must be called before [translate].
  Future<void> initialize();

  /// Starts local microphone capture.
  Future<void> startRecording();

  /// Stops local microphone capture.
  Future<void> stopRecording();

  /// Runs the last recorded audio through the local model and returns the
  /// transcription + translation.
  Future<TranslationResult> translate({
    required Language source,
    required Language target,
  });

  /// Speaks [text] using an offline TTS voice for [language].
  Future<void> speak(String text, Language language);

  /// Stops any in-progress offline speech playback.
  Future<void> stopSpeaking();
}
