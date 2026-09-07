import 'package:flutter/material.dart';

import '../../../app/app_theme.dart';

/// The privacy policy, readable without a network connection.
///
/// Deliberately embedded rather than linked: an app whose selling point is
/// working offline shouldn't require a connection to explain how it handles
/// your data. Kept in sync with `PRIVACY.md` at the repository root.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: const [
          _Lead(
            'Linguago translates speech on your device. Your voice and your '
            'translations stay on your phone.',
          ),
          _Section(
            title: 'What we collect',
            body: 'Nothing. There is no account, no server, and no analytics, '
                'crash reporting, or advertising in this app. We cannot see '
                'your recordings, your translations, or how you use it.',
          ),
          _Section(
            title: 'Your voice',
            body: 'Recordings are written to a temporary file, read once by '
                'the on-device model, and deleted immediately afterwards. '
                'Audio is never uploaded and never reused.',
          ),
          _Section(
            title: 'The one time the network is used',
            body: 'The translation model is about 2.6 GB and is downloaded '
                'once, from huggingface.co, when you first set the app up. '
                'Hugging Face can see your IP address for that request, as '
                'with any download. Afterwards the app makes no network '
                'requests at all.',
          ),
          _Section(
            title: 'Speech playback',
            body: 'Tapping the speaker hands the translated text to your '
                "device's own speech engine. On iPhone this is synthesised "
                'on-device. On Android it depends on the engine your device '
                'is set to use — most speak offline, but some send text to '
                'their own servers. That is the engine\'s behaviour, not '
                "Linguago's, and we cannot control it.\n\n"
                'To keep everything local, install offline voice data for '
                'your language, or turn off auto-play so nothing is spoken '
                'unless you ask.',
            isImportant: true,
          ),
          _Section(
            title: 'Stored on this device',
            body: 'Your language choices, recently used languages, whether '
                'you have seen the welcome screen, the auto-play setting, and '
                'the downloaded model.\n\n'
                'No transcriptions or translations are saved. There is no '
                'history. Deleting the app removes everything, model included.',
          ),
          _Section(
            title: 'Permissions',
            body: 'Microphone — to hear the phrase you want translated, only '
                'while recording.\n\n'
                'Internet — only for the one-time model download.',
          ),
        ],
      ),
    );
  }
}

class _Lead extends StatelessWidget {
  const _Lead(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.body,
    this.isImportant = false,
  });

  final String title;
  final String body;

  /// Marks the one section a privacy-conscious reader most needs to see — the
  /// Android speech-engine caveat, which is the only way translated text can
  /// leave the device.
  final bool isImportant;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(isImportant ? 16 : 0),
      decoration: isImportant
          ? BoxDecoration(
              color: AppColors.highlightYellow.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isImportant) ...[
                const Icon(Icons.info_outline, size: 18, color: AppColors.highlightYellow),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(fontSize: 15, height: 1.5, color: AppColors.textGray),
          ),
        ],
      ),
    );
  }
}
