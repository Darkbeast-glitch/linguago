/// App-wide constants that don't belong to any single feature.
class AppConstants {
  const AppConstants._();

  static const String appName = 'Linguago';

  /// Keep MVP recordings short to improve perceived responsiveness (PRD §24).
  static const int maxRecordingSeconds = 15;
}
