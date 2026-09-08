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

    test('a lone transcription is recoverable, not a failure', () {
      // Verbatim from a real fr->en run: the model transcribed the speech and
      // stopped, returning no English at all. The repository translates this
      // in a second pass rather than making the user repeat themselves.
      final result = TranslationOutputParser.parse(
        'Puis si on nous a tous cette réforme débile',
        sourceName: 'French',
        targetName: 'English',
      );

      expect(result.transcription, 'Puis si on nous a tous cette réforme débile');
      expect(result.translation, isNull);
    });

    test('strips Gemma turn markers that leak into the reply', () {
      // Also seen in a real run: "<start_of_turn>model" arriving as content.
      final result = TranslationOutputParser.parse(
        'Transcription: Then if we reformed,\n'
        '<start_of_turn>model\n'
        'Translation: Puis si nous réformions,',
        sourceName: 'English',
        targetName: 'French',
      );

      expect(result.transcription, 'Then if we reformed,');
      expect(result.translation, 'Puis si nous réformions,');
      expect(result.transcription, isNot(contains('start_of_turn')));
      expect(result.translation, isNot(contains('start_of_turn')));
    });

    test('a labelled transcription with no translation is recoverable', () {
      final result = TranslationOutputParser.parse(
        'Transcription: Where is the station?',
        sourceName: 'English',
      );

      expect(result.transcription, 'Where is the station?');
      expect(result.translation, isNull);
    });

    test('throws when there is a translation but nothing was transcribed', () {
      // Nothing to feed a second pass with, so this genuinely cannot recover.
      expect(
        () => TranslationOutputParser.parse('Translation: Bonjour'),
        throwsA(isA<TranslationFailedException>()),
      );
    });

    test('a single unlabelled line is taken as a transcription', () {
      // Deliberate trade-off. A lone line used to throw, but real fr->en runs
      // return exactly that — the transcription with no translation — and
      // failing on it made a recoverable case look broken.
      //
      // The cost: if the model ever replies with a refusal instead of a
      // transcription, that refusal is treated as speech and gets translated.
      // Accepted because the transcription-only case is reproducible while a
      // refusal on the audio path has never been observed, and the user can
      // see the odd result and retype. Revisit if refusals start appearing.
      final result = TranslationOutputParser.parse(
        "I'm sorry, I didn't understand that request.",
      );
      expect(result.transcription, "I'm sorry, I didn't understand that request.");
      expect(result.translation, isNull);
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
