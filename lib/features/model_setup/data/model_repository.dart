import 'package:flutter_gemma/flutter_gemma.dart';

/// Model lifecycle operations, kept behind a contract so the setup ViewModel
/// never touches `flutter_gemma` directly (PRD §14).
abstract class ModelRepository {
  /// Whether the model is already on disk from a previous run.
  Future<bool> isModelInstalled();

  /// Path to a model file placed on the device by hand, if there is one.
  /// Lets a user skip the non-resumable 2.6 GB in-app download.
  Future<String?> findSideloadedModel();

  /// Registers an already-present model file (referenced in place, not copied).
  Future<void> installFromFile(String path);

  /// Downloads the model, reporting 0–100 through [onProgress].
  Future<void> downloadModel({
    required void Function(int percent) onProgress,
    CancelToken? cancelToken,
  });

  /// Maps the downloaded model into memory, ready to translate.
  Future<void> loadModel();
}
