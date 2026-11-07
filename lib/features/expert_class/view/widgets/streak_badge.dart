import 'package:flutter/material.dart';

import 'streak_calendar_sheet.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({
    required this.streakCount,
    this.isActiveToday = false,
    this.compact = false,
    this.onTap,
    super.key,
  });

  final int streakCount;
  final bool isActiveToday;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => StreakCalendarSheet.show(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 12,
          vertical: compact ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: isActiveToday
              ? const Color(0xFFFFF7ED)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActiveToday
                ? const Color(0xFFFDBA74)
                : const Color(0xFFE5E7EB),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🔥',
              style: TextStyle(fontSize: compact ? 14 : 16),
            ),
            const SizedBox(width: 4),
            Text(
              compact ? '$streakCount' : '$streakCount Days',
              style: TextStyle(
                fontSize: compact ? 12 : 13,
                fontWeight: FontWeight.bold,
                color: isActiveToday
                    ? const Color(0xFFEA580C)
                    : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
