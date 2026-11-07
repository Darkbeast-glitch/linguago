enum ExpertLevel {
  beginner(
    code: 'beginner',
    title: 'Beginner (A1)',
    badge: 'Recommended',
    subtitle: 'From zero: Sounds, alphabet, essential phrases & full self-introduction',
  ),
  elementary(
    code: 'elementary',
    title: 'Elementary (A2)',
    badge: 'Building Fluency',
    subtitle: 'Expand sentences, daily interactions & confident everyday questions',
  ),
  intermediate(
    code: 'intermediate',
    title: 'Intermediate (B1)',
    badge: 'Advanced Polish',
    subtitle: 'Express feelings, opinions & navigate complex travel/work situations',
  );

  const ExpertLevel({
    required this.code,
    required this.title,
    required this.badge,
    required this.subtitle,
  });

  final String code;
  final String title;
  final String badge;
  final String subtitle;

  static ExpertLevel fromCode(String code) {
    return ExpertLevel.values.firstWhere(
      (e) => e.code == code,
      orElse: () => ExpertLevel.beginner,
    );
  }
}

