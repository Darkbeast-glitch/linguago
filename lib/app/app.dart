import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/storage/app_preferences.dart';
import 'app_router.dart';
import 'app_theme.dart';

class LinguagoApp extends ConsumerWidget {
  const LinguagoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(appPreferencesProvider);

    return MaterialApp(
      title: 'Linguago',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Get Started is a one-time introduction, not a gate. Once it has been
      // seen, launch straight into model setup — which itself forwards to home
      // when the model is already installed.
      initialRoute: preferences.hasSeenGetStarted
          ? AppRoutes.modelSetup
          : AppRoutes.getStarted,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
