import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_router.dart';
import '../../../app/app_theme.dart';
import '../../../core/widgets/flag_circle.dart';
import '../data/models/daily_lesson.dart';
import '../viewmodel/expert_class_viewmodel.dart';
import 'widgets/streak_badge.dart';
import 'widgets/streak_calendar_sheet.dart';

class ExpertClassDashboardScreen extends ConsumerWidget {
  const ExpertClassDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(expertClassViewModelProvider);
    final language = state.selectedLanguage;

    if (language == null) {
      // If no language chosen yet, redirect to language selector
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.expertClass);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final currentLesson = state.activeLesson ??
        DailyLesson(
          day: state.currentDay,
          phaseNumber: DailyLesson.phaseForDay(state.currentDay),
          phaseTitle: DailyLesson.phaseTitleFor(DailyLesson.phaseForDay(state.currentDay)),
          title: 'Lesson ${state.currentDay}',
          summary: 'Daily communicative immersion in ${language.displayName}.',
          steps: const [],
        );

    final progressPercent = (state.completedDays.length / 60.0).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Top Navigation Bar ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.home,
                        (route) => false,
                      ),
                    ),
                    // Language & Level Pill
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.expertClass),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FlagCircle(language: language, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              '${language.displayName} • ${state.selectedLevel.title.split(' ').first}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: Color(0xFF6B7280),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Streak flame badge
                    StreakBadge(
                      streakCount: state.streakCount,
                      isActiveToday: state.isStreakActiveToday,
                    ),
                  ],
                ),
              ),
            ),

            // ── Hero Card: Today's Target (Linguago Design System) ─────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1B4B),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'DAY ${state.currentDay} OF 60',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          Text(
                            '${(progressPercent * 100).toInt()}% Done',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        currentLesson.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentLesson.summary,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 22),
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(expertClassViewModelProvider.notifier)
                              .loadDailyLesson(state.currentDay);
                          Navigator.of(context).pushNamed(AppRoutes.expertLesson);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.completedDays.contains(state.currentDay)
                                    ? "Practice Day ${state.currentDay} Again"
                                    : "Start Today's Lesson",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.arrow_outward_rounded,
                                  color: Colors.white,
                                  size: 19,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Consistency Banner ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: GestureDetector(
                  onTap: () => StreakCalendarSheet.show(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFEF3C7),
                            shape: BoxShape.circle,
                          ),
                          child: const Text('💡', style: TextStyle(fontSize: 18)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Consistency Over Cramming',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    size: 16,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                state.isStreakActiveToday
                                    ? 'Streak locked for today! Tap to view your activity map.'
                                    : 'Complete 1 lesson today to keep your 🔥 ${state.streakCount}-day streak alive! Tap for map.',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // ── 60-Day Roadmap Header ─────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your 60-Day Roadmap',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Free Preview',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── 60-Day Timeline List ──────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final day = index + 1;
                    final isCompleted = state.completedDays.contains(day);
                    final isCurrent = day == state.currentDay;
                    final isLocked = day > state.currentDay && !isCompleted;
                    final phase = DailyLesson.phaseForDay(day);

                    return _DayTimelineCard(
                      day: day,
                      phaseTitle: DailyLesson.phaseTitleFor(phase),
                      isCompleted: isCompleted,
                      isCurrent: isCurrent,
                      isLocked: isLocked,
                      onTap: () {
                        ref
                            .read(expertClassViewModelProvider.notifier)
                            .loadDailyLesson(day);
                        Navigator.of(context).pushNamed(AppRoutes.expertLesson);
                      },
                    );
                  },
                  childCount: 60,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _DayTimelineCard extends StatelessWidget {
  const _DayTimelineCard({
    required this.day,
    required this.phaseTitle,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLocked,
    required this.onTap,
  });

  final int day;
  final String phaseTitle;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isCurrent
              ? const Color(0xFFF5F3FF)
              : isLocked
                  ? const Color(0xFFF9FAFB)
                  : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCurrent
                ? AppColors.primaryPurple
                : isCompleted
                    ? const Color(0xFF10B981).withOpacity(0.4)
                    : const Color(0xFFE5E7EB),
            width: isCurrent ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF10B981)
                    : isCurrent
                        ? AppColors.primaryPurple
                        : const Color(0xFFE5E7EB),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                    : isLocked
                        ? const Icon(Icons.lock_outline_rounded, color: Color(0xFF9CA3AF), size: 16)
                        : Text(
                            '$day',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Day $day',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isLocked ? const Color(0xFF9CA3AF) : Colors.black87,
                    ),
                  ),
                  Text(
                    phaseTitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isLocked ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isCurrent)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Current',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            else if (!isLocked)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Color(0xFF9CA3AF),
              ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

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
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }
}

