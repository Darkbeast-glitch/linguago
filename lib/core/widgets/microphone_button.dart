import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../features/translation/viewmodel/translation_state.dart';

/// The primary "tap to speak" control, styled as the large black circular
/// button in the bottom toolbar of `linguagodesigns/Tranlsate Screen.png`.
class MicrophoneButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isRecording = status == TranslationStatus.recording;
    final isProcessing = status == TranslationStatus.processing;

    return GestureDetector(
      onTap: isProcessing ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isRecording ? AppColors.accentGreen : Colors.black,
        ),
        child: Center(
          child: isProcessing
              ? SizedBox(
                  width: size * 0.37,
                  height: size * 0.37,
                  child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                )
              : Icon(
                  isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                  color: Colors.white,
                  size: size * 0.43,
                ),
        ),
      ),
    );
  }
}
