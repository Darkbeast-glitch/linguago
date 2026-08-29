import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/app_router.dart';

/// First-launch screen with staggered entrance animations:
///  • Headline fades + slides up
///  • Subtitle fades in with a slight delay
///  • Flags image drifts up from the bottom
///  • FAB pulses with a continuous scale animation
class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with TickerProviderStateMixin {
  // Staggered entrance
  late final AnimationController _entranceCtrl;
  late final Animation<double> _headlineFade;
  late final Animation<Offset> _headlineSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<double> _flagsFade;
  late final Animation<Offset> _flagsSlide;
  late final Animation<double> _fabFade;

  // FAB continuous pulse
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    // ── Entrance controller (900 ms total) ──────────────────────────────
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _headlineFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );

    _headlineSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.25, 0.65, curve: Curves.easeOut),
    );

    _flagsFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
    );

    _flagsSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.35, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _fabFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );

    // ── Pulse controller (continuous) ───────────────────────────────────
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Start entrance after a tiny warmup delay
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) _entranceCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Headline ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  FadeTransition(
                    opacity: _headlineFade,
                    child: SlideTransition(
                      position: _headlineSlide,
                      child: Text(
                        'Break Free\nfrom Language\nBarriers',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // ── Subtitle ────────────────────────────────────────
                  FadeTransition(
                    opacity: _subtitleFade,
                    child: Text(
                      'Speak in English or French and hear the\ntranslation instantly fully offline.',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ── Flags image ────────────────────────────────────────────
            FadeTransition(
              opacity: _flagsFade,
              child: SlideTransition(
                position: _flagsSlide,
                child: Image.asset(
                  'assets/Images/flags.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),

            const Spacer(),

            // ── FAB ────────────────────────────────────────────────────
            FadeTransition(
              opacity: _fabFade,
              child: Center(
                child: ScaleTransition(
                  scale: _pulse,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: const CircleBorder(),
                    onPressed: () => Navigator.of(
                      context,
                    ).pushReplacementNamed(AppRoutes.home),
                    child: const Icon(Icons.arrow_forward),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
