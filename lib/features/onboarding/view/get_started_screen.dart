import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/app_router.dart';
import '../../../core/storage/app_preferences.dart';

/// First-launch screen with staggered entrance animations:
///  • Headline fades + slides up
///  • Subtitle fades in with a slight delay
///  • Flags image drifts up from the bottom
///  • FAB pulses with a continuous scale animation
class GetStartedScreen extends ConsumerStatefulWidget {
  const GetStartedScreen({super.key});

  @override
  ConsumerState<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends ConsumerState<GetStartedScreen>
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

  /// Records that the introduction has been seen, then moves on.
  ///
  /// Navigation isn't gated on the write completing — this screen is a one-off
  /// welcome, and making someone wait on a disk write to leave it would be a
  /// worse trade than the rare case of the flag not landing before a crash.
  Future<void> _continue() async {
    final navigator = Navigator.of(context);
    unawaited(ref.read(appPreferencesProvider).setHasSeenGetStarted(true));
    navigator.pushReplacementNamed(AppRoutes.modelSetup);
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
                      child: Text.rich(
                        TextSpan(
                          text: 'Break Free\nfrom Language\nBarriers',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            height: 1.15,
                          ),
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
            // No Flexible wrapper — let the image size to its natural height
            // at full screen width (fitWidth). The two Spacers flex to fill
            // whatever vertical space remains above and below.
            FadeTransition(
              opacity: _flagsFade,
              child: SlideTransition(
                position: _flagsSlide,
                child: const _FlagCluster(),
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
                    // Routes through model setup, which forwards straight on
                    // to home when the model is already installed.
                    onPressed: _continue,
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

/// The scattered flag cluster from `Get Started Screen.png`.
///
/// Composed from the individual flag assets rather than one pre-rendered
/// image: the previous `flags.png` was a flattened export, so every language
/// added or artwork changed meant re-exporting it — and when it was removed,
/// this screen silently referenced a file that no longer existed.
class _FlagCluster extends StatelessWidget {
  const _FlagCluster();

  /// Fractional positions within the cluster, mirroring the mockup's layout —
  /// two flags bleeding off each edge, one large flag anchoring the centre.
  static const _flags = <({String asset, double x, double y, double scale})>[
    (asset: 'assets/Images/france.png', x: 0.02, y: 0.00, scale: 0.56),
    (asset: 'assets/Images/spain.png', x: 0.72, y: 0.06, scale: 0.52),
    (asset: 'assets/Images/uk.png', x: 0.33, y: 0.30, scale: 1.00),
    (asset: 'assets/Images/arab.png', x: 0.86, y: 0.42, scale: 0.48),
    (asset: 'assets/Images/german.png', x: 0.04, y: 0.62, scale: 0.60),
    (asset: 'assets/Images/japan.png', x: 0.62, y: 0.70, scale: 0.56),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Slightly taller than wide, matching the mockup's proportions.
        final height = width * 0.88;
        final unit = width * 0.34;

        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (final flag in _flags)
                Positioned(
                  left: flag.x * width,
                  top: flag.y * height,
                  child: ClipOval(
                    child: Image.asset(
                      flag.asset,
                      width: unit * flag.scale,
                      height: unit * flag.scale,
                      fit: BoxFit.cover,
                      // One missing asset shouldn't blank the whole screen.
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
