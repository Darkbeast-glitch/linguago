enum LessonStepType {
  phonetic,
  listenRepeat,
  sentencePractice,
  activeSpeaking,
}

class LessonStep {
  const LessonStep({
    required this.stepNumber,
    required this.type,
    required this.title,
    required this.instruction,
    required this.foreignText,
    required this.phoneticGuide,
    required this.englishMeaning,
    this.explanation,
    this.contextExample,
  });

  final int stepNumber;
  final LessonStepType type;
  final String title;
  final String instruction;
  final String foreignText;
  final String phoneticGuide;
  final String englishMeaning;
  final String? explanation;
  final String? contextExample;
}

