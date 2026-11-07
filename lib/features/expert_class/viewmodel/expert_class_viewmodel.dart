import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/app_preferences.dart';
import '../../translation/data/datasources/audio_datasource.dart';
import '../../translation/data/datasources/gemma_datasource.dart';
import '../../translation/data/datasources/tts_datasource.dart';
import '../../translation/data/models/language.dart';
import '../data/curriculum_catalog.dart';
import '../data/models/daily_lesson.dart';
import '../data/models/expert_level.dart';
import '../data/pronunciation_evaluator.dart';
import 'expert_class_state.dart';

final expertClassViewModelProvider =
    NotifierProvider<ExpertClassViewModel, ExpertClassState>(ExpertClassViewModel.new);

class ExpertClassViewModel extends Notifier<ExpertClassState> {
  late final AppPreferences _preferences;
  late final TtsDataSource _tts;
  late final AudioDataSource _audio;
  late final GemmaDataSource _gemma;

  @override
  ExpertClassState build() {
    _preferences = ref.watch(appPreferencesProvider);
    _tts = ref.watch(ttsDataSourceProvider);
    _audio = ref.watch(audioDataSourceProvider);
    _gemma = ref.watch(gemmaDataSourceProvider);

    ref.onDispose(() {
      _tts.stop();
    });

    _warmUpGemmaIfAvailable();

    final langCode = _preferences.expertLanguageCode;
    final levelCode = _preferences.expertLevel;
    final currentDay = _preferences.expertCurrentDay;
    final completedDays = _preferences.expertCompletedDays;
    final streak = _preferences.streakCount;
    final longestStreak = _preferences.longestStreak;
    final isStreakActiveToday = _preferences.isStreakCompletedToday;

    Language? selectedLanguage;
    if (langCode != null) {
      selectedLanguage = SupportedLanguages.byCode(langCode);
    }

    final level = ExpertLevel.fromCode(levelCode);

    DailyLesson? activeLesson;
    if (selectedLanguage != null) {
      activeLesson = CurriculumCatalog.getLesson(
        languageCode: selectedLanguage.code,
        day: currentDay,
      );
    }

    return ExpertClassState(
      selectedLanguage: selectedLanguage,
      selectedLevel: level,
      currentDay: currentDay,
      completedDays: completedDays,
      streakCount: streak,
      longestStreak: longestStreak,
      isStreakActiveToday: isStreakActiveToday,
      activeLesson: activeLesson,
    );
  }

  Future<void> _warmUpGemmaIfAvailable() async {
    if (!_gemma.isLoaded) {
      try {
        final installed = await _gemma.isInstalled();
        if (installed) {
          await _gemma.load();
        }
      } catch (e) {
        debugPrint('[ExpertClass] Gemma warmup note: $e');
      }
    }
  }

  Future<void> selectLanguage(Language language) async {
    await _preferences.setExpertLanguageCode(language.code);
    final lesson = CurriculumCatalog.getLesson(
      languageCode: language.code,
      day: state.currentDay,
    );
    state = state.copyWith(
      selectedLanguage: language,
      activeLesson: lesson,
      activeStepIndex: 0,
      clearEvaluation: true,
      isLessonCompleted: false,
    );
  }

  Future<void> selectLevel(ExpertLevel level) async {
    await _preferences.setExpertLevel(level.code);
    state = state.copyWith(selectedLevel: level);
  }

  Future<void> resetLanguage() async {
    await _preferences.setExpertLanguageCode(null);
    state = state.copyWith(clearLanguage: true, activeStepIndex: 0);
  }

  void loadDailyLesson(int day) {
    if (state.selectedLanguage == null) return;
    final lesson = CurriculumCatalog.getLesson(
      languageCode: state.selectedLanguage!.code,
      day: day,
    );
    state = state.copyWith(
      activeLesson: lesson,
      activeStepIndex: 0,
      clearEvaluation: true,
      isLessonCompleted: false,
    );
  }

  Future<void> speakCurrentStep(String text) async {
    final language = state.selectedLanguage;
    if (language == null || text.trim().isEmpty) return;

    try {
      state = state.copyWith(isTtsSpeaking: true);
      await _tts.speak(text, language);
    } catch (e) {
      debugPrint('[ExpertClass] TTS playback error: $e');
    } finally {
      state = state.copyWith(isTtsSpeaking: false);
    }
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
    state = state.copyWith(isTtsSpeaking: false);
  }

  Future<void> toggleRecording() async {
    if (state.isRecording) {
      state = state.copyWith(isRecording: false, isEvaluating: true);
      try {
        final bytes = await _audio.stopRecording();
        final currentStep = state.activeLesson?.steps[state.activeStepIndex];
        final expectedText = currentStep?.foreignText ?? '';
        final language = state.selectedLanguage;

        if (language == null) {
          state = state.copyWith(isEvaluating: false);
          return;
        }

        final evaluation = await PronunciationEvaluator.evaluate(
          wavBytes: bytes,
          expectedText: expectedText,
          language: language,
          gemma: _gemma,
        );

        if (evaluation.isSuccess) {
          _triggerSuccessHaptic();
        } else if (evaluation.status == EvaluationStatus.needsWork) {
          _triggerNeedsWorkHaptic();
        }

        state = state.copyWith(
          isEvaluating: false,
          evaluation: evaluation,
        );
      } catch (e) {
        state = state.copyWith(
          isEvaluating: false,
          evaluation: const PronunciationEvaluation(
            status: EvaluationStatus.needsWork,
            message: 'Could not process audio cleanly. Please tap the mic and try again.',
          ),
        );
      }
    } else {
      try {
        state = state.copyWith(isRecording: true, clearEvaluation: true);
        await _audio.startRecording();
      } catch (e) {
        state = state.copyWith(
          isRecording: false,
          evaluation: const PronunciationEvaluation(
            status: EvaluationStatus.needsWork,
            message: 'Microphone permission needed to practice speaking.',
          ),
        );
      }
    }
  }

  void nextStep() {
    final lesson = state.activeLesson;
    if (lesson == null) return;

    if (state.activeStepIndex < lesson.steps.length - 1) {
      state = state.copyWith(
        activeStepIndex: state.activeStepIndex + 1,
        clearEvaluation: true,
      );
    } else {
      completeCurrentLesson();
    }
  }

  void previousStep() {
    if (state.activeStepIndex > 0) {
      state = state.copyWith(
        activeStepIndex: state.activeStepIndex - 1,
        clearEvaluation: true,
      );
    }
  }

  Future<void> completeCurrentLesson() async {
    final day = state.activeLesson?.day ?? state.currentDay;
    await _preferences.addExpertCompletedDay(day);
    final updatedStreak = await _preferences.recordDailyActivity();

    _triggerCelebrationHaptic();

    state = state.copyWith(
      completedDays: _preferences.expertCompletedDays,
      currentDay: _preferences.expertCurrentDay,
      streakCount: updatedStreak,
      longestStreak: _preferences.longestStreak,
      isStreakActiveToday: true,
      isLessonCompleted: true,
    );
  }

  Future<void> _triggerSuccessHaptic() async {
    try {
      await HapticFeedback.lightImpact();
      await Future<void>.delayed(const Duration(milliseconds: 90));
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  Future<void> _triggerNeedsWorkHaptic() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {}
  }

  Future<void> _triggerCelebrationHaptic() async {
    try {
      await HapticFeedback.mediumImpact();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }
}
