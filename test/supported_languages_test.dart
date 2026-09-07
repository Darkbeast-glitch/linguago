import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:linguago/features/translation/data/models/language.dart';

void main() {
  group('SupportedLanguages', () {
    test('every enabled language has a region-qualified TTS locale', () {
      // Platform speech engines match on region — a bare "fr" finds no voice,
      // so an entry added without one would look supported and then silently
      // fail to speak.
      for (final language in SupportedLanguages.enabled) {
        expect(
          language.ttsLocale,
          matches(RegExp(r'^[a-z]{2}-[A-Z]{2}$')),
          reason: '${language.displayName} needs a locale like "fr-FR"',
        );
        expect(
          language.ttsLocale.startsWith(language.code),
          isTrue,
          reason:
              '${language.displayName}: locale ${language.ttsLocale} does not '
              'match code ${language.code}',
        );
      }
    });

    test('every declared flag asset exists on disk, with exact casing', () {
      // Asset paths are case-sensitive on device builds even though macOS's
      // filesystem is not, so a wrong path passes locally and shows a fallback
      // badge on a real phone. `File.exists` is case-insensitive on macOS too,
      // hence the directory listing comparison.
      final present = Directory('assets/Images')
          .listSync()
          .whereType<File>()
          .map((f) => f.uri.pathSegments.last)
          .toSet();

      for (final language in SupportedLanguages.all) {
        final asset = language.flagAsset;
        if (asset == null) continue;

        expect(
          asset,
          startsWith('assets/Images/'),
          reason: '${language.displayName}: flags live in assets/Images/',
        );
        expect(
          present,
          contains(asset.split('/').last),
          reason: '${language.displayName}: $asset is missing or misspelled',
        );
      }
    });

    test('every enabled language has flag artwork', () {
      // A lettered badge is an acceptable fallback, not a destination — this
      // fails when a language ships without artwork so it isn't forgotten.
      final missing = SupportedLanguages.enabled
          .where((l) => l.flagAsset == null)
          .map((l) => l.displayName)
          .toList();

      expect(missing, isEmpty, reason: 'no flag asset for: ${missing.join(', ')}');
    });

    test('language codes are unique', () {
      final codes = SupportedLanguages.all.map((l) => l.code).toList();
      expect(codes.toSet().length, codes.length, reason: 'duplicate code');
    });

    test('byCode falls back to English rather than throwing', () {
      // Stored preferences can hold a code from a language that was later
      // removed or disabled; that must not stop the app from starting.
      expect(SupportedLanguages.byCode('es').code, 'es');
      expect(SupportedLanguages.byCode('nonsense').code, 'en');
      expect(
        SupportedLanguages.byCode('ee').code,
        'en',
        reason: 'a disabled language is not a valid selection',
      );
    });

    test('search matches display name and code, and includes disabled ones', () {
      expect(SupportedLanguages.search('span').single.code, 'es');
      expect(SupportedLanguages.search('JA').map((l) => l.code), contains('ja'));

      // Disabled languages stay visible so the user learns they exist but
      // aren't ready, rather than assuming a typo.
      expect(SupportedLanguages.search('ewe').single.isEnabled, isFalse);
      expect(SupportedLanguages.search('').length, SupportedLanguages.all.length);
    });

    test('English and French remain enabled', () {
      // The pipeline was proven on this pair; losing it would invalidate every
      // benchmark recorded in the docs.
      final codes = SupportedLanguages.enabled.map((l) => l.code);
      expect(codes, containsAll(<String>['en', 'fr']));
    });
  });
}
