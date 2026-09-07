import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../features/translation/data/models/language.dart';

/// A language's flag, as a circle.
///
/// Uses the artwork in `assets/Images/` when the language has some. Languages
/// without artwork fall back to a lettered badge rather than a flag emoji:
/// emoji flags render inconsistently across platforms — Windows shows letter
/// pairs instead of flags, and some regions strip them entirely — so a badge
/// looks deliberate where an emoji would look broken.
class FlagCircle extends StatelessWidget {
  const FlagCircle({required this.language, this.size = 32, super.key});

  final Language language;
  final double size;

  @override
  Widget build(BuildContext context) {
    final asset = language.flagAsset;

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: asset == null
            ? _LetterBadge(code: language.code, size: size)
            : Image.asset(
                asset,
                fit: BoxFit.cover,
                // A renamed or dropped asset shouldn't put a broken-image icon
                // in the middle of the UI — degrade to the badge instead.
                errorBuilder: (_, _, _) => _LetterBadge(code: language.code, size: size),
              ),
      ),
    );
  }
}

class _LetterBadge extends StatelessWidget {
  const _LetterBadge({required this.code, required this.size});

  final String code;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundGray,
      alignment: Alignment.center,
      child: Text(
        code.toUpperCase(),
        style: TextStyle(
          // Scaled to the circle so the badge reads at any size it's used at.
          fontSize: size * 0.36,
          fontWeight: FontWeight.w700,
          color: AppColors.textGray,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
