import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_router.dart';
import '../../../app/app_theme.dart';
import '../../../core/widgets/flag_circle.dart';
import '../../translation/data/models/language.dart';
import '../../translation/viewmodel/translation_viewmodel.dart';

/// Search for a language to translate *into*, then jump straight to the
/// translator with that pair selected.
///
/// Languages that aren't ready yet are listed but disabled rather than hidden:
/// seeing "Ewe — coming soon" answers the question, whereas an empty result
/// leaves the user wondering whether they misspelled it (PRD §22's principle
/// of explaining capability gaps rather than staying silent).
class LanguageSearchSheet extends ConsumerStatefulWidget {
  const LanguageSearchSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LanguageSearchSheet(),
    );
  }

  @override
  ConsumerState<LanguageSearchSheet> createState() => _LanguageSearchSheetState();
}

class _LanguageSearchSheetState extends ConsumerState<LanguageSearchSheet> {
  final _controller = TextEditingController();
  var _results = SupportedLanguages.all;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    setState(() => _results = SupportedLanguages.search(query));
  }

  void _select(Language language) {
    final viewModel = ref.read(translationViewModelProvider.notifier);
    final current = ref.read(translationViewModelProvider);

    // Picking the language you're already speaking means you want to translate
    // *from* it, so flip the pair rather than rejecting the tap.
    if (language.code == current.sourceLanguage.code) {
      viewModel.swapLanguages();
    } else {
      viewModel.setTargetLanguage(language);
    }

    Navigator.of(context)
      ..pop()
      ..pushNamed(AppRoutes.translator);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Lifts the sheet clear of the keyboard.
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
              'Translate into',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              autofocus: true,
              onChanged: _onQueryChanged,
              decoration: const InputDecoration(
                hintText: 'Search languages',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 8),
            if (_results.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No languages match that.',
                  style: TextStyle(color: AppColors.textGray),
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.4,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final language = _results[index];
                    return ListTile(
                      enabled: language.isEnabled,
                      leading: FlagCircle(language: language, size: 32),
                      title: Text(language.displayName),
                      subtitle: language.isEnabled
                          ? null
                          : const Text('Coming soon'),
                      trailing: language.isEnabled
                          ? const Icon(Icons.chevron_right_rounded)
                          : const Icon(Icons.lock_outline_rounded, size: 18),
                      onTap: language.isEnabled ? () => _select(language) : null,
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
