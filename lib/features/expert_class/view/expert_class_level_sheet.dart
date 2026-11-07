import 'package:flutter/material.dart';

import '../../../app/app_theme.dart';
import '../../translation/data/models/language.dart';
import '../data/models/expert_level.dart';

class ExpertClassLevelSheet extends StatelessWidget {
  const ExpertClassLevelSheet({
    required this.language,
    required this.selectedLevel,
    required this.onLevelSelected,
    super.key,
  });

  final Language language;
  final ExpertLevel selectedLevel;
  final ValueChanged<ExpertLevel> onLevelSelected;

  static Future<ExpertLevel?> show(
    BuildContext context, {
    required Language language,
    required ExpertLevel currentLevel,
  }) {
    return showModalBottomSheet<ExpertLevel>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => ExpertClassLevelSheet(
        language: language,
        selectedLevel: currentLevel,
        onLevelSelected: (lvl) => Navigator.of(ctx).pop(lvl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose Your Level',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Calibrating your 60-day path for ${language.displayName}.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Colors.black87,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Bento Level Options
          for (final level in ExpertLevel.values) ...[
            _BentoLevelCard(
              level: level,
              isSelected: level == selectedLevel,
              onTap: () => onLevelSelected(level),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _BentoLevelCard extends StatelessWidget {
  const _BentoLevelCard({
    required this.level,
    required this.isSelected,
    required this.onTap,
  });

  final ExpertLevel level;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Unique playful bento theme per level inspired by the design reference
    final (cardBg, accentColor, badgeBg, badgeTextColor, icon) = switch (level) {
      ExpertLevel.beginner => (
          isSelected ? const Color(0xFFEDE9FE) : Colors.white,
          const Color(0xFF7B61FF),
          const Color(0xFFDDD6FE),
          const Color(0xFF5B21B6),
          Icons.auto_awesome_rounded,
        ),
      ExpertLevel.elementary => (
          isSelected ? const Color(0xFFFEF9C3) : Colors.white,
          const Color(0xFFCA8A04),
          const Color(0xFFFEF08A),
          const Color(0xFF854D0E),
          Icons.trending_up_rounded,
        ),
      ExpertLevel.intermediate => (
          isSelected ? const Color(0xFFDCFCE7) : Colors.white,
          const Color(0xFF10B981),
          const Color(0xFFBBF7D0),
          const Color(0xFF065F46),
          Icons.workspace_premium_rounded,
        ),
    };

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(22),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withOpacity(0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        level.title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? const Color(0xFF1E1B4B) : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          level.badge,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: badgeTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    level.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected
                          ? const Color(0xFF374151)
                          : const Color(0xFF6B7280),
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // Tactile selection circle indicator
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? accentColor : const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  isSelected ? Icons.check_rounded : icon,
                  color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
