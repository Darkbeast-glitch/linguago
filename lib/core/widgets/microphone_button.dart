import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../features/translation/viewmodel/translation_state.dart';

/// The primary "tap to speak" control, styled as the large black circular
/// button in the bottom toolbar of `linguagodesigns/Tranlsate Screen.png`.
///
/// When [status] is [TranslationStatus.recording], two concentric rings
/// ripple outward from the button — staggered so they feel organic, like
/// sound waves — to reinforce that the mic is actively listening.
class MicrophoneButton extends StatefulWidget {
  const MicrophoneButton({
    required this.status,
    required this.onPressed,
    this.size = 60,
    super.key,
  });

  final TranslationStatus status;
  final VoidCallback onPressed;
  final double size;

  @override
  State<MicrophoneButton> createState() => _MicrophoneButtonState();
}

class _MicrophoneButtonState extends State<MicrophoneButton>
    with TickerProviderStateMixin {
  // Two controllers, phase-shifted by half a cycle, so the rings don't
  // all expand and fade together — one is always "mid-flight" when the
  // other reaches the edge.
  late final AnimationController _ring1;
  late final AnimationController _ring2;

  static const _cycleDuration = Duration(milliseconds: 1600);

  @override
  void initState() {
    super.initState();
    _ring1 = AnimationController(vsync: this, duration: _cycleDuration);
    _ring2 = AnimationController(vsync: this, duration: _cycleDuration);

    if (widget.status == TranslationStatus.recording) {
      _startWaves();
    }
  }

  @override
  void didUpdateWidget(MicrophoneButton old) {
    super.didUpdateWidget(old);
    final nowRecording = widget.status == TranslationStatus.recording;
    final wasRecording = old.status == TranslationStatus.recording;

    if (nowRecording && !wasRecording) {
      _startWaves();
    } else if (!nowRecording && wasRecording) {
      _stopWaves();
    }
  }

  void _startWaves() {
    _ring1.repeat();
    // Offset the second ring by half a period so it's always between two
    // ring-1 pulses, giving the appearance of a continuous outward stream.
    Future.delayed(
      Duration(milliseconds: _cycleDuration.inMilliseconds ~/ 2),
      () {
        if (mounted && widget.status == TranslationStatus.recording) {
          _ring2.repeat();
        }
      },
    );
  }

  void _stopWaves() {
    _ring1.stop();
    _ring2.stop();
    _ring1.reset();
    _ring2.reset();
  }

  @override
  void dispose() {
    _ring1.dispose();
    _ring2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = widget.status == TranslationStatus.recording;
    final isProcessing = widget.status == TranslationStatus.processing;
    final s = widget.size;

    return GestureDetector(
      onTap: isProcessing ? null : widget.onPressed,
      child: SizedBox(
        // The ripple rings expand to 2× the button radius, so the SizedBox
        // must be wide enough to paint them without clipping.
        width: s * 2.4,
        height: s * 2.4,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ── Ripple rings (only while recording) ───────────────────────
            if (isRecording) ...[
              _RippleRing(controller: _ring1, size: s, color: AppColors.accentGreen),
              _RippleRing(controller: _ring2, size: s, color: AppColors.accentGreen),
            ],

            // ── The button itself ─────────────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: s,
              height: s,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isRecording ? AppColors.accentGreen : Colors.black,
              ),
              child: Center(
                child: isProcessing
                    ? SizedBox(
                        width: s * 0.37,
                        height: s * 0.37,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Icon(
                        isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                        color: Colors.white,
                        size: s * 0.43,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single ripple ring that grows from the button edge outward while fading.
///
/// Both scale and opacity are driven by the same [controller] value (0 → 1),
/// which repeats continuously while recording.
class _RippleRing extends StatelessWidget {
  const _RippleRing({
    required this.controller,
    required this.size,
    required this.color,
  });

  final Animation<double> controller;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        // t: 0 → 1 as the ring travels from the button edge to its max radius.
        final t = controller.value;

        // Ring starts at the button radius and expands to 1.1× that distance
        // beyond it — a comfortable visual reach without feeling frantic.
        final maxExpansion = size * 1.1;
        final ringDiameter = size + maxExpansion * t;

        // Opacity: full at the start, fully transparent at the end.
        // Using a curved ease-out so the ring lingers near the button and
        // disappears smoothly as it reaches the edge.
        final opacity = (1.0 - math.pow(t, 0.6)).clamp(0.0, 1.0).toDouble();

        return Container(
          width: ringDiameter,
          height: ringDiameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: opacity * 0.55),
              width: 2.0,
            ),
          ),
        );
      },
    );
  }
}
