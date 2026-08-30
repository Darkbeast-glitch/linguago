import 'package:flutter_gemma/flutter_gemma.dart';

/// Which on-device model Linguago runs, and where it comes from.
///
/// Chosen per PRD §6's progression: start with the smallest audio-capable
/// Gemma 4 variant (E2B) and only escalate to E4B if measured quality on real
/// devices is insufficient.
///
/// Two hard constraints drove this choice, both verified against the model
/// card and `flutter_gemma` 1.6.5 source:
///   * Audio input requires a **`.litertlm`** build — `.task` files ship
///     without the audio encoder and silently can't accept speech.
///   * `TranslateGemma` is Gemma 3-based and **text-only**, so despite the
///     PRD listing it as a benchmark candidate it cannot serve the speech
///     path at all.
abstract final class ModelConfig {
  /// Filename as stored on device — also the id [FlutterGemma.isModelInstalled]
  /// and [FlutterGemma.uninstallModel] expect.
  static const String fileName = 'gemma-4-E2B-it.litertlm';

  /// Apache 2.0 and ungated: no Hugging Face token required.
  static const String downloadUrl =
      'https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm/resolve/main/$fileName';

  static const ModelType modelType = ModelType.gemma4;
  static const ModelFileType fileType = ModelFileType.litertlm;

  /// Approximate download size, for the setup screen's copy. The artifact is
  /// 2588.1 MB.
  static const double downloadSizeGb = 2.6;

  /// Context window, not reply length — and 1024 is the minimum `.litertlm`
  /// accepts (smaller values are clamped up).
  ///
  /// Deliberately at the floor: the context window is allocated up front, so a
  /// larger one costs memory and prefill time for space this app never uses.
  /// The budget at 15s of recording is ~375 audio tokens (25/sec) + ~80 for
  /// the prompt + [maxOutputTokens], which fits comfortably. Raising
  /// [AppConstants.maxRecordingSeconds] toward the model's 30s ceiling would
  /// need this raised too.
  static const int maxTokens = 1024;

  /// Cap on generated output. Honored on `.litertlm` (ignored by MediaPipe
  /// `.task`). Translations of short phrases are far shorter than this.
  static const int maxOutputTokens = 256;

  /// Hard limit imposed by the model's audio encoder. PRD §24's 10–15s target
  /// sits comfortably inside it.
  static const int maxAudioSeconds = 30;

  /// The audio contract the model requires: 16 kHz, mono.
  static const int audioSampleRate = 16000;
  static const int audioChannels = 1;

  /// Sampling params from Google's Gemma 4 reference configuration.
  static const double temperature = 1.0;
  static const int topK = 64;
  static const double topP = 0.95;
}
