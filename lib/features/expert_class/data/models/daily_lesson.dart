import 'lesson_step.dart';

class DailyLesson {
  const DailyLesson({
    required this.day,
    required this.phaseNumber,
    required this.phaseTitle,
    required this.title,
    required this.summary,
    required this.steps,
  });

  final int day;
  final int phaseNumber;
  final String phaseTitle;
  final String title;
  final String summary;
  final List<LessonStep> steps;

  /// Returns which Phase (1 to 6) any given day belongs to.
  static int phaseForDay(int day) {
    if (day <= 7) return 1;
    if (day <= 18) return 2;
    if (day <= 30) return 3;
    if (day <= 45) return 4;
    if (day <= 55) return 5;
    return 6;
  }

  static String phaseTitleFor(int phase) {
    switch (phase) {
      case 1:
        return 'Phase 1: Alphabet & Sound Foundation';
      case 2:
        return 'Phase 2: Encounters, Greetings & Politeness';
      case 3:
        return 'Phase 3: The "About Me" Core & Full Sentences';
      case 4:
        return 'Phase 4: Daily Life, Cafe & Asking Directions';
      case 5:
        return 'Phase 5: Opinions, Likes & Conversational Flow';
      case 6:
      default:
        return 'Phase 6: A1 Fluency Capstone & Real Dialogues';
    }
  }
}

