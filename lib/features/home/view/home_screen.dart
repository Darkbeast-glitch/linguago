import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // ── Top bar ──────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleIconButton(icon: Icons.grid_view_rounded, onTap: () {}),
                _CircleIconButton(icon: Icons.search_rounded, onTap: () {}),
              ],
            ),

            const SizedBox(height: 24),

            // ── Searched languages ────────────────────────────────────────
            Text(
              'Searched languages',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _FlagCircle(imagePath: 'assets/Images/spain.png'),
                  SizedBox(width: 10),
                  _FlagCircle(imagePath: 'assets/Images/uk.png'),
                  SizedBox(width: 10),
                  _FlagCircle(imagePath: 'assets/Images/germany.png'),
                  SizedBox(width: 10),
                  _FlagCircle(imagePath: 'assets/Images/canada.png'),
                  SizedBox(width: 10),
                  _FlagCircle(imagePath: 'assets/Images/france.png'),
                  SizedBox(width: 10),
                  _FlagCircle(imagePath: 'assets/Images/france.png'),
                  SizedBox(width: 10),
                  _FlagCircle(imagePath: 'assets/Images/france.png'),
                  SizedBox(width: 10),
                  _FlagCircle(imagePath: 'assets/Images/france.png'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Feature cards row ─────────────────────────────────────────
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Purple card
                  Expanded(
                    child: _FeatureCard(
                      color: const Color(0xFF7B61FF),
                      label: 'Translate\nEvery\nWord',
                      labelColor: Colors.white,
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.translator),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Yellow card
                  Expanded(
                    child: _FeatureCard(
                      color: const Color(0xFFFFCC00),
                      label: 'The\nExpert\nClass',
                      labelColor: Colors.black,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Voice Translation card ────────────────────────────────────
            _VoiceTranslationCard(
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.translator),
            ),

            const SizedBox(height: 24),

            // ── Recommended ───────────────────────────────────────────────
            Text(
              'Recommended',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _RecommendedCard(
              from: '🇬🇧',
              to: '🇫🇷',
              label: 'English to French',
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.translator),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Reusable sub-widgets ──────────────────────────────────────────────────────

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22, color: Colors.black87),
      ),
    );
  }
}

class _FlagCircle extends StatelessWidget {
  const _FlagCircle({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(imagePath, width: 58, height: 58, fit: BoxFit.cover),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.color,
    required this.label,
    required this.labelColor,
    required this.onTap,
  });

  final Color color;
  final String label;
  final Color labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.45,
        height: MediaQuery.sizeOf(context).width * 0.50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            // Label — top-left
            Positioned(
              top: 18,
              left: 18,
              right: 18,
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: labelColor,
                  height: 1.3,
                ),
              ),
            ),
            // Arrow button — bottom-right corner
            Positioned(
              bottom: 14,
              right: 14,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.arrow_outward_rounded,
                  color: labelColor == Colors.white
                      ? Colors.white
                      : Colors.yellow,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoiceTranslationCard extends StatelessWidget {
  const _VoiceTranslationCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF00D26A),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Voice\nTranslation',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _Waveform(),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform();

  @override
  Widget build(BuildContext context) {
    const heights = [
      18.0,
      30.0,
      22.0,
      38.0,
      28.0,
      42.0,
      32.0,
      24.0,
      36.0,
      20.0,
      28.0,
    ];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: heights
          .map(
            (h) => Container(
              width: 4,
              height: h,
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({
    required this.from,
    required this.to,
    required this.label,
    required this.onTap,
  });

  final String from;
  final String to;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Overlapping flags
            SizedBox(
              width: 64,
              height: 44,
              child: Stack(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEEEEEE),
                    ),
                    child: Center(
                      child: Text(from, style: const TextStyle(fontSize: 26)),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEEEEEE),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(to, style: const TextStyle(fontSize: 26)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
