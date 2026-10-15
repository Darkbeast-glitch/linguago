import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:linguago/core/errors/app_exception.dart';
import 'package:linguago/core/storage/app_preferences.dart';
import 'package:linguago/features/translation/data/datasources/tts_datasource.dart';
import 'package:linguago/features/translation/data/models/language.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('flutter_tts');

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('lists only on-device voices for the requested language', () async {
    _mockVoices(channel, [
      {'name': 'English local', 'locale': 'en-US', 'network_required': '0'},
      {'name': 'English online', 'locale': 'en-US', 'network_required': '1'},
      {'name': 'French local', 'locale': 'fr-FR', 'network_required': '0'},
    ]);
    final preferences = AppPreferences(await SharedPreferences.getInstance());
    final source = TtsDataSource(preferences: preferences, tts: FlutterTts());

    final voices = await source.availableVoices(SupportedLanguages.english);

    expect(voices.map((voice) => voice.name), ['English local']);
  });

  test('applies the saved local voice and speech rate', () async {
    final calls = <MethodCall>[];
    _mockVoices(channel, [
      {'name': 'English local', 'locale': 'en-US', 'network_required': '0'},
      {'name': 'English online', 'locale': 'en-US', 'network_required': '1'},
    ], calls: calls);
    final preferences = AppPreferences(await SharedPreferences.getInstance());
    await preferences.setSpeechVoiceId(
      languageCode: 'en',
      voiceId: 'en-US::English local',
    );
    await preferences.setSpeechRate(0.6);
    final source = TtsDataSource(preferences: preferences, tts: FlutterTts());

    await source.speak('Hello.', SupportedLanguages.english);

    expect(
      calls.any(
        (call) =>
            call.method == 'setVoice' &&
            (call.arguments as Map)['name'] == 'English local',
      ),
      isTrue,
    );
    expect(
      calls.any(
        (call) => call.method == 'setSpeechRate' && call.arguments == 0.6,
      ),
      isTrue,
    );
    expect(calls.any((call) => call.method == 'speak'), isTrue);
  });

  test(
    'does not speak when only network-dependent voices are available',
    () async {
      final calls = <MethodCall>[];
      _mockVoices(channel, [
        {'name': 'English online', 'locale': 'en-US', 'network_required': '1'},
      ], calls: calls);
      final preferences = AppPreferences(await SharedPreferences.getInstance());
      final source = TtsDataSource(preferences: preferences, tts: FlutterTts());

      await expectLater(
        source.speak('Hello.', SupportedLanguages.english),
        throwsA(isA<TtsUnavailableException>()),
      );
      expect(calls.any((call) => call.method == 'speak'), isFalse);
    },
  );
}

void _mockVoices(
  MethodChannel channel,
  List<Map<String, String>> voices, {
  List<MethodCall>? calls,
}) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
        calls?.add(call);
        switch (call.method) {
          case 'getVoices':
            return voices;
          case 'awaitSpeakCompletion':
          case 'setVoice':
          case 'setSpeechRate':
          case 'speak':
          case 'stop':
            return 1;
          case 'getLanguages':
          case 'isLanguageInstalled':
          case 'isLanguageAvailable':
          case 'getEngines':
            return null;
          default:
            return null;
        }
      });
}
