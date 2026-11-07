import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Overridden in `main()` with the instance loaded before the app starts.
///
/// Resolving it up front rather than asynchronously inside the widget tree is
/// what lets the first frame land on the right screen — a returning user never
/// sees Get Started flash by before being redirected away from it.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw StateError(
    'sharedPreferencesProvider must be overridden in main() with the '
    'instance from SharedPreferences.getInstance().',
  );
});

final appPreferencesProvider = Provider<AppPreferences>((ref) {
  return AppPreferences(ref.watch(sharedPreferencesProvider));
});

/// Small, local, on-device key/value storage. Nothing here leaves the phone,
/// and nothing here is speech content (PRD §23).
class AppPreferences {
  AppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _kHasSeenGetStarted = 'has_seen_get_started';
  static const _kAutoPlaySpeech = 'auto_play_translated_speech';
  static const _kSpeechRate = 'speech_rate';
  static const _kSourceLanguage = 'preferred_source_language';
  static const _kTargetLanguage = 'preferred_target_language';
  static const defaultSpeechRate = 0.45;
  static const minSpeechRate = 0.12;
  static const maxSpeechRate = 0.85;

  bool get hasSeenGetStarted => _prefs.getBool(_kHasSeenGetStarted) ?? false;

  Future<void> setHasSeenGetStarted(bool value) =>
      _prefs.setBool(_kHasSeenGetStarted, value);

  bool get autoPlayTranslatedSpeech => _prefs.getBool(_kAutoPlaySpeech) ?? true;

  Future<void> setAutoPlayTranslatedSpeech(bool value) =>
      _prefs.setBool(_kAutoPlaySpeech, value);

  double get speechRate => (_prefs.getDouble(_kSpeechRate) ?? defaultSpeechRate)
      .clamp(minSpeechRate, maxSpeechRate)
      .toDouble();

  Future<void> setSpeechRate(double value) => _prefs.setDouble(
    _kSpeechRate,
    value.clamp(minSpeechRate, maxSpeechRate).toDouble(),
  );

  String? speechVoiceId(String languageCode) =>
      _prefs.getString('speech_voice_$languageCode');

  Future<void> setSpeechVoiceId({
    required String languageCode,
    required String? voiceId,
  }) async {
    final key = 'speech_voice_$languageCode';
    if (voiceId == null) {
      await _prefs.remove(key);
    } else {
      await _prefs.setString(key, voiceId);
    }
  }

  String get sourceLanguageCode => _prefs.getString(_kSourceLanguage) ?? 'en';

  String get targetLanguageCode => _prefs.getString(_kTargetLanguage) ?? 'fr';

  Future<void> setLanguagePair({
    required String source,
    required String target,
  }) async {
    await _prefs.setString(_kSourceLanguage, source);
    await _prefs.setString(_kTargetLanguage, target);
  }

  // ── Recent languages ────────────────────────────────────────────────────────

  static const _kRecentLanguages = 'recent_language_codes';

  /// Maximum number of codes kept. Oldest entries are evicted once the list
  /// would exceed this, so the row never grows unbounded.
  static const int maxRecent = 8;

  /// Ordered list of recently-used target language codes, most-recent first.
  List<String> get recentLanguageCodes =>
      _prefs.getStringList(_kRecentLanguages) ?? [];

  /// Prepends [code] to the list, de-duplicates, and trims to [maxRecent].
  Future<void> addRecentLanguage(String code) async {
    final updated = [
      code,
      ...recentLanguageCodes.where((c) => c != code),
    ].take(maxRecent).toList();
    await _prefs.setStringList(_kRecentLanguages, updated);
  }

  // ── The Expert Class & Streak Tracking ─────────────────────────────────────

  static const _kExpertLanguageCode = 'expert_target_language_code';
  static const _kExpertLevel = 'expert_level';
  static const _kExpertCurrentDay = 'expert_current_day';
  static const _kExpertCompletedDays = 'expert_completed_days';
  static const _kStreakCount = 'expert_streak_count';
  static const _kLongestStreak = 'expert_longest_streak';
  static const _kLastStreakDate = 'expert_last_streak_date';
  static const _kExpertActivityDates = 'expert_activity_dates';

  String? get expertLanguageCode => _prefs.getString(_kExpertLanguageCode);

  Future<void> setExpertLanguageCode(String? code) async {
    if (code == null) {
      await _prefs.remove(_kExpertLanguageCode);
    } else {
      await _prefs.setString(_kExpertLanguageCode, code);
    }
  }

  String get expertLevel => _prefs.getString(_kExpertLevel) ?? 'beginner';

  Future<void> setExpertLevel(String level) =>
      _prefs.setString(_kExpertLevel, level);

  int get expertCurrentDay => (_prefs.getInt(_kExpertCurrentDay) ?? 1).clamp(1, 60);

  Future<void> setExpertCurrentDay(int day) =>
      _prefs.setInt(_kExpertCurrentDay, day.clamp(1, 60));

  Set<int> get expertCompletedDays {
    final list = _prefs.getStringList(_kExpertCompletedDays) ?? [];
    return list.map((e) => int.tryParse(e)).whereType<int>().toSet();
  }

  Future<void> addExpertCompletedDay(int day) async {
    final updated = expertCompletedDays..add(day);
    await _prefs.setStringList(
      _kExpertCompletedDays,
      updated.map((e) => e.toString()).toList(),
    );
    // If the completed day was the current active day and not 60, bump to next day
    if (day == expertCurrentDay && day < 60) {
      await setExpertCurrentDay(day + 1);
    }
  }

  int get streakCount => _prefs.getInt(_kStreakCount) ?? 0;

  int get longestStreak => _prefs.getInt(_kLongestStreak) ?? 0;

  String? get lastStreakDate => _prefs.getString(_kLastStreakDate);

  Set<String> get expertActivityDates {
    final list = _prefs.getStringList(_kExpertActivityDates) ?? [];
    return list.toSet();
  }

  Future<void> addExpertActivityDate(String yyyyMmDd) async {
    final updated = expertActivityDates..add(yyyyMmDd);
    await _prefs.setStringList(_kExpertActivityDates, updated.toList());
  }

  bool get isStreakCompletedToday {
    final today = _formatDate(DateTime.now());
    return lastStreakDate == today;
  }

  /// Updates streak upon completing a daily learning session.
  /// Returns the updated streak count.
  Future<int> recordDailyActivity() async {
    final now = DateTime.now();
    final today = _formatDate(now);
    final yesterday = _formatDate(now.subtract(const Duration(days: 1)));
    final last = lastStreakDate;

    int newStreak;
    if (last == today) {
      // Already counted today
      newStreak = streakCount > 0 ? streakCount : 1;
    } else if (last == yesterday) {
      // Consecutive day!
      newStreak = streakCount + 1;
    } else {
      // First day or streak broken
      newStreak = 1;
    }

    final newLongest = newStreak > longestStreak ? newStreak : longestStreak;

    await _prefs.setInt(_kStreakCount, newStreak);
    await _prefs.setInt(_kLongestStreak, newLongest);
    await _prefs.setString(_kLastStreakDate, today);
    await addExpertActivityDate(today);

    return newStreak;
  }

  static String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
