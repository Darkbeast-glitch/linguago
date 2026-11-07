import 'dart:math' as math;
import 'dart:typed_data';

import '../../../core/errors/app_exception.dart';
import '../../translation/data/datasources/gemma_datasource.dart';
import '../../translation/data/models/language.dart';
import '../../translation/data/translation_output_parser.dart';

enum EvaluationStatus {
  perfect,
  good,
  needsWork,
  silence,
  capturedAcoustic,
}

class PronunciationEvaluation {
  const PronunciationEvaluation({
    required this.status,
    required this.message,
    this.heardText,
    this.expectedText,
    this.accuracyScore,
  });

  final EvaluationStatus status;
  final String message;
  final String? heardText;
  final String? expectedText;
  final double? accuracyScore;

  bool get isSuccess =>
      status == EvaluationStatus.perfect ||
      status == EvaluationStatus.good;
}

class PronunciationEvaluator {
  const PronunciationEvaluator._();

  /// Evaluates speech input with voice activity detection and keyword matching.
  static Future<PronunciationEvaluation> evaluate({
    required Uint8List wavBytes,
    required String expectedText,
    required Language language,
    required GemmaDataSource gemma,
  }) async {
    // 1. Voice Activity Detection (VAD): Distinguishes sustained human voice
    // from room silence or finger clicks on the phone screen.
    final hasVoice = _hasVoiceActivity(wavBytes);
    if (!hasVoice) {
      return PronunciationEvaluation(
        status: EvaluationStatus.silence,
        message: 'No voice heard. Tap the mic and pronounce "$expectedText".',
        expectedText: expectedText,
      );
    }

    // 2. Transcribe and evaluate with Gemma when loaded
    if (gemma.isLoaded) {
      try {
        final rawReply = await gemma.translateAudio(
          audioBytes: wavBytes,
          source: language,
          target: SupportedLanguages.english,
        );

        final heardCandidate = _extractHeardText(rawReply, language);
        if (heardCandidate.isNotEmpty) {
          final isMatch = _matchesExpected(heardCandidate, expectedText);

          if (isMatch) {
            return PronunciationEvaluation(
              status: EvaluationStatus.perfect,
              heardText: heardCandidate,
              expectedText: expectedText,
              accuracyScore: 0.95,
              message: 'Spot on! Excellent pronunciation.',
            );
          } else {
            return PronunciationEvaluation(
              status: EvaluationStatus.needsWork,
              heardText: heardCandidate,
              expectedText: expectedText,
              accuracyScore: 0.35,
              message: 'You are close, but the word is "$expectedText". Give it another try!',
            );
          }
        }
      } on EmptySpeechException {
        return PronunciationEvaluation(
          status: EvaluationStatus.silence,
          message: 'No voice heard. Tap the mic and pronounce "$expectedText".',
          expectedText: expectedText,
        );
      } catch (_) {
        // Fall back below if inference encounters an issue
      }
    }

    // 3. Fallback when Gemma is not loaded or warming up
    return PronunciationEvaluation(
      status: EvaluationStatus.capturedAcoustic,
      expectedText: expectedText,
      message: 'Voice detected! Tap "Listen Audio" to compare pronunciation.',
    );
  }

  /// Voice Activity Detection: Slices audio into 30ms frames and counts voiced frames.
  /// Human speech has sustained vocal cord vibration (> 120ms) and peaks > 400.
  /// A click, screen tap, or room silence produces 0 to 1 short transient spikes.
  static bool _hasVoiceActivity(Uint8List wavBytes) {
    if (wavBytes.length < 44 + 3200) return false;
    final byteData = ByteData.sublistView(wavBytes, 44);
    final totalSamples = (wavBytes.length - 44) ~/ 2;
    if (totalSamples < 1600) return false;

    const frameSize = 480; // 30ms at 16kHz
    final numFrames = totalSamples ~/ frameSize;
    var voicedFrames = 0;
    var maxPeak = 0;

    for (var f = 0; f < numFrames; f++) {
      var frameSumSquares = 0.0;
      final start = f * frameSize;
      for (var s = 0; s < frameSize; s++) {
        final val = byteData.getInt16((start + s) * 2, Endian.little);
        final absVal = val.abs();
        if (absVal > maxPeak) maxPeak = absVal;
        frameSumSquares += val * val;
      }
      final frameRms = math.sqrt(frameSumSquares / frameSize);
      if (frameRms > 160.0) {
        voicedFrames++;
      }
    }

    return voicedFrames >= 3 && maxPeak >= 380;
  }

  /// Extracts the heard transcription from model output, handling variations.
  static String _extractHeardText(String rawReply, Language language) {
    try {
      final parsed = TranslationOutputParser.parse(
        rawReply,
        sourceName: language.displayName,
        targetName: SupportedLanguages.english.displayName,
      );
      if (parsed.transcription.trim().isNotEmpty) {
        return parsed.transcription.trim();
      }
    } catch (_) {}

    return rawReply
        .replaceAll(
          RegExp(
            r'^(transcription|translation|transcript)\s*:',
            caseSensitive: false,
            multiLine: true,
          ),
          '',
        )
        .replaceAll('*', '')
        .trim();
  }

  /// Lenient, communicative matcher:
  /// - Supports single words spoken from a pair (e.g. saying "Wein" for "Wein vs. Wien").
  /// - Supports core sentence keywords.
  /// - Supports phonetic variations.
  static bool _matchesExpected(String heardText, String expectedText) {
    final normHeard = _normalize(heardText);
    final normExpected = _normalize(expectedText);

    if (normHeard.isEmpty) return false;
    if (normHeard == normExpected) return true;
    if (normHeard.contains(normExpected) || normExpected.contains(normHeard)) return true;

    // Check individual significant target words
    final targetKeywords = normExpected
        .split(RegExp(r'\s+'))
        .where(
          (w) =>
              w.length > 2 &&
              w != 'vs' &&
              w != 'und' &&
              w != 'der' &&
              w != 'die' &&
              w != 'das' &&
              w != 'ein' &&
              w != 'eine',
        )
        .toList();

    for (final keyword in targetKeywords) {
      if (normHeard.contains(keyword)) return true;
      for (final heardWord in normHeard.split(RegExp(r'\s+'))) {
        if (_computeSimilarity(heardWord, keyword) >= 0.65) {
          return true;
        }
      }
    }

    return _computeSimilarity(normHeard, normExpected) >= 0.40;
  }

  static double _computeSimilarity(String s1, String s2) {
    final norm1 = _normalize(s1);
    final norm2 = _normalize(s2);

    if (norm1 == norm2) return 1.0;
    if (norm1.isEmpty || norm2.isEmpty) return 0.0;
    if (norm1.contains(norm2) || norm2.contains(norm1)) return 0.85;

    final distance = _levenshteinDistance(norm1, norm2);
    final maxLen = math.max(norm1.length, norm2.length);
    final score = 1.0 - (distance / maxLen);
    return score.clamp(0.0, 1.0);
  }

  static String _normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll('ß', 'ss')
        .replaceAll(RegExp(r'[^\w\säöüéèàáíóúñ]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static int _levenshteinDistance(String s1, String s2) {
    final m = s1.length;
    final n = s2.length;
    final dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

    for (var i = 0; i <= m; i++) {
      dp[i][0] = i;
    }
    for (var j = 0; j <= n; j++) {
      dp[0][j] = j;
    }

    for (var i = 1; i <= m; i++) {
      for (var j = 1; j <= n; j++) {
        if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 + math.min(dp[i - 1][j], math.min(dp[i][j - 1], dp[i - 1][j - 1]));
        }
      }
    }
    return dp[m][n];
  }
}
