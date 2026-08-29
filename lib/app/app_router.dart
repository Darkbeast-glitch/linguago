import 'package:flutter/material.dart';

import '../features/home/view/home_screen.dart';
import '../features/onboarding/view/get_started_screen.dart';
import '../features/settings/view/settings_screen.dart';
import '../features/translation/view/translation_screen.dart';

/// Route names. Kept as plain named routes (no router package) — the app has
/// exactly three screens for the MVP, so `Navigator` is all it needs.
abstract final class AppRoutes {
  static const getStarted = '/';
  static const home = '/home';
  static const translator = '/translator';
  static const settings = '/settings';
}

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.translator:
        return MaterialPageRoute(builder: (_) => const TranslationScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case AppRoutes.getStarted:
      default:
        return MaterialPageRoute(builder: (_) => const GetStartedScreen());
    }
  }
}
