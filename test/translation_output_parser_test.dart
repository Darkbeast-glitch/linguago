import 'package:flutter_test/flutter_test.dart';
import 'package:linguago/core/errors/app_exception.dart';
import 'package:linguago/features/translation/data/translation_output_parser.dart';

void main() {
  group('TranslationOutputParser', () {
    test('parses the exact format the prompt asks for', () {
      final result = TranslationOutputParser.parse(
        'Transcription: Where is the nearest pharmacy?\n'
        'Translation: Où est la pharmacie la plus proche ?',
      );

      expect(result.transcription, 'Where is the nearest pharmacy?');
      expect(result.translation, 'Où est la pharmacie la plus proche ?');
    });

    test('tolerates markdown bold around the labels', () {
      final result = TranslationOutputParser.parse(
        '**Transcription:** Hello there\n**Translation:** Bonjour',
      );

      expect(result.transcription, 'Hello there');
      expect(result.translation, 'Bonjour');
    });

    test('tolerates code fences', () {
      final result = TranslationOutputParser.parse(
        '```\nTranscription: Good morning\nTranslation: Bonjour\n```',
      );

      expect(result.transcription, 'Good morning');
      expect(result.translation, 'Bonjour');
    });

    test('accepts French labels when translating into French', () {
      final result = TranslationOutputParser.parse(
        'Transcription : Bonjour\nTraduction : Hello',
      );

      expect(result.transcription, 'Bonjour');
      expect(result.translation, 'Hello');
    });

    test('rejoins a sentence the model wrapped across lines', () {
      final result = TranslationOutputParser.parse(
        'Transcription: Where is the nearest\npharmacy in this town?\n'
        'Translation: Où est la pharmacie\nla plus proche de cette ville ?',
      );

      expect(result.transcription, 'Where is the nearest pharmacy in this town?');
      expect(
        result.translation,
        'Où est la pharmacie la plus proche de cette ville ?',
      );
    });

    test('accepts two bare lines, which is what Gemma 4 actually returns', () {
      // Verbatim from a real on-device run (Galaxy S22+, en->fr): the model
      // ignores the requested labels and answers positionally.
      final result = TranslationOutputParser.parse(
        "Hello, I'm a bit tired.\nBonjour, je suis un peu fatigué.",
      );

      expect(result.transcription, "Hello, I'm a bit tired.");
      expect(result.translation, 'Bonjour, je suis un peu fatigué.');
    });

    test('labels still win when the model does use them', () {
      // The unlabelled fallback must not shadow a labelled reply.
      final result = TranslationOutputParser.parse(
        'Transcription: Good morning\nTranslation: Bonjour',
      );

      expect(result.transcription, 'Good morning');
      expect(result.translation, 'Bonjour');
    });

    test('refuses three bare lines as too ambiguous to guess at', () {
      expect(
        () => TranslationOutputParser.parse('One line\nTwo line\nThree line'),
        throwsA(isA<TranslationFailedException>()),
      );
    });

    test('throws when only one of the two fields is present', () {
      expect(
        () => TranslationOutputParser.parse('Translation: Bonjour'),
        throwsA(isA<TranslationFailedException>()),
      );
    });

    test('throws when the reply has no recognisable structure', () {
      expect(
        () => TranslationOutputParser.parse(
          "I'm sorry, I didn't understand that request.",
        ),
        throwsA(isA<TranslationFailedException>()),
      );
    });

    test('treats an entirely empty reply as unheard speech', () {
      expect(
        () => TranslationOutputParser.parse('   \n  '),
        throwsA(isA<EmptySpeechException>()),
      );
    });

    test('treats present-but-empty fields as unheard speech', () {
      expect(
        () => TranslationOutputParser.parse('Transcription:\nTranslation:'),
        throwsA(isA<EmptySpeechException>()),
      );
    });
  });
}
