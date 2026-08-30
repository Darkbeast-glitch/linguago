import 'package:flutter_gemma/flutter_gemma.dart';

import '../../translation/data/datasources/gemma_datasource.dart';
import 'model_repository.dart';

class ModelRepositoryImpl implements ModelRepository {
  ModelRepositoryImpl(this._gemma);

  final GemmaDataSource _gemma;

  @override
  Future<bool> isModelInstalled() => _gemma.isInstalled();

  @override
  Future<String?> findSideloadedModel() => _gemma.findSideloadedModel();

  @override
  Future<void> installFromFile(String path) => _gemma.installFromFile(path);

  @override
  Future<void> downloadModel({
    required void Function(int percent) onProgress,
    CancelToken? cancelToken,
  }) {
    return _gemma.download(onProgress: onProgress, cancelToken: cancelToken);
  }

  @override
  Future<void> loadModel() => _gemma.load();
}
