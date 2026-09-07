import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:linguago/app/app.dart';
import 'package:linguago/core/storage/app_preferences.dart';
import 'package:linguago/features/home/view/home_screen.dart';
import 'package:linguago/features/model_setup/data/model_repository.dart';
import 'package:linguago/features/model_setup/viewmodel/model_setup_viewmodel.dart';

/// Flutter's default test viewport is 800x600 — short and wide, unlike any
/// phone. The Get Started screen sizes its flag artwork to the full width, so
/// at 600pt tall it overflows and layout aborts, which has nothing to do with
/// how the screen behaves on a real device. Use a typical phone viewport
/// instead.
void _usePhoneViewport(WidgetTester tester) {
  const size = Size(390, 844); // iPhone 14-ish, logical pixels
  tester.view.devicePixelRatio = 3.0;
  tester.view.physicalSize = size * 3.0;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

/// The Get Started screen runs a continuous pulse animation, so
/// `pumpAndSettle` would never return — it would spin until it timed out.
///
/// Pump a bounded number of frames instead. Several are needed rather than
/// one: the setup flow chains microtask → async repository call → `ref.listen`
/// → navigation, and each hop only flushes on the next pump.
Future<void> _settleAnimations(WidgetTester tester) async {
  await tester.pump();
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 400));
  }
}

/// Stands in for the real repository so tests never touch `flutter_gemma`
/// (which needs an engine registered and a 2.6 GB model on disk).
class _FakeModelRepository implements ModelRepository {
  _FakeModelRepository({this.installed = true});

  final bool installed;
  bool loadCalled = false;

  @override
  Future<bool> isModelInstalled() async => installed;

  @override
  Future<String?> findSideloadedModel() async => null;

  @override
  Future<void> installFromFile(String path) async {}

  @override
  Future<void> downloadModel({
    required void Function(int percent) onProgress,
    CancelToken? cancelToken,
  }) async {
    onProgress(100);
  }

  @override
  Future<void> loadModel() async {
    loadCalled = true;
  }
}

class _FakeConnectivity implements Connectivity {
  _FakeConnectivity(this.result);

  final ConnectivityResult result;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => [result];

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      Stream.value([result]);
}

/// Fresh in-memory preferences per test, with the onboarding flag unset so
/// every test starts from the Get Started screen unless it says otherwise.
Future<SharedPreferences> _prefs({bool hasSeenGetStarted = false}) async {
  SharedPreferences.setMockInitialValues({
    'has_seen_get_started': hasSeenGetStarted,
  });
  return SharedPreferences.getInstance();
}

Widget _app({
  required SharedPreferences preferences,
  ModelRepository? repository,
  ConnectivityResult connectivity = ConnectivityResult.wifi,
}) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(preferences),
      modelRepositoryProvider.overrideWithValue(
        repository ?? _FakeModelRepository(),
      ),
      connectivityProvider.overrideWithValue(_FakeConnectivity(connectivity)),
    ],
    child: const LinguagoApp(),
  );
}

void main() {
  testWidgets('App launches to the Get Started screen', (tester) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(_app(preferences: await _prefs()));
    await _settleAnimations(tester);

    expect(find.text('Break Free\nfrom Language\nBarriers'), findsOneWidget);
  });

  testWidgets('a returning user skips Get Started entirely', (tester) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(
      _app(
        preferences: await _prefs(hasSeenGetStarted: true),
        repository: _FakeModelRepository(installed: false),
      ),
    );
    await _settleAnimations(tester);

    expect(find.text('Break Free\nfrom Language\nBarriers'), findsNothing);
    expect(find.text('Set up offline translation'), findsOneWidget);
  });

  testWidgets('finishing Get Started records that it was seen', (tester) async {
    _usePhoneViewport(tester);
    final preferences = await _prefs();
    await tester.pumpWidget(
      _app(
        preferences: preferences,
        repository: _FakeModelRepository(installed: false),
      ),
    );
    await _settleAnimations(tester);

    expect(preferences.getBool('has_seen_get_started'), isFalse);

    await tester.tap(find.byType(FloatingActionButton));
    await _settleAnimations(tester);

    expect(
      preferences.getBool('has_seen_get_started'),
      isTrue,
      reason: 'the flag must persist, or the intro reappears every launch',
    );
  });

  testWidgets('Get Started CTA opens model setup', (tester) async {
    _usePhoneViewport(tester);
    // Not installed, so setup stops at the download prompt instead of
    // forwarding straight through to home.
    await tester.pumpWidget(
      _app(
        preferences: await _prefs(),
        repository: _FakeModelRepository(installed: false),
      ),
    );
    await _settleAnimations(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await _settleAnimations(tester);

    expect(find.text('Set up offline translation'), findsOneWidget);
    expect(find.textContaining('Download'), findsWidgets);
  });

  testWidgets('An already-installed model loads and forwards to home',
      (tester) async {
    _usePhoneViewport(tester);
    final repository = _FakeModelRepository(installed: true);
    await tester.pumpWidget(
      _app(preferences: await _prefs(), repository: repository),
    );
    await _settleAnimations(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await _settleAnimations(tester);

    expect(repository.loadCalled, isTrue);
    // Asserts on the screen rather than a heading string — the copy on that
    // screen is still being iterated and shouldn't break this test.
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Cellular connections get a data warning before downloading',
      (tester) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(
      _app(
        preferences: await _prefs(),
        repository: _FakeModelRepository(installed: false),
        connectivity: ConnectivityResult.mobile,
      ),
    );
    await _settleAnimations(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await _settleAnimations(tester);

    expect(find.textContaining("You're on cellular data"), findsOneWidget);
  });
}
