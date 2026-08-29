import 'package:flutter/material.dart';

import 'app_router.dart';
import 'app_theme.dart';

class LinguagoApp extends StatelessWidget {
  const LinguagoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linguago',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.getStarted,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
