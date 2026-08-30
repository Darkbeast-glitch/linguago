import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma_litertlm/flutter_gemma_litertlm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/storage/app_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Registers the LiteRT-LM engine, which is what actually runs `.litertlm`
  // models. `flutter_gemma` on its own registers no engine and cannot load
  // anything. LiteRT-LM (not MediaPipe, now in maintenance mode) is also the
  // only path that supports audio input.
  //
  // No `huggingFaceToken`: Gemma 4 E2B is Apache 2.0 and ungated.
  await FlutterGemma.initialize(
    inferenceEngines: const [LiteRtLmEngine()],
  );

  // Loaded before the first frame so the app opens directly on the right
  // screen. Reading it asynchronously inside the tree would show Get Started
  // to a returning user for a frame before redirecting them off it.
  final preferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const LinguagoApp(),
    ),
  );
}
