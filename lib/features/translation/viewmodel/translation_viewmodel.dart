import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../home/viewmodel/home_viewmodel.dart';
import '../../settings/viewmodel/settings_viewmodel.dart';
import '../data/datasources/audio_datasource.dart';
import '../data/datasources/gemma_datasource.dart';
import '../data/datasources/tts_datasource.dart';
import '../data/gemma_translation_repository_impl.dart';
import '../data/models/language.dart';
import '../data/translation_repository.dart';
import 'translation_state.dart';

/// The real microphone + on-device Gemma pipeline. Tests override this with a
/// fake; nothing above the repository changes either way (PRD §14).
final translationRepositoryProvider = Provider<TranslationRepository>((ref) {
  return GemmaTranslationRepositoryImpl(
    ref.watch(audioDataSourceProvider),
    ref.watch(gemmaDataSourceProvider),
    ref.watch(ttsDataSourceProvider),
  );
});

final translationViewModelProvider =
    NotifierProvider<TranslationViewModel, TranslationState>(TranslationViewModel.new);

/// Owns the translator screen's UI state: starts/stops recording, calls the
/// repository, handles loading/success/error, swaps languages, requests TTS
/// (PRD §14).
class TranslationViewModel extends Notifier<TranslationState> {
  late final TranslationRepository _repository;

  /// Stops an over-long recording automatically: the model rejects clips past
  /// 30s, and PRD §24 wants short clips anyway for responsiveness.
  Timer? _recordingLimit;

  @override
  TranslationState build() {
    _repository = ref.watch(translationRepositoryProvider);
    ref.onDispose(() => _recordingLimit?.cancel());
    _initialize();

    // Reopen on the pair the user last used rather than always English →
    // French. `ref.read` deliberately: a settings change shouldn't tear down
    // and rebuild this notifier mid-translation.
    final settings = ref.read(settingsViewModelProvider);
    return TranslationState.initial().copyWith(
      sourceLanguage: SupportedLanguages.byCode(settings.preferredSourceLanguageCode),
      targetLanguage: SupportedLanguages.byCode(settings.preferredTargetLanguageCode),
    );
  }

  /// Persists the current pair so the next launch starts here.
  void _rememberLanguagePair() {
    ref.read(settingsViewModelProvider.notifier).setLanguagePair(
          source: state.sourceLanguage.code,
          target: state.targetLanguage.code,
        );
  }

  Future<void> _initialize() async {
    try {
      await _repository.initialize();
      state = state.copyWith(isModelReady: true);
    } on AppException catch (e) {
      state = state.copyWith(
        status: TranslationStatus.error,
        errorMessage: e.message,
      );
    }
  }

  void setSourceLanguage(Language language) {
    if (language.code == state.targetLanguage.code) return;
    state = state.copyWith(sourceLanguage: language);
    _rememberLanguagePair();
  }

  void setTargetLanguage(Language language) {
    if (language.code == state.sourceLanguage.code) return;
    state = state.copyWith(targetLanguage: language);
    _rememberLanguagePair();
  }

  void swapLanguages() {
    // Don't reverse mid-recording: the clip already in progress belongs to the
    // old direction, and the model would be asked to translate it as the new
    // one.
    if (state.status == TranslationStatus.recording ||
        state.status == TranslationStatus.processing) {
      return;
    }

    // The previous result belongs to the old direction. Left on screen it puts
    // French text under an English label and vice versa, which reads as though
    // the swap did nothing — the reason this looked broken.
    state = TranslationState.initial().copyWith(
      sourceLanguage: state.targetLanguage,
      targetLanguage: state.sourceLanguage,
      isModelReady: state.isModelReady,
    );
    _rememberLanguagePair();
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

    try {
      await _repository.startRecording();
      // Only enter the recording state once the mic is actually live —
      // otherwise a permission denial would leave the UI showing "Listening".
      state = state.copyWith(
        status: TranslationStatus.recording,
        errorMessage: null,
        transcription: null,
        translation: null,
      );
      _recordingLimit = Timer(
        const Duration(seconds: AppConstants.maxRecordingSeconds),
        _stopRecordingAndTranslate,
      );
    } on AppException catch (e) {
      state = state.copyWith(status: TranslationStatus.error, errorMessage: e.message);
    }
  }

  Future<void> _stopRecordingAndTranslate() async {
    _recordingLimit?.cancel();
    _recordingLimit = null;

    if (state.status != TranslationStatus.recording) return;

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

      // Record this target language so the home screen's "Searched languages"
      // row reflects what the user actually uses.
      ref
          .read(homeViewModelProvider.notifier)
          .recordLanguageUsed(state.targetLanguage.code);

      // "Speak, then hear it" is the whole point of the product (PRD §31), so
      // play the result automatically unless the user turned that off.
      if (ref.read(settingsViewModelProvider).autoPlayTranslatedSpeech) {
        await speakTranslation();
      }
    } on AppException catch (e) {
      state = state.copyWith(status: TranslationStatus.error, errorMessage: e.message);
    } catch (e) {
      // Anything not modelled as an AppException — a PlatformException from
      // the recorder, say — must still land in the error state. Without this
      // the status stays `processing`, and since the mic is disabled while
      // processing, the user is stuck on a spinner with no way back.
      if (kDebugMode) debugPrint('[Linguago] unexpected translate failure: $e');
      state = state.copyWith(
        status: TranslationStatus.error,
        errorMessage: const TranslationFailedException().message,
      );
    }
  }

  /// Translates text the user typed, or a transcription they corrected.
  ///
  /// Speech recognition mishears things; making someone repeat a phrase until
  /// the model gets it right is worse than letting them fix the words and try
  /// again (PRD §22's "empty or unclear speech" case, handled properly).
  Future<void> translateEditedText(String text) async {
    if (state.status == TranslationStatus.recording ||
        state.status == TranslationStatus.processing) {
      return;
    }

    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    state = state.copyWith(
      status: TranslationStatus.processing,
      transcription: trimmed,
      translation: null,
      errorMessage: null,
    );

    try {
      final result = await _repository.translateText(
        text: trimmed,
        source: state.sourceLanguage,
        target: state.targetLanguage,
      );
      state = state.copyWith(
        status: TranslationStatus.success,
        transcription: result.transcription,
        translation: result.translation,
      );

      // Record this target language so the home screen's "Searched languages"
      // row reflects what the user actually uses.
      ref
          .read(homeViewModelProvider.notifier)
          .recordLanguageUsed(state.targetLanguage.code);

      if (ref.read(settingsViewModelProvider).autoPlayTranslatedSpeech) {
        await speakTranslation();
      }
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
    state = state.copyWith(isSpeaking: true, errorMessage: null);
    try {
      await _repository.speak(text, language);
    } on TtsUnavailableException catch (e) {
      // A missing voice leaves the translation intact — flag it as a
      // capability gap so the UI informs rather than alarms.
      state = state.copyWith(
        errorMessage: e.message,
        errorIsCapabilityGap: true,
      );
    } on AppException catch (e) {
      state = state.copyWith(errorMessage: e.message, errorIsCapabilityGap: false);
    } finally {
      state = state.copyWith(isSpeaking: false);
    }
  }

  Future<void> stopSpeaking() async {
    await _repository.stopSpeaking();
    state = state.copyWith(isSpeaking: false);
  }
}
