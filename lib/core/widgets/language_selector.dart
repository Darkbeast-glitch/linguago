import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../features/translation/data/models/language.dart';

/// Pill-shaped language chip with a flag, name, and chevron — matches the
/// selector chips in `linguagodesigns/Tranlsate Screen.png`.
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final Language selected;
  final ValueChanged<Language> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Language>(
      initialValue: selected,
      onSelected: onChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) => SupportedLanguages.enabled
          .map(
            (language) => PopupMenuItem<Language>(
              value: language,
              child: Row(
                children: [
                  Text(language.flagEmoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Text(language.displayName),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selected.flagEmoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              selected.displayName,
              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textGray),
          ],
        ),
      ),
    );
  }
}
