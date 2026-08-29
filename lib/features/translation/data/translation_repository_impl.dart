import 'models/language.dart';
import 'models/translation_result.dart';
import 'translation_repository.dart';

/// Milestone-1 stand-in for [TranslationRepository].
///
/// Returns canned data instead of running Gemma/audio/TTS, so the UI and
/// ViewModel can be built and tested end to end before real local inference
/// is wired up (PRD "First Build Session", step 5 & 10). No network calls,
/// no disk writes — this will be swapped for an implementation backed by
/// GemmaDataSource / AudioDataSource / TtsDataSource in Milestone 2+.
class FakeTranslationRepositoryImpl implements TranslationRepository {
  @override
  Future<void> initialize() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> startRecording() async {}

  @override
  Future<void> stopRecording() async {}

  @override
  Future<TranslationResult> translate({
    required Language source,
    required Language target,
  }) async {
    final stopwatch = Stopwatch()..start();
    await Future<void>.delayed(const Duration(milliseconds: 900));
    stopwatch.stop();

    final sample = _sampleFor(source.code, target.code);

    return TranslationResult(
      sourceLanguage: source.code,
      targetLanguage: target.code,
      transcription: sample.$1,
      translation: sample.$2,
      processingDurationMs: stopwatch.elapsedMilliseconds,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> speak(String text, Language language) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> stopSpeaking() async {}

  /// PRD §5 primary example, plus its reverse for French → English.
  (String, String) _sampleFor(String sourceCode, String targetCode) {
    if (sourceCode == 'en' && targetCode == 'fr') {
      return ('Where is the nearest pharmacy?', 'Où est la pharmacie la plus proche ?');
    }
    if (sourceCode == 'fr' && targetCode == 'en') {
      return ('Où est la pharmacie la plus proche ?', 'Where is the nearest pharmacy?');
    }
    return ('(sample not available for this pair yet)', '(sample not available for this pair yet)');
  }
}
