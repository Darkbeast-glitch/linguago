import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/device/device_capability.dart';
import '../../../core/errors/app_exception.dart';
import '../../translation/data/datasources/gemma_datasource.dart';
import '../data/model_repository.dart';
import '../data/model_repository_impl.dart';
import 'model_setup_state.dart';

final modelRepositoryProvider = Provider<ModelRepository>((ref) {
  return ModelRepositoryImpl(ref.watch(gemmaDataSourceProvider));
});

/// Injected rather than constructed inline so tests can substitute it —
/// `Connectivity()` hits a platform channel that doesn't exist under
/// `flutter test`.
final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final modelSetupViewModelProvider =
    NotifierProvider<ModelSetupViewModel, ModelSetupState>(ModelSetupViewModel.new);

/// Drives the one-time model install: check disk → (download) → load → ready.
class ModelSetupViewModel extends Notifier<ModelSetupState> {
  late final ModelRepository _repository;
  CancelToken? _cancelToken;

  @override
  ModelSetupState build() {
    _repository = ref.watch(modelRepositoryProvider);
    ref.onDispose(() => _cancelToken?.cancel('Setup screen disposed'));
    Future.microtask(check);
    return ModelSetupState.initial();
  }

  /// Looks for an existing install. If found, loads straight through to ready
  /// so returning users never see the download prompt again.
  Future<void> check() async {
    state = state.copyWith(status: ModelSetupStatus.checking, errorMessage: null);

    try {
      // Before anything else: can this hardware run the model at all? Checked
      // ahead of the download so an unsupported phone is told immediately
      // rather than after spending 2.6 GB (PRD §20, §22).
      final support = await ref.read(deviceCapabilityProvider).check();
      if (support is DeviceUnsupported) {
        state = state.copyWith(
          status: ModelSetupStatus.unsupportedDevice,
          errorMessage: support.reason,
        );
        return;
      }

      final connection = await _currentConnection();
      state = state.copyWith(connection: connection);

      if (await _repository.isModelInstalled()) {
        await _load();
        return;
      }

      // Before asking for a 2.6 GB non-resumable download, check whether the
      // file was copied onto the device by hand.
      final sideloaded = await _repository.findSideloadedModel();
      if (sideloaded != null) {
        state = state.copyWith(status: ModelSetupStatus.loading);
        await _repository.installFromFile(sideloaded);
        await _load();
        return;
      }

      state = state.copyWith(status: ModelSetupStatus.needsDownload);
    } catch (e) {
      _fail("Couldn't check for the translation model.", e);
    }
  }

  /// Starts the ~2.6 GB download. The screen is responsible for confirming
  /// with the user first when [ModelSetupState.shouldWarnAboutData] is set.
  Future<void> download() async {
    if (state.status == ModelSetupStatus.downloading) return;

    final cancelToken = CancelToken();
    _cancelToken = cancelToken;
    state = state.copyWith(
      status: ModelSetupStatus.downloading,
      progress: 0,
      errorMessage: null,
    );

    try {
      await _repository.downloadModel(
        onProgress: (percent) {
          // The token can be cancelled mid-download; don't fight the
          // cancelled state by writing progress over it.
          if (cancelToken.isCancelled) return;
          state = state.copyWith(progress: percent);
        },
        cancelToken: cancelToken,
      );
      await _load();
    } on DownloadCancelledException {
      state = state.copyWith(status: ModelSetupStatus.needsDownload, progress: 0);
    } catch (e) {
      _fail('The download failed. It will restart from the beginning.', e);
    } finally {
      _cancelToken = null;
    }
  }

  void cancelDownload() {
    _cancelToken?.cancel('Cancelled by user');
  }

  Future<void> _load() async {
    state = state.copyWith(status: ModelSetupStatus.loading);
    try {
      await _repository.loadModel();
      state = state.copyWith(status: ModelSetupStatus.ready, progress: 100);
    } on ModelUnavailableException {
      // Nothing usable on disk — a partial or cleaned-up download leaves the
      // model registered but absent. Offer the download rather than showing a
      // dead-end error (PRD §21).
      state = state.copyWith(status: ModelSetupStatus.needsDownload, progress: 0);
    } catch (e) {
      _fail("The model couldn't be loaded on this device.", e);
    }
  }

  void _fail(String message, Object error) {
    state = state.copyWith(
      status: ModelSetupStatus.error,
      errorMessage: '$message\n\n$error',
    );
  }

  Future<ConnectionKind> _currentConnection() async {
    final results = await ref.read(connectivityProvider).checkConnectivity();
    if (results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet)) {
      return ConnectionKind.wifi;
    }
    if (results.contains(ConnectivityResult.mobile)) {
      return ConnectionKind.cellular;
    }
    if (results.isEmpty || results.every((r) => r == ConnectivityResult.none)) {
      return ConnectionKind.none;
    }
    return ConnectionKind.unknown;
  }
}
