import '../../translation/data/models/language.dart';
import '../data/models/daily_lesson.dart';
import '../data/models/expert_level.dart';
import '../data/pronunciation_evaluator.dart';

class ExpertClassState {
  const ExpertClassState({
    this.selectedLanguage,
    this.selectedLevel = ExpertLevel.beginner,
    this.currentDay = 1,
    this.completedDays = const {},
    this.streakCount = 0,
    this.longestStreak = 0,
    this.isStreakActiveToday = false,
    this.activeLesson,
    this.activeStepIndex = 0,
    this.isTtsSpeaking = false,
    this.isRecording = false,
    this.isEvaluating = false,
    this.evaluation,
    this.isLessonCompleted = false,
  });

  final Language? selectedLanguage;
  final ExpertLevel selectedLevel;
  final int currentDay;
  final Set<int> completedDays;
  final int streakCount;
  final int longestStreak;
  final bool isStreakActiveToday;
  final DailyLesson? activeLesson;
  final int activeStepIndex;
  final bool isTtsSpeaking;
  final bool isRecording;
  final bool isEvaluating;
  final PronunciationEvaluation? evaluation;
  final bool isLessonCompleted;

  bool get hasActiveProfile => selectedLanguage != null;
  String? get spokenFeedback => evaluation?.message;

  ExpertClassState copyWith({
    Language? selectedLanguage,
    bool clearLanguage = false,
    ExpertLevel? selectedLevel,
    int? currentDay,
    Set<int>? completedDays,
    int? streakCount,
    int? longestStreak,
    bool? isStreakActiveToday,
    DailyLesson? activeLesson,
    int? activeStepIndex,
    bool? isTtsSpeaking,
    bool? isRecording,
    bool? isEvaluating,
    PronunciationEvaluation? evaluation,
    bool clearEvaluation = false,
    bool? isLessonCompleted,
  }) {
    return ExpertClassState(
      selectedLanguage: clearLanguage ? null : (selectedLanguage ?? this.selectedLanguage),
      selectedLevel: selectedLevel ?? this.selectedLevel,
      currentDay: currentDay ?? this.currentDay,
      completedDays: completedDays ?? this.completedDays,
      streakCount: streakCount ?? this.streakCount,
      longestStreak: longestStreak ?? this.longestStreak,
      isStreakActiveToday: isStreakActiveToday ?? this.isStreakActiveToday,
      activeLesson: activeLesson ?? this.activeLesson,
      activeStepIndex: activeStepIndex ?? this.activeStepIndex,
      isTtsSpeaking: isTtsSpeaking ?? this.isTtsSpeaking,
      isRecording: isRecording ?? this.isRecording,
      isEvaluating: isEvaluating ?? this.isEvaluating,
      evaluation: clearEvaluation ? null : (evaluation ?? this.evaluation),
      isLessonCompleted: isLessonCompleted ?? this.isLessonCompleted,
    );
  }
}
