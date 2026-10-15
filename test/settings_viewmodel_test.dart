import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:linguago/core/storage/app_preferences.dart';
import 'package:linguago/features/settings/view/settings_screen.dart';
import 'package:linguago/features/settings/viewmodel/settings_viewmodel.dart';
import 'package:linguago/features/translation/data/models/language.dart';
import 'package:linguago/features/translation/data/translation_repository_impl.dart';
import 'package:linguago/features/translation/data/translation_repository_provider.dart';

class _ImmediateTranslationRepository extends FakeTranslationRepositoryImpl {
  @override
  Future<void> initialize() async {}
}

void main() {
  test('speech rate and per-language voice persist locally', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        translationRepositoryProvider.overrideWithValue(
          _ImmediateTranslationRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final viewModel = container.read(settingsViewModelProvider.notifier);
    await viewModel.setSpeechRate(0.65);
    await viewModel.setSpeechVoice(SupportedLanguages.french, 'voice-fr-1');

    expect(container.read(settingsViewModelProvider).speechRate, 0.65);
    expect(
      container
          .read(settingsViewModelProvider)
          .speechVoiceIdsByLanguageCode['fr'],
      'voice-fr-1',
    );
    expect(preferences.getDouble('speech_rate'), 0.65);
    expect(preferences.getString('speech_voice_fr'), 'voice-fr-1');
  });

  testWidgets('settings show speed and offline voice controls', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
          translationRepositoryProvider.overrideWithValue(
            _ImmediateTranslationRepository(),
          ),
        ],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Speech speed'), findsOneWidget);
    expect(find.text('French voice'), findsOneWidget);
    expect(
      find.text('No offline voice is installed for this language.'),
      findsOneWidget,
    );
    expect(find.text('Preview voice'), findsOneWidget);
  });
}
