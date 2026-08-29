import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../data/models/language.dart';
import '../data/translation_repository.dart';
import '../data/translation_repository_impl.dart';
import 'translation_state.dart';

/// Swap this provider's implementation (not its call sites) when Milestone 2
/// wires up real Gemma/audio/TTS data sources (PRD §14: Repository hides
/// implementation details from the ViewModel/View).
final translationRepositoryProvider = Provider<TranslationRepository>((ref) {
  return FakeTranslationRepositoryImpl();
});

final translationViewModelProvider =
    NotifierProvider<TranslationViewModel, TranslationState>(TranslationViewModel.new);

/// Owns the translator screen's UI state: starts/stops recording, calls the
/// repository, handles loading/success/error, swaps languages, requests TTS
/// (PRD §14).
class TranslationViewModel extends Notifier<TranslationState> {
  late final TranslationRepository _repository;

  @override
  TranslationState build() {
    _repository = ref.watch(translationRepositoryProvider);
    _initialize();
    return TranslationState.initial();
  }

  Future<void> _initialize() async {
    await _repository.initialize();
    state = state.copyWith(isModelReady: true);
  }

  void setSourceLanguage(Language language) {
    if (language.code == state.targetLanguage.code) return;
    state = state.copyWith(sourceLanguage: language);
  }

  void setTargetLanguage(Language language) {
    if (language.code == state.sourceLanguage.code) return;
    state = state.copyWith(targetLanguage: language);
  }

  void swapLanguages() {
    state = state.copyWith(
      sourceLanguage: state.targetLanguage,
      targetLanguage: state.sourceLanguage,
    );
  }

  /// Tapping the mic: idle → record → stop → translate → success/error.
  Future<void> onMicPressed() async {
    if (state.status == TranslationStatus.recording) {
      await _stopRecordingAndTranslate();
      return;
    }
    if (state.status == TranslationStatus.processing) {
      return;
    }

    state = state.copyWith(
      status: TranslationStatus.recording,
      errorMessage: null,
    );
    try {
      await _repository.startRecording();
    } on AppException catch (e) {
      state = state.copyWith(status: TranslationStatus.error, errorMessage: e.message);
    }
  }

  Future<void> _stopRecordingAndTranslate() async {
    state = state.copyWith(status: TranslationStatus.processing);
    try {
      await _repository.stopRecording();
      final result = await _repository.translate(
        source: state.sourceLanguage,
        target: state.targetLanguage,
      );
      state = state.copyWith(
        status: TranslationStatus.success,
        transcription: result.transcription,
        translation: result.translation,
      );
    } on AppException catch (e) {
      state = state.copyWith(status: TranslationStatus.error, errorMessage: e.message);
    }
  }

  Future<void> speakTranslation() async {
    final translation = state.translation;
    if (translation == null) return;
    await speak(translation, state.targetLanguage);
  }

  /// Speaks arbitrary [text] in [language] — used for the translation bubble,
  /// and for replaying the source transcription.
  Future<void> speak(String text, Language language) async {
    state = state.copyWith(isSpeaking: true);
    try {
      await _repository.speak(text, language);
    } on AppException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    } finally {
      state = state.copyWith(isSpeaking: false);
    }
  }

  Future<void> stopSpeaking() async {
    await _repository.stopSpeaking();
    state = state.copyWith(isSpeaking: false);
  }
}
