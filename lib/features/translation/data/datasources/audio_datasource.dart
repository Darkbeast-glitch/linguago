import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../../core/constants/model_config.dart';
import '../../../../core/errors/app_exception.dart';

final audioDataSourceProvider = Provider<AudioDataSource>((ref) {
  final dataSource = AudioDataSource();
  ref.onDispose(dataSource.dispose);
  return dataSource;
});

/// The only file in the app that touches the microphone.
///
/// Records straight to the format Gemma 4's audio encoder requires — 16 kHz
/// mono WAV — so no resampling or transcoding is needed between capture and
/// inference.
class AudioDataSource {
  AudioDataSource({AudioRecorder? recorder}) : _recorder = recorder ?? AudioRecorder();

  final AudioRecorder _recorder;
  String? _currentPath;

  /// Extra audio captured after the user taps stop, so the last syllable
  /// isn't clipped. Long enough to catch a trailing word, short enough that
  /// nobody perceives a delay.
  static const _stopDelay = Duration(milliseconds: 350);

  /// Asks for microphone access, prompting the user the first time.
  Future<bool> hasPermission() => _recorder.hasPermission();

  /// Begins recording to a temporary file.
  ///
  /// Throws [MicrophonePermissionDeniedException] if access was refused.
  Future<void> startRecording() async {
    if (!await hasPermission()) {
      throw const MicrophonePermissionDeniedException();
    }

    final directory = await getTemporaryDirectory();
    final path =
        '${directory.path}/linguago_${DateTime.now().millisecondsSinceEpoch}.wav';

    await _recorder.start(
      const RecordConfig(
        // WAV rather than a compressed encoder: the model wants raw PCM, and
        // `record` writes a 16 kHz mono WAV that can be handed over as-is.
        encoder: AudioEncoder.wav,
        sampleRate: ModelConfig.audioSampleRate,
        numChannels: ModelConfig.audioChannels,

        // Cancels the tail of our own text-to-speech. Auto-play means the
        // phone may still be speaking the previous translation when the user
        // starts the next one, and without this the model hears both.
        echoCancel: true,

        androidConfig: AndroidRecordConfig(
          // The single most useful setting for recognition accuracy.
          // VOICE_RECOGNITION is the capture path Android tunes for speech —
          // it is what the system's own voice input uses. The default source
          // is tuned for general recording and applies processing that
          // flatters music and hurts transcription.
          audioSource: AndroidAudioSource.voiceRecognition,
        ),
      ),
      path: path,
    );
    _currentPath = path;
  }

  /// Stops recording and returns the captured WAV bytes.
  ///
  /// The temporary file is deleted before returning — audio never outlives the
  /// translation that consumes it (PRD §10 step 12, §23).
  Future<Uint8List> stopRecording() async {
    // People finish a word and *then* reach for the button, so cutting the
    // moment the tap lands clips the final syllable — and a truncated last
    // word is exactly the kind of thing that makes the model mistranslate a
    // whole sentence. A short tail costs nothing and keeps the ending intact.
    await Future<void>.delayed(_stopDelay);

    final path = await _recorder.stop();
    _currentPath = null;

    if (path == null) {
      throw const RecordingFailedException();
    }

    final file = File(path);
    if (!await file.exists()) {
      throw const RecordingFailedException();
    }

    try {
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        throw const RecordingFailedException();
      }
      return bytes;
    } finally {
      await _safeDelete(file);
    }
  }

  /// Aborts a recording and discards whatever was captured.
  Future<void> cancelRecording() async {
    final path = _currentPath;
    _currentPath = null;
    await _recorder.cancel();
    if (path != null) {
      await _safeDelete(File(path));
    }
  }

  Future<bool> isRecording() => _recorder.isRecording();

  Future<void> _safeDelete(File file) async {
    try {
      if (await file.exists()) await file.delete();
    } catch (_) {
      // A leftover temp file is not worth failing a translation over; the OS
      // clears the temp directory anyway.
    }
  }

  Future<void> dispose() async {
    await cancelRecording();
    await _recorder.dispose();
  }
}
