import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_setup_state.freezed.dart';

/// Where the one-time model install has got to (PRD §21).
enum ModelSetupStatus {
  /// Looking on disk for an existing install.
  checking,

  /// Not on disk — the user must confirm the download.
  needsDownload,

  /// Download in flight; see [ModelSetupState.progress].
  downloading,

  /// Downloaded, being mapped into memory.
  loading,

  /// Loaded and ready to translate.
  ready,

  /// Something failed; see [ModelSetupState.errorMessage].
  error,

  /// The device can't run the model at all — no download is offered, because
  /// spending 2.6 GB to reach an out-of-memory crash helps nobody (PRD §22).
  unsupportedDevice,
}

/// Whether downloading right now would burn the user's mobile data.
enum ConnectionKind { wifi, cellular, none, unknown }

@freezed
abstract class ModelSetupState with _$ModelSetupState {
  const factory ModelSetupState({
    @Default(ModelSetupStatus.checking) ModelSetupStatus status,

    /// Download progress, 0–100.
    @Default(0) int progress,
    @Default(ConnectionKind.unknown) ConnectionKind connection,
    String? errorMessage,
  }) = _ModelSetupState;

  const ModelSetupState._();

  factory ModelSetupState.initial() => const ModelSetupState();

  bool get isReady => status == ModelSetupStatus.ready;

  /// Warn before spending ~2.6 GB of someone's mobile data.
  bool get shouldWarnAboutData => connection == ConnectionKind.cellular;

  bool get isBusy =>
      status == ModelSetupStatus.checking ||
      status == ModelSetupStatus.downloading ||
      status == ModelSetupStatus.loading;
}
