import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../features/translation/data/models/language.dart';
import 'flag_circle.dart';

/// Pill-shaped language chip with a flag, name, and chevron — matches the
/// selector chips in `linguagodesigns/Tranlsate Screen.png`.
///
/// Tapping opens a searchable sheet rather than a popup menu: with fifteen
/// languages a popup becomes a cramped scroll with no way to jump to one, and
/// it would only get worse as the list grows.
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    required this.selected,
    required this.onChanged,
    super.key,
    this.unavailable,
  });

  final Language selected;
  final ValueChanged<Language> onChanged;

  /// The language chosen on the *other* side of the translation. Shown greyed
  /// out with a reason, since source and target can't be the same — silently
  /// ignoring the tap would just look broken.
  final Language? unavailable;

  Future<void> _pick(BuildContext context) async {
    final picked = await showModalBottomSheet<Language>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LanguagePickerSheet(
        selected: selected,
        unavailable: unavailable,
      ),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pick(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlagCircle(language: selected, size: 20),
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

class _LanguagePickerSheet extends StatefulWidget {
  const _LanguagePickerSheet({required this.selected, this.unavailable});

  final Language selected;
  final Language? unavailable;

  @override
  State<_LanguagePickerSheet> createState() => _LanguagePickerSheetState();
}

class _LanguagePickerSheetState extends State<_LanguagePickerSheet> {
  var _results = SupportedLanguages.all;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.backgroundGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose a language',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              autofocus: true,
              onChanged: (q) => setState(() => _results = SupportedLanguages.search(q)),
              decoration: const InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: _results.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        'No languages match that.',
                        style: TextStyle(color: AppColors.textGray),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final language = _results[index];
                        final isSelected = language.code == widget.selected.code;
                        final isOtherSide = language.code == widget.unavailable?.code;
                        final enabled = language.isEnabled && !isOtherSide;

                        return ListTile(
                          enabled: enabled,
                          selected: isSelected,
                          leading: FlagCircle(language: language, size: 32),
                          title: Text(language.displayName),
                          subtitle: switch (true) {
                            _ when !language.isEnabled => const Text('Coming soon'),
                            _ when isOtherSide =>
                              const Text('Already the other language'),
                            _ when !language.supportsTts =>
                              const Text('No voice — text only'),
                            _ => null,
                          },
                          trailing: isSelected
                              ? const Icon(Icons.check_rounded,
                                  color: AppColors.primaryPurple)
                              : null,
                          onTap: enabled
                              ? () => Navigator.of(context).pop(language)
                              : null,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
