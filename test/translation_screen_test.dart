import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:linguago/core/storage/app_preferences.dart';
import 'package:linguago/features/translation/data/models/language.dart';
import 'package:linguago/features/translation/data/models/translation_result.dart';
import 'package:linguago/features/translation/data/translation_repository.dart';
import 'package:linguago/features/translation/view/translation_screen.dart';
import 'package:linguago/features/translation/viewmodel/translation_viewmodel.dart';

/// Stands in for the Gemma pipeline so the screen can be driven without a
/// model on disk.
class _FakeRepository implements TranslationRepository {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> startRecording() async {}

  @override
  Future<void> stopRecording() async {}

  @override
  Future<TranslationResult> translate({
    required Language source,
    required Language target,
  }) async {
    return TranslationResult(
      sourceLanguage: source.code,
      targetLanguage: target.code,
      transcription: 'Hello there',
      translation: 'Bonjour',
    );
  }

  @override
  Future<TranslationResult> translateText({
    required String text,
    required Language source,
    required Language target,
  }) async {
    return TranslationResult(
      sourceLanguage: source.code,
      targetLanguage: target.code,
      transcription: text,
      translation: 'Bonjour',
    );
  }

  @override
  Future<void> speak(String text, Language language) async {}

  @override
  Future<void> stopSpeaking() async {}
}

Widget _screen(SharedPreferences preferences) => ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        translationRepositoryProvider.overrideWithValue(_FakeRepository()),
      ],
      child: const MaterialApp(home: TranslationScreen()),
    );

Future<SharedPreferences> _prefs() async {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}

void main() {
  testWidgets('the swap button reverses the language pair', (tester) async {
    tester.view.devicePixelRatio = 3.0;
    tester.view.physicalSize = const Size(390, 844) * 3.0;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_screen(await _prefs()));
    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(TranslationScreen)),
    );

    expect(container.read(translationViewModelProvider).sourceLanguage.code, 'en');
    expect(container.read(translationViewModelProvider).targetLanguage.code, 'fr');

    await tester.tap(find.byIcon(Icons.sync_alt_rounded));
    await tester.pump();

    expect(
      container.read(translationViewModelProvider).sourceLanguage.code,
      'fr',
      reason: 'tapping swap should make French the source',
    );
    expect(container.read(translationViewModelProvider).targetLanguage.code, 'en');
  });

  testWidgets('setLanguagePair sets both halves, even when reversed',
      (tester) async {
    tester.view.devicePixelRatio = 3.0;
    tester.view.physicalSize = const Size(390, 844) * 3.0;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_screen(await _prefs()));
    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(TranslationScreen)),
    );
    final viewModel = container.read(translationViewModelProvider.notifier);

    // fr→en overlaps the current en→fr on both sides. Calling the two setters
    // in sequence would drop a half, because each rejects a language already
    // used on the other side.
    viewModel.setLanguagePair(
      source: SupportedLanguages.french,
      target: SupportedLanguages.english,
    );
    await tester.pump();

    final state = container.read(translationViewModelProvider);
    expect(state.sourceLanguage.code, 'fr');
    expect(state.targetLanguage.code, 'en');
  });

  testWidgets('swapping clears a stale result', (tester) async {
    tester.view.devicePixelRatio = 3.0;
    tester.view.physicalSize = const Size(390, 844) * 3.0;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_screen(await _prefs()));
    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(TranslationScreen)),
    );
    final viewModel = container.read(translationViewModelProvider.notifier);

    // Produce a result the way the UI would.
    await viewModel.onMicPressed();
    await viewModel.onMicPressed();
    await tester.pump();
    expect(container.read(translationViewModelProvider).translation, 'Bonjour');

    await tester.tap(find.byIcon(Icons.sync_alt_rounded));
    await tester.pump();

    // The old text belonged to the previous direction; leaving it on screen
    // under swapped labels shows the user French sitting in an English pane.
    expect(
      container.read(translationViewModelProvider).translation,
      isNull,
      reason: 'a swap invalidates the previous direction\'s result',
    );
    expect(container.read(translationViewModelProvider).transcription, isNull);
  });
}
