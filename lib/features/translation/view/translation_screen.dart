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
///
/// [startWithKeyboard] is set to `true` when navigating from the
/// "Translate Every Word" card — it auto-focuses the source text field so
/// the keyboard appears immediately and the user can type straight away.
class TranslationScreen extends ConsumerStatefulWidget {
  const TranslationScreen({super.key, this.startWithKeyboard = false});

  final bool startWithKeyboard;

  @override
  ConsumerState<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends ConsumerState<TranslationScreen> {
  final _sourceController = TextEditingController();
  final _sourceFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.startWithKeyboard) {
      // Wait one frame so the widget tree is fully built before requesting
      // focus — requesting it synchronously in initState is a no-op.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _sourceFocus.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _sourceFocus.dispose();
    super.dispose();
  }

  /// Mirrors a new transcription into the editable field.
  ///
  /// Skipped while the field has focus so it never overwrites what someone is
  /// mid-way through typing.
  void _syncTranscription(String? transcription) {
    final incoming = transcription ?? '';
    if (_sourceFocus.hasFocus || _sourceController.text == incoming) return;
    _sourceController.value = TextEditingValue(
      text: incoming,
      selection: TextSelection.collapsed(offset: incoming.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<TranslationState>(translationViewModelProvider, (previous, next) {
      if (previous?.transcription != next.transcription) {
        _syncTranscription(next.transcription);
      }
    });

    final state = ref.watch(translationViewModelProvider);
    final viewModel = ref.read(translationViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      // Lets the card scroll clear of the keyboard when typing.
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _TopBar(canPop: Navigator.canPop(context)),
              const SizedBox(height: 20),
              // Keyed off errorMessage rather than the error status: a TTS
              // failure leaves the status at success (the translation is still
              // good and stays on screen) but must still explain that voice
              // playback is unavailable — PRD §22.
              if (state.errorMessage != null) ...[
                _ErrorBanner(
                  message: state.errorMessage!,
                  isCapabilityGap: state.errorIsCapabilityGap,
                ),
                const SizedBox(height: 16),
              ],
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Center(
                          child: _TranslateCard(
                            state: state,
                            viewModel: viewModel,
                            sourceController: _sourceController,
                            sourceFocus: _sourceFocus,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              _BottomToolbar(
                status: state.status,
                onMicPressed: () {
                  _sourceFocus.unfocus();
                  viewModel.onMicPressed();
                },
                onTextPressed: () => _sourceFocus.requestFocus(),
              ),
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
  const _TranslateCard({
    required this.state,
    required this.viewModel,
    required this.sourceController,
    required this.sourceFocus,
  });

  final TranslationState state;
  final TranslationViewModel viewModel;
  final TextEditingController sourceController;
  final FocusNode sourceFocus;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top card with custom notch cutout
            PhysicalShape(
              clipper: const _TopCardClipper(),
              color: AppColors.surface,
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              child: _LanguageHalf(
                language: state.sourceLanguage,
                otherLanguage: state.targetLanguage,
                onLanguageChanged: viewModel.setSourceLanguage,
                text: state.transcription ?? _placeholderFor(state.status, isSource: true),
                editController: sourceController,
                editFocusNode: sourceFocus,
                onSubmitted: viewModel.translateEditedText,
                hintText: _placeholderFor(state.status, isSource: true),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 36),
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
            ),
            const SizedBox(height: 8),
            // Bottom card with custom notch cutout
            PhysicalShape(
              clipper: const _BottomCardClipper(),
              color: AppColors.surface,
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              child: _LanguageHalf(
                language: state.targetLanguage,
                otherLanguage: state.sourceLanguage,
                onLanguageChanged: viewModel.setTargetLanguage,
                text: state.translation ?? _placeholderFor(state.status, isSource: false),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 36, bottom: 20),
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
                    icon: state.isSpeaking ? Icons.stop_rounded : Icons.volume_up_outlined,
                    onTap: state.translation == null
                        ? null
                        : (state.isSpeaking
                            ? viewModel.stopSpeaking
                            : viewModel.speakTranslation),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Central swap button in the notch
        _RoundIconButton(
          icon: Icons.sync_alt_rounded,
          filled: true,
          size: 48,
          onTap: viewModel.swapLanguages,
        ),
      ],
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

/// Custom clipper for the top source card with rounded corners, sloped bottom,
/// and a smooth concave notch at the center for the swap button.
class _TopCardClipper extends CustomClipper<Path> {
  const _TopCardClipper();

  static const double cornerRadius = 28.0;
  static const double notchRadius = 28.0;
  static const double slope = 16.0;

  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = cornerRadius;
    final cx = w / 2;

    // Top-left
    path.moveTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);

    // Top-right
    path.lineTo(w - r, 0);
    path.quadraticBezierTo(w, 0, w, r);

    // Bottom-right
    path.lineTo(w, h - r);
    path.quadraticBezierTo(w, h, w - r, h);

    // Bottom slope right -> notch right edge
    final notchEntryX = cx + notchRadius + 12;
    final notchEntryY = h - slope;
    path.lineTo(notchEntryX, notchEntryY);

    // Smooth concave notch around center swap button
    path.cubicTo(
      cx + notchRadius,
      notchEntryY,
      cx + notchRadius * 0.65,
      h - slope - notchRadius,
      cx,
      h - slope - notchRadius,
    );
    path.cubicTo(
      cx - notchRadius * 0.65,
      h - slope - notchRadius,
      cx - notchRadius,
      notchEntryY,
      cx - notchRadius - 12,
      notchEntryY,
    );

    // Bottom slope left -> bottom-left corner
    path.lineTo(r, h);
    path.quadraticBezierTo(0, h, 0, h - r);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Custom clipper for the bottom target card with rounded corners, sloped top,
/// and a smooth convex notch at the center for the swap button.
class _BottomCardClipper extends CustomClipper<Path> {
  const _BottomCardClipper();

  static const double cornerRadius = 28.0;
  static const double notchRadius = 28.0;
  static const double slope = 16.0;

  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = cornerRadius;
    final cx = w / 2;

    // Top-left corner
    path.moveTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);

    // Top slope left -> notch left edge
    final notchEntryX = cx - notchRadius - 12;
    final notchEntryY = slope;
    path.lineTo(notchEntryX, notchEntryY);

    // Smooth convex notch around center swap button
    path.cubicTo(
      cx - notchRadius,
      notchEntryY,
      cx - notchRadius * 0.65,
      slope + notchRadius,
      cx,
      slope + notchRadius,
    );
    path.cubicTo(
      cx + notchRadius * 0.65,
      slope + notchRadius,
      cx + notchRadius,
      notchEntryY,
      cx + notchRadius + 12,
      notchEntryY,
    );

    // Top slope right -> top-right corner
    path.lineTo(w - r, 0);
    path.quadraticBezierTo(w, 0, w, r);

    // Bottom-right corner
    path.lineTo(w, h - r);
    path.quadraticBezierTo(w, h, w - r, h);

    // Bottom-left corner
    path.lineTo(r, h);
    path.quadraticBezierTo(0, h, 0, h - r);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _LanguageHalf extends StatelessWidget {
  const _LanguageHalf({
    required this.language,
    required this.onLanguageChanged,
    required this.text,
    this.otherLanguage,
    this.leadingActions = const [],
    this.trailingActions = const [],
    this.editController,
    this.editFocusNode,
    this.onSubmitted,
    this.hintText,
    this.padding = const EdgeInsets.all(20),
  });

  static const double minHeight = 210.0;

  final Language language;
  final ValueChanged<Language> onLanguageChanged;
  final String text;

  /// The language on the other half, so the picker can grey it out — source
  /// and target must differ.
  final Language? otherLanguage;
  final List<Widget> leadingActions;
  final List<Widget> trailingActions;
  final EdgeInsetsGeometry padding;

  /// When supplied, this half becomes editable — the user can type a phrase or
  /// correct a misheard transcription and translate that instead.
  final TextEditingController? editController;
  final FocusNode? editFocusNode;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ...leadingActions,
              if (leadingActions.isNotEmpty) const SizedBox(width: 8),
              LanguageSelector(
                selected: language,
                onChanged: onLanguageChanged,
                unavailable: otherLanguage,
              ),
              const Spacer(),
              ...trailingActions,
            ],
          ),
          const SizedBox(height: 16),
          if (editController != null)
            TextField(
              controller: editController,
              focusNode: editFocusNode,
              onSubmitted: onSubmitted,
              maxLines: null,
              // "Translate" rather than "done": pressing it is the action, so
              // the key should say what it does.
              textInputAction: TextInputAction.go,
              style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: AppColors.textGray),
                // Stripped bare so it reads as the card's own text, not as a
                // form field bolted into it.
                isDense: true,
                filled: false,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            )
          else
            Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
            ),
        ],
      ),
    );
  }
}

class _BottomToolbar extends StatelessWidget {
  const _BottomToolbar({
    required this.status,
    required this.onMicPressed,
    required this.onTextPressed,
  });

  final TranslationStatus status;
  final VoidCallback onMicPressed;
  final VoidCallback onTextPressed;

  static const double _micSize = 72.0;
  static const double _sideSize = 56.0;
  static const double _overlap = 16.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Chat button — shifted right by _overlap so it tucks under the mic
        Transform.translate(
          offset: const Offset(_overlap, 0),
          child: _RingIconButton(
            icon: Icons.chat_bubble_outline_rounded,
            size: _sideSize,
            ringColor: Colors.blue,
            // Focuses the source field so you can type a phrase, or fix one
            // the model misheard, instead of repeating yourself at it.
            onTap: onTextPressed,
          ),
        ),
        // Mic button — center anchor for the whole row
        MicrophoneButton(
          status: status,
          onPressed: onMicPressed,
          size: _micSize,
        ),
        // Settings button — shifted left by _overlap so it tucks under the mic
        Transform.translate(
          offset: const Offset(-_overlap, 0),
          child: _RoundIconButton(
            icon: Icons.settings_outlined,
            size: _sideSize,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
          ),
        ),
      ],
    );

  }
}

/// The larger circular buttons: back/star (top bar), swap (card), and the
/// bottom-toolbar settings icon.
class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
    this.size,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final s = size ?? 40.0;
    return SizedBox(
      width: s,
      height: s,
      child: Material(
        color: filled ? Colors.black : AppColors.surface,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Icon(
            icon,
            size: s * 0.42,
            color: filled ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

/// Gray circle button with a colored ring — used for the chat button.
class _RingIconButton extends StatelessWidget {
  const _RingIconButton({
    required this.icon,
    required this.onTap,
    required this.size,
    required this.ringColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color ringColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(color: ringColor, width: 2.5),
        ),
        child: Icon(icon, size: size * 0.42, color: Colors.black87),
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
  const _ErrorBanner({required this.message, this.isCapabilityGap = false});

  final String message;

  /// A missing offline voice is a limitation to explain, not a failure — the
  /// translation below it is perfectly good. Red would overstate it.
  final bool isCapabilityGap;

  @override
  Widget build(BuildContext context) {
    final color = isCapabilityGap ? AppColors.highlightYellow : AppColors.error;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            isCapabilityGap ? Icons.volume_off_outlined : Icons.error_outline,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: TextStyle(color: color))),
        ],
      ),
    );
  }
}
