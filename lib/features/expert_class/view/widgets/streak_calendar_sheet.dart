import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_theme.dart';
import '../../../../core/storage/app_preferences.dart';
import '../../viewmodel/expert_class_viewmodel.dart';

class StreakCalendarSheet extends ConsumerWidget {
  const StreakCalendarSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const StreakCalendarSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(expertClassViewModelProvider);
    final prefs = ref.watch(appPreferencesProvider);
    final activityDates = prefs.expertActivityDates;
    final now = DateTime.now();

    // Generate the last 14 days up to today
    final days = List.generate(14, (i) {
      final date = now.subtract(Duration(days: 13 - i));
      final dateStr = _formatDate(date);
      final isToday = i == 13;
      final isCompleted = activityDates.contains(dateStr);
      return _DayStatus(
        date: date,
        dateString: dateStr,
        isToday: isToday,
        isCompleted: isCompleted,
      );
    });

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFDBA74)),
                ),
                child: const Text('🔥', style: TextStyle(fontSize: 26)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${state.streakCount} Day Streak',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      state.isStreakActiveToday
                          ? "You've practiced today! Streak protected."
                          : 'Complete today’s lesson to keep the flame alive!',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Stats summary row
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Current Streak',
                  value: '${state.streakCount}d',
                  color: const Color(0xFFEA580C),
                  icon: Icons.local_fire_department_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  label: 'Best Streak',
                  value: '${state.longestStreak}d',
                  color: AppColors.primaryPurple,
                  icon: Icons.emoji_events_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  label: 'Days Practiced',
                  value: '${activityDates.length}',
                  color: const Color(0xFF059669),
                  icon: Icons.check_circle_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Consistency Map Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Activity Map (Last 14 Days)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  _LegendDot(color: const Color(0xFF10B981), label: 'Practiced'),
                  const SizedBox(width: 10),
                  _LegendDot(color: const Color(0xFFE5E7EB), label: 'Missed'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 14-Day Calendar Grid
          Wrap(
            spacing: 8,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: days.map((day) => _DayPill(day: day)).toList(),
          ),

          const SizedBox(height: 22),

          // Encouragement card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: const [
                Text('💡', style: TextStyle(fontSize: 18)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Practice just 5 minutes a day. Consistent daily practice builds fluency 4x faster than cramming once a week.',
                    style: TextStyle(fontSize: 12.5, color: Color(0xFF4B5563), height: 1.35),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}

class _DayStatus {
  const _DayStatus({
    required this.date,
    required this.dateString,
    required this.isToday,
    required this.isCompleted,
  });

  final DateTime date;
  final String dateString;
  final bool isToday;
  final bool isCompleted;
}

class _DayPill extends StatelessWidget {
  const _DayPill({required this.day});

  final _DayStatus day;

  @override
  Widget build(BuildContext context) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekdayName = weekdays[day.date.weekday - 1];

    final isDone = day.isCompleted;
    final isToday = day.isToday;

    return Container(
      width: 42,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDone
            ? const Color(0xFFECFDF5)
            : isToday
                ? const Color(0xFFFFF7ED)
                : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDone
              ? const Color(0xFF10B981)
              : isToday
                  ? const Color(0xFFF97316)
                  : const Color(0xFFE5E7EB),
          width: isToday ? 1.8 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            weekdayName,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDone
                  ? const Color(0xFF047857)
                  : isToday
                      ? const Color(0xFFC2410C)
                      : const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${day.date.day}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDone
                  ? const Color(0xFF047857)
                  : isToday
                      ? const Color(0xFFEA580C)
                      : const Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 4),
          Icon(
            isDone
                ? Icons.check_circle_rounded
                : isToday
                    ? Icons.radio_button_checked_rounded
                    : Icons.remove_circle_outline_rounded,
            size: 14,
            color: isDone
                ? const Color(0xFF10B981)
                : isToday
                    ? const Color(0xFFF97316)
                    : const Color(0xFFD1D5DB),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}

