import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_router.dart';
import '../../../app/app_theme.dart';
import '../../../core/widgets/flag_circle.dart';
import '../../translation/data/models/language.dart';
import '../viewmodel/expert_class_viewmodel.dart';
import 'expert_class_level_sheet.dart';
import 'widgets/streak_calendar_sheet.dart';

class ExpertClassLanguageSelectScreen extends ConsumerWidget {
  const ExpertClassLanguageSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(expertClassViewModelProvider);
    final languages = SupportedLanguages.enabled;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar (Exact design from user mock) ─────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const Text(
                    'The Expert Class',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  _CircleButton(
                    icon: state.streakCount > 0
                        ? Icons.local_fire_department_rounded
                        : Icons.star_outline_rounded,
                    iconColor: state.streakCount > 0
                        ? const Color(0xFFEA580C)
                        : Colors.black87,
                    onTap: () {
                      if (state.streakCount > 0) {
                        StreakCalendarSheet.show(context);
                      } else if (state.hasActiveProfile) {
                        Navigator.of(context).pushNamed(AppRoutes.expertClassDashboard);
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Headline ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Which language do you want to\nbecome an expert in ?',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.25,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Languages List ────────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: languages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final language = languages[index];
                  final isSelected = state.selectedLanguage?.code == language.code;

                  return _LanguageListItem(
                    language: language,
                    isSelected: isSelected,
                    onTap: () async {
                      final selectedLevel = await ExpertClassLevelSheet.show(
                        context,
                        language: language,
                        currentLevel: state.selectedLevel,
                      );

                      if (selectedLevel != null) {
                        final vm = ref.read(expertClassViewModelProvider.notifier);
                        await vm.selectLanguage(language);
                        await vm.selectLevel(selectedLevel);

                        if (context.mounted) {
                          Navigator.of(context).pushReplacementNamed(
                            AppRoutes.expertClassDashboard,
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),

            // ── Motivational Bottom Text ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: Text(
                'Become a master in 60 days,\nonly if you remain consistent',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageListItem extends StatelessWidget {
  const _LanguageListItem({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  final Language language;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            FlagCircle(
              language: language,
              size: 44,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '60-Day Path • Communicative A1',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xFF4B5563),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.black87,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
      ),
    );
  }
}

