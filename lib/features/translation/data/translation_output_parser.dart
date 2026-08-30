import '../../../core/errors/app_exception.dart';

/// Pulls the transcription and translation back out of the model's reply.
///
/// The prompt asks for exactly:
///
/// ```
/// Transcription: <source text>
/// Translation: <target text>
/// ```
///
/// but a language model will not always comply — it may wrap the reply in
/// markdown, restate the labels in the target language, or add a stray
/// preamble. Parsing is therefore deliberately forgiving about *formatting*
/// while staying strict about the *outcome*: if both fields can't be
/// recovered, that's a failed translation, not a half-good one to show the
/// user (PRD §10 step 9).
abstract final class TranslationOutputParser {
  /// Matches `Transcription:` / `Transcript:` and the French `Transcription :`
  /// (which puts a space before the colon).
  static final _transcriptionLabel =
      RegExp(r'^\s*\**\s*(transcription|transcript)\s*\**\s*:', caseSensitive: false);

  /// Matches `Translation:` and the French `Traduction :`.
  static final _translationLabel =
      RegExp(r'^\s*\**\s*(translation|traduction)\s*\**\s*:', caseSensitive: false);

  /// Throws [EmptySpeechException] when the model heard nothing usable, and
  /// [TranslationFailedException] when the reply can't be understood.
  /// [sourceName] and [targetName] are the languages' display names, used to
  /// strip labels the model invents for itself — it frequently answers
  /// `English: ...` / `French: ...` instead of the labels it was asked for,
  /// and those names would otherwise end up inside the translated text.
  static ({String transcription, String translation}) parse(
    String raw, {
    String? sourceName,
    String? targetName,
  }) {
    final cleaned = _stripCodeFences(raw).trim();
    if (cleaned.isEmpty) {
      throw const EmptySpeechException();
    }

    String? transcription;
    String? translation;
    // Tracks which field trailing (wrapped) lines belong to.
    String? current;

    for (final line in cleaned.split('\n')) {
      if (_transcriptionLabel.hasMatch(line)) {
        transcription = _afterLabel(line);
        current = 'transcription';
      } else if (_translationLabel.hasMatch(line)) {
        translation = _afterLabel(line);
        current = 'translation';
      } else if (line.trim().isNotEmpty) {
        // Continuation of whichever field we're inside — the model wrapped a
        // long sentence across lines.
        switch (current) {
          case 'transcription':
            transcription = _join(transcription, line);
          case 'translation':
            translation = _join(translation, line);
        }
      }
    }

    transcription = transcription?.trim();
    translation = translation?.trim();

    // Gemma 4 usually ignores the requested labels and simply answers with the
    // transcription on one line and the translation on the next — measured on
    // a Galaxy S22+, e.g. "Hello, I'm a bit tired.\nBonjour, je suis un peu
    // fatigué." Refusing a correct translation over missing labels would be
    // absurd, so fall back to reading the two lines positionally.
    if (transcription == null && translation == null) {
      final lines = cleaned
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      // Exactly two lines only. Three or more is ambiguous — a wrapped
      // sentence is indistinguishable from added commentary, and guessing
      // wrong would show the user the wrong sentence, which is worse than
      // asking them to repeat themselves.
      if (lines.length == 2) {
        return (
          transcription: _stripLanguageLabel(lines[0], sourceName),
          translation: _stripLanguageLabel(lines[1], targetName),
        );
      }
    }

    if (transcription == null || translation == null) {
      throw const TranslationFailedException();
    }
    // A label the model emitted but left empty means it heard nothing.
    if (transcription.isEmpty || translation.isEmpty) {
      throw const EmptySpeechException();
    }

    return (transcription: transcription, translation: translation);
  }

  /// Takes everything after the label's colon, dropping the closing `**` when
  /// the model bolded the label as `**Transcription:**`.
  /// Reads a reply that should contain only the translation (the text-input
  /// path, where the source text is already known).
  ///
  /// Takes the first non-empty line rather than the whole reply: the model
  /// sometimes volunteers an alternative rendering or a note underneath, and
  /// pasting that into the result box would be worse than ignoring it.
  static String parseTranslationOnly(String raw, {String? targetName}) {
    final cleaned = _stripCodeFences(raw).trim();
    if (cleaned.isEmpty) throw const EmptySpeechException();

    for (final line in cleaned.split('\n')) {
      var candidate = line.trim();
      if (candidate.isEmpty) continue;

      // Strip either the requested label or a self-invented language name.
      if (_translationLabel.hasMatch(candidate)) {
        candidate = _afterLabel(candidate);
      }
      candidate = _stripLanguageLabel(candidate, targetName);

      if (candidate.isNotEmpty) return candidate;
    }

    throw const TranslationFailedException();
  }

  static String _afterLabel(String line) {
    return line
        .substring(line.indexOf(':') + 1)
        .replaceFirst(RegExp(r'^\s*\*+'), '')
        .trim();
  }

  /// Removes a leading `English:` / `French:` style label the model added.
  ///
  /// Only strips the *specific* language name in play, never any `Word:`
  /// prefix — a transcription such as "Warning: the road is closed" must keep
  /// its own words.
  static String _stripLanguageLabel(String line, String? languageName) {
    if (languageName == null || languageName.isEmpty) return line;
    final label = RegExp(
      '^\\s*\\**\\s*${RegExp.escape(languageName)}\\s*\\**\\s*:\\s*',
      caseSensitive: false,
    );
    return line.replaceFirst(label, '').trim();
  }

  static String _join(String? existing, String line) =>
      existing == null || existing.isEmpty ? line.trim() : '$existing ${line.trim()}';

  /// Drops ``` fences the model sometimes wraps structured replies in.
  static String _stripCodeFences(String raw) {
    return raw.replaceAll(RegExp(r'^\s*```[a-zA-Z]*\s*', multiLine: true), '')
        .replaceAll(RegExp(r'```\s*$', multiLine: true), '');
  }
}
