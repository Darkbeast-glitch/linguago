import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_router.dart';
import '../../../app/app_theme.dart';
import '../../../core/widgets/language_selector.dart';
import '../../../core/widgets/microphone_button.dart';
import '../data/models/language.dart';
import '../viewmodel/translation_state.dart';
import '../viewmodel/translation_viewmodel.dart';

/// The main translator screen (PRD §8), laid out to match
/// `linguagodesigns/Tranlsate Screen.png`: one card split into a source half
/// and a target half with a swap button overlapping the seam, and a bottom
/// toolbar with the mic as the primary action.
class TranslationScreen extends ConsumerWidget {
  const TranslationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(translationViewModelProvider);
    final viewModel = ref.read(translationViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _TopBar(canPop: Navigator.canPop(context)),
              const SizedBox(height: 20),
              if (state.status == TranslationStatus.error && state.errorMessage != null) ...[
                _ErrorBanner(message: state.errorMessage!),
                const SizedBox(height: 16),
              ],
              Expanded(
                child: Center(
                  child: _TranslateCard(state: state, viewModel: viewModel),
                ),
              ),
              const SizedBox(height: 24),
              _BottomToolbar(status: state.status, onMicPressed: viewModel.onMicPressed),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.canPop});

  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (canPop)
          _RoundIconButton(icon: Icons.chevron_left, onTap: () => Navigator.of(context).pop())
        else
          const SizedBox(width: 44),
        const Expanded(
          child: Text(
            'Translate',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        _RoundIconButton(
          icon: Icons.star_border_rounded,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Saved phrases are not available yet.')),
          ),
        ),
      ],
    );
  }
}

class _TranslateCard extends StatelessWidget {
  const _TranslateCard({required this.state, required this.viewModel});

  final TranslationState state;
  final TranslationViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LanguageHalf(
                language: state.sourceLanguage,
                onLanguageChanged: viewModel.setSourceLanguage,
                text: state.transcription ?? _placeholderFor(state.status, isSource: true),
                leadingActions: [
                  _CircleIconButton(
                    icon: state.status == TranslationStatus.recording
                        ? Icons.stop_rounded
                        : Icons.mic_none_rounded,
                    onTap: viewModel.onMicPressed,
                  ),
                  const SizedBox(width: 8),
                  _CircleIconButton(
                    icon: Icons.volume_up_outlined,
                    onTap: state.transcription == null
                        ? null
                        : () => viewModel.speak(state.transcription!, state.sourceLanguage),
                  ),
                ],
              ),
              const Divider(height: 1, color: AppColors.backgroundGray),
              _LanguageHalf(
                language: state.targetLanguage,
                onLanguageChanged: viewModel.setTargetLanguage,
                text: state.translation ?? _placeholderFor(state.status, isSource: false),
                trailingActions: [
                  _CircleIconButton(
                    icon: Icons.copy_outlined,
                    onTap: state.translation == null
                        ? null
                        : () {
                            Clipboard.setData(ClipboardData(text: state.translation!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied to clipboard.')),
                            );
                          },
                  ),
                  const SizedBox(width: 8),
                  _CircleIconButton(
                    icon: state.isSpeaking ? Icons.volume_up_rounded : Icons.volume_up_outlined,
                    onTap: state.translation == null ? null : viewModel.speakTranslation,
                  ),
                ],
              ),
            ],
          ),
          _RoundIconButton(
            icon: Icons.sync_alt_rounded,
            filled: true,
            onTap: viewModel.swapLanguages,
          ),
        ],
      ),
    );
  }

  String _placeholderFor(TranslationStatus status, {required bool isSource}) {
    return switch (status) {
      TranslationStatus.recording => isSource ? 'Listening...' : 'Waiting for you to finish...',
      TranslationStatus.processing => isSource ? 'Listening...' : 'Translating...',
      _ => isSource ? 'Tap the mic to start speaking' : 'Your translation will appear here',
    };
  }
}

class _LanguageHalf extends StatelessWidget {
  const _LanguageHalf({
    required this.language,
    required this.onLanguageChanged,
    required this.text,
    this.leadingActions = const [],
    this.trailingActions = const [],
  });

  final Language language;
  final ValueChanged<Language> onLanguageChanged;
  final String text;
  final List<Widget> leadingActions;
  final List<Widget> trailingActions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ...leadingActions,
              if (leadingActions.isNotEmpty) const SizedBox(width: 8),
              LanguageSelector(selected: language, onChanged: onLanguageChanged),
              const Spacer(),
              ...trailingActions,
            ],
          ),
          const SizedBox(height: 16),
          Text(text, style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4)),
        ],
      ),
    );
  }
}

class _BottomToolbar extends StatelessWidget {
  const _BottomToolbar({required this.status, required this.onMicPressed});

  final TranslationStatus status;
  final VoidCallback onMicPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundIconButton(
          icon: Icons.chat_bubble_outline_rounded,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Typed input isn't available yet — speak to translate.")),
          ),
        ),
        const SizedBox(width: 20),
        MicrophoneButton(status: status, onPressed: onMicPressed),
        const SizedBox(width: 20),
        _RoundIconButton(
          icon: Icons.settings_outlined,
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
        ),
      ],
    );
  }
}

/// The larger circular buttons: back/star (top bar), swap (card), and the
/// bottom-toolbar chat/settings icons.
class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap, this.filled = false});

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? Colors.black : AppColors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20, color: filled ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}

/// The smaller inline icon buttons inside each card half (mic/speaker/copy).
class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.backgroundGray,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: onTap == null ? AppColors.textGray.withValues(alpha: 0.4) : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: const TextStyle(color: AppColors.error))),
        ],
      ),
    );
  }
}
