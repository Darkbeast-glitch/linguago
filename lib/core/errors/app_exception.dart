/// Error states the translation pipeline can surface (PRD §22).
///
/// Kept as a plain exception hierarchy (not Freezed) since these are thrown,
/// not held as state — the ViewModel catches them and maps them to a
/// [TranslationState.errorMessage].
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class MicrophonePermissionDeniedException extends AppException {
  const MicrophonePermissionDeniedException()
      : super('Microphone access is needed to record speech. Please enable it in Settings.');
}

class ModelUnavailableException extends AppException {
  const ModelUnavailableException()
      : super('The on-device translation model is not ready yet.');
}

class UnsupportedDeviceException extends AppException {
  const UnsupportedDeviceException()
      : super('This device does not support on-device translation.');
}

class RecordingFailedException extends AppException {
  const RecordingFailedException() : super('Recording failed. Please try again.');
}

class TranslationFailedException extends AppException {
  const TranslationFailedException()
      : super("Sorry, I didn't catch that. Try speaking again, "
            'or type it in the box above.');
}

class TtsUnavailableException extends AppException {
  const TtsUnavailableException()
      : super('Voice playback is unavailable for this language, but the text is ready.');
}

class EmptySpeechException extends AppException {
  const EmptySpeechException()
      : super("I couldn't hear anything. Try again a bit closer to the mic, "
            'or type it in the box above.');
}
