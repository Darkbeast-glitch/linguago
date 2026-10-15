import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'datasources/audio_datasource.dart';
import 'datasources/gemma_datasource.dart';
import 'datasources/tts_datasource.dart';
import 'gemma_translation_repository_impl.dart';
import 'translation_repository.dart';

final translationRepositoryProvider = Provider<TranslationRepository>((ref) {
  return GemmaTranslationRepositoryImpl(
    ref.watch(audioDataSourceProvider),
    ref.watch(gemmaDataSourceProvider),
    ref.watch(ttsDataSourceProvider),
  );
});
