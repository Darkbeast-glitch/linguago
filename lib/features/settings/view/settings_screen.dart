import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_router.dart';
import '../../../app/app_theme.dart';
import '../../../core/storage/app_preferences.dart';
import '../../translation/data/models/language.dart';
import '../../translation/data/models/tts_voice.dart';
import '../../translation/viewmodel/translation_viewmodel.dart';
import '../viewmodel/settings_viewmodel.dart';

/// Kept minimal per PRD §25 — no accounts, no cloud settings.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsViewModelProvider);
    final settingsViewModel = ref.read(settingsViewModelProvider.notifier);
    final isModelReady = ref.watch(
      translationViewModelProvider.select((s) => s.isModelReady),
    );
    final speechLanguage = SupportedLanguages.byCode(
      settings.preferredTargetLanguageCode,
    );
    final voices = ref.watch(speechVoicesProvider(speechLanguage.code));

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _SectionLabel('Speech'),
          SwitchListTile(
            activeThumbColor: AppColors.primaryPurple,
            title: const Text('Auto-play translated speech'),
            value: settings.autoPlayTranslatedSpeech,
            onChanged: settingsViewModel.setAutoPlay,
          ),
          ListTile(
            title: const Text('Speech speed'),
            subtitle: Text('${(settings.speechRate * 100).round()}%'),
          ),
          Slider(
            value: settings.speechRate,
            min: AppPreferences.minSpeechRate,
            max: AppPreferences.maxSpeechRate,
            divisions: 10,
            label: '${(settings.speechRate * 100).round()}%',
            onChanged: settingsViewModel.setSpeechRate,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Slower', style: TextStyle(color: AppColors.textGray)),
                Text('Faster', style: TextStyle(color: AppColors.textGray)),
              ],
            ),
          ),
          ListTile(
            title: Text('${speechLanguage.displayName} voice'),
            subtitle: const Text('Choose a voice installed on this device'),
          ),
          voices.when(
            data: (availableVoices) {
              final savedVoiceId =
                  settings.speechVoiceIdsByLanguageCode[speechLanguage.code];
              final selectedVoiceIsAvailable = availableVoices.any(
                (voice) => voice.id == savedVoiceId,
              );

              void onVoiceChanged(String? voiceId) =>
                  settingsViewModel.setSpeechVoice(
                    speechLanguage,
                    voiceId == null || voiceId.isEmpty ? null : voiceId,
                  );

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // iOS: native bottom action sheet
                    if (defaultTargetPlatform == TargetPlatform.iOS)
                      _IosVoicePicker(
                        voices: availableVoices,
                        savedVoiceId:
                            selectedVoiceIsAvailable ? savedVoiceId : null,
                        onChanged:
                            availableVoices.isEmpty ? null : onVoiceChanged,
                      )
                    // Android / other: Material dropdown
                    else
                      DropdownButtonFormField<String>(
                        key: ValueKey(
                          '${speechLanguage.code}:${savedVoiceId ?? ''}',
                        ),
                        initialValue:
                            selectedVoiceIsAvailable ? savedVoiceId : '',
                        decoration: const InputDecoration(
                          labelText: 'Offline voice',
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: '',
                            child: Text('Automatic local voice'),
                          ),
                          ...availableVoices.map(
                            (voice) => DropdownMenuItem(
                              value: voice.id,
                              child: Text(voice.name),
                            ),
                          ),
                        ],
                        onChanged: availableVoices.isEmpty
                            ? null
                            : onVoiceChanged,
                      ),
                    if (savedVoiceId != null && !selectedVoiceIsAvailable)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Your saved voice is no longer available offline. '
                          'Choose another voice.',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    if (availableVoices.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'No offline voice is installed for this language.',
                          style: TextStyle(color: AppColors.textGray),
                        ),
                      ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: availableVoices.isEmpty
                            ? null
                            : () async {
                                try {
                                  await settingsViewModel.previewSpeech(
                                    speechLanguage,
                                  );
                                } catch (_) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Could not play an offline voice. '
                                        'Check the voices installed on this device.',
                                      ),
                                    ),
                                  );
                                }
                              },
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Preview voice'),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (error, stackTrace) => const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Could not read the offline voices on this device.',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ),
          const Divider(),
          const _SectionLabel('Model'),
          ListTile(
            leading: Icon(
              isModelReady ? Icons.check_circle : Icons.hourglass_bottom,
              color: isModelReady
                  ? AppColors.accentGreen
                  : AppColors.highlightYellow,
            ),
            title: Text(
              isModelReady
                  ? 'On-device model ready'
                  : 'Preparing on-device model\u2026',
            ),
          ),
          const Divider(),
          const _SectionLabel('About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Linguago'),
            subtitle: Text(
              'Offline voice translation. No accounts, no cloud, no chat history.',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy'),
            subtitle: const Text(
              'Audio is processed on-device and never uploaded.',
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.privacy),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// iOS-native voice picker
// ─────────────────────────────────────────────────────────────────────────────

/// A tappable row that slides up a [CupertinoActionSheet] on iOS, showing all
/// available offline voices. Mirrors the native iOS system picker style.
class _IosVoicePicker extends StatelessWidget {
  const _IosVoicePicker({
    required this.voices,
    required this.savedVoiceId,
    required this.onChanged,
  });

  final List<TtsVoice> voices;
  final String? savedVoiceId;
  final ValueChanged<String?>? onChanged;

  String get _currentLabel {
    if (voices.isEmpty) return 'No offline voices available';
    if (savedVoiceId == null) return 'Automatic local voice';
    return voices
        .firstWhere(
          (v) => v.id == savedVoiceId,
          orElse: () => voices.first,
        )
        .name;
  }

  Future<void> _show(BuildContext context) async {
    if (onChanged == null) return;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Offline voice'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(ctx).pop();
              onChanged?.call(null);
            },
            isDefaultAction: savedVoiceId == null,
            child: const Text('Automatic local voice'),
          ),
          ...voices.map(
            (voice) => CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(ctx).pop();
                onChanged?.call(voice.id);
              },
              isDefaultAction: voice.id == savedVoiceId,
              child: Text(voice.name),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged == null ? null : () => _show(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Offline voice',
                    style: TextStyle(fontSize: 12, color: AppColors.textGray),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _currentLabel,
                    style: TextStyle(
                      fontSize: 16,
                      color: onChanged == null
                          ? AppColors.textGray
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_up_chevron_down,
              size: 16,
              color: onChanged == null
                  ? AppColors.textGray.withValues(alpha: 0.4)
                  : AppColors.textGray,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textGray,
          fontSize: 13,
        ),
      ),
    );
  }
}
