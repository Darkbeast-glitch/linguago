import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_theme.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../core/widgets/flag_circle.dart';
import '../../settings/viewmodel/settings_viewmodel.dart';
import '../data/models/lesson_step.dart';
import '../data/pronunciation_evaluator.dart';
import '../viewmodel/expert_class_viewmodel.dart';
import 'widgets/streak_badge.dart';

class LessonScreen extends ConsumerWidget {
  const LessonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(expertClassViewModelProvider);
    final vm = ref.read(expertClassViewModelProvider.notifier);
    final settings = ref.watch(settingsViewModelProvider);
    final lesson = state.activeLesson;

    if (lesson == null || lesson.steps.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        appBar: AppBar(title: const Text('Lesson')),
        body: const Center(child: Text('No lesson content available.')),
      );
    }

    final currentStep = lesson.steps[state.activeStepIndex];
    final totalSteps = lesson.steps.length;
    final progress = (state.activeStepIndex + 1) / totalSteps;
    final isLastStep = state.activeStepIndex == totalSteps - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar with Step Progress ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded, size: 22, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Day ${lesson.day} • Step ${state.activeStepIndex + 1}/$totalSteps',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1B4B),
                              ),
                            ),
                            StreakBadge(
                              streakCount: state.streakCount,
                              isActiveToday: state.isStreakActiveToday,
                              compact: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: const Color(0xFFE5E7EB),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF7B61FF),
                            ),
                            minHeight: 7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // ── Interactive Learning Cards ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Foreign Text Hero Bento Card (Lilac Inspiration)
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Top row: Step category tag & top-right icon badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7B61FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(_stepIcon(currentStep.type), style: const TextStyle(fontSize: 13)),
                                    const SizedBox(width: 6),
                                    Text(
                                      currentStep.title,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.graphic_eq_rounded,
                                  color: Color(0xFF7B61FF),
                                  size: 19,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Instruction
                          Text(
                            currentStep.instruction,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6D28D9),
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Main Foreign Word
                          Text(
                            currentStep.foreignText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E1B4B),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Phonetic Guide Pill
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                currentStep.phoneticGuide,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6D28D9),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // English Meaning Inside White Surface
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  currentStep.englishMeaning,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                if (currentStep.contextExample != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    currentStep.contextExample!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6B7280),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Pedagogical Explanation Bento Card (Butter Yellow Inspiration)
                    if (currentStep.explanation != null) ...[
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF9C3),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFEF08A),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.auto_awesome_rounded,
                                color: Color(0xFFCA8A04),
                                size: 19,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Phonetic Secret',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF854D0E),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    currentStep.explanation!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF713F12),
                                      height: 1.4,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Pronunciation Evaluation Feedback Card
                    if (state.evaluation != null) ...[
                      _PronunciationFeedbackCard(evaluation: state.evaluation!),
                      const SizedBox(height: 14),
                    ],

                    // Action Controls: Listen Audio + Speak & Evaluate
                    Row(
                      children: [
                        // TTS Audio Play Button
                        Expanded(
                          child: _ActionAudioButton(
                            isPlaying: state.isTtsSpeaking,
                            label: 'Listen Audio',
                            icon: Icons.volume_up_rounded,
                            color: const Color(0xFF7B61FF),
                            onTap: () => vm.speakCurrentStep(currentStep.foreignText),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Microphone Record Button
                        Expanded(
                          child: _ActionAudioButton(
                            isPlaying: state.isRecording || state.isEvaluating,
                            isLoading: state.isRecording || state.isEvaluating,
                            label: state.isEvaluating
                                ? 'Evaluating...'
                                : state.isRecording
                                    ? 'Tap to Stop'
                                    : 'Repeat / Speak',
                            icon: Icons.mic_rounded,
                            color: state.isRecording
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF00D26A),
                            onTap: state.isEvaluating ? () {} : vm.toggleRecording,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Speech Speed Slider Control
                    _SpeechSpeedControl(
                      currentRate: settings.speechRate,
                      onRateChanged: (newRate) {
                        ref.read(settingsViewModelProvider.notifier).setSpeechRate(newRate);
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // ── Bottom Action Navigation ──────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Row(
                children: [
                  if (state.activeStepIndex > 0) ...[
                    GestureDetector(
                      onTap: vm.previousStep,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (isLastStep) {
                          vm.completeCurrentLesson();
                          _showBrandedCompletionSheet(context, lesson.day, state.streakCount + 1, state);
                        } else {
                          vm.nextStep();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isLastStep ? const Color(0xFF00D26A) : const Color(0xFF1E1B4B),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLastStep ? 'Complete Day ${lesson.day}' : 'Next Step →',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBrandedCompletionSheet(
    BuildContext context,
    int day,
    int streak,
    dynamic state,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Branded Trophy & Checkmark Icon Header
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDE9FE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Color(0xFF7B61FF),
                  size: 38,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Day $day Complete!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'You finished today’s communicative module and stayed consistent.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Streak & Progress Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (state.selectedLanguage != null)
                            FlagCircle(language: state.selectedLanguage!, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            '${state.selectedLanguage?.displayName ?? "Language"} • A1 Road',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 13)),
                            const SizedBox(width: 4),
                            Text(
                              '$streak Day Streak',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEA580C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: day / 60.0,
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF7B61FF),
                      ),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Day $day of 60',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Next: Day ${day + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7B61FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Branded primary button
            GestureDetector(
              onTap: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).maybePop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1B4B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'Continue to Roadmap',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _stepIcon(LessonStepType type) {
    switch (type) {
      case LessonStepType.phonetic:
        return '🔤';
      case LessonStepType.listenRepeat:
        return '🔊';
      case LessonStepType.sentencePractice:
        return '📝';
      case LessonStepType.activeSpeaking:
        return '🗣️';
    }
  }
}

class _SpeechSpeedControl extends StatelessWidget {
  const _SpeechSpeedControl({
    required this.currentRate,
    required this.onRateChanged,
  });

  final double currentRate;
  final ValueChanged<double> onRateChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.speed_rounded, size: 18, color: Color(0xFF4B5563)),
                  SizedBox(width: 6),
                  Text(
                    'Speech Speed',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Text(
                _rateLabel(currentRate),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7B61FF),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF7B61FF),
              inactiveTrackColor: const Color(0xFFE5E7EB),
              thumbColor: const Color(0xFF7B61FF),
              overlayColor: const Color(0xFF7B61FF).withOpacity(0.12),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: currentRate.clamp(
                AppPreferences.minSpeechRate,
                AppPreferences.maxSpeechRate,
              ),
              min: AppPreferences.minSpeechRate,
              max: AppPreferences.maxSpeechRate,
              divisions: 10,
              onChanged: onRateChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => onRateChanged(0.18),
                child: _SpeedPresetPill(
                  label: '0.5x Slower',
                  isSelected: currentRate <= 0.25,
                ),
              ),
              GestureDetector(
                onTap: () => onRateChanged(0.45),
                child: _SpeedPresetPill(
                  label: '1.0x Normal',
                  isSelected: currentRate > 0.25 && currentRate < 0.58,
                ),
              ),
              GestureDetector(
                onTap: () => onRateChanged(0.65),
                child: _SpeedPresetPill(
                  label: '1.5x Faster',
                  isSelected: currentRate >= 0.58,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _rateLabel(double rate) {
    if (rate <= 0.25) return 'Slow (0.5x)';
    if (rate >= 0.58) return 'Fast (1.5x)';
    return 'Normal (1.0x)';
  }
}

class _SpeedPresetPill extends StatelessWidget {
  const _SpeedPresetPill({
    required this.label,
    required this.isSelected,
  });

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEDE9FE) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? const Color(0xFF7B61FF) : const Color(0xFF6B7280),
        ),
      ),
    );
  }
}

class _PronunciationFeedbackCard extends StatelessWidget {
  const _PronunciationFeedbackCard({required this.evaluation});

  final PronunciationEvaluation evaluation;

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor, icon) = _styleForStatus(evaluation.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _titleForStatus(evaluation.status),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    if (evaluation.accuracyScore != null &&
                        evaluation.status == EvaluationStatus.perfect)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: textColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${(evaluation.accuracyScore! * 100).toInt()}% Match',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  evaluation.message,
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor.withOpacity(0.9),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, IconData) _styleForStatus(EvaluationStatus status) {
    switch (status) {
      case EvaluationStatus.perfect:
        return (
          const Color(0xFFDCFCE7),
          const Color(0xFF047857),
          Icons.check_circle_rounded,
        );
      case EvaluationStatus.good:
        return (
          const Color(0xFFDCFCE7),
          const Color(0xFF15803D),
          Icons.thumb_up_alt_rounded,
        );
      case EvaluationStatus.capturedAcoustic:
        return (
          const Color(0xFFEDE9FE),
          const Color(0xFF6D28D9),
          Icons.graphic_eq_rounded,
        );
      case EvaluationStatus.needsWork:
        return (
          const Color(0xFFFEF9C3),
          const Color(0xFFB45309),
          Icons.replay_rounded,
        );
      case EvaluationStatus.silence:
        return (
          const Color(0xFFFEE2E2),
          const Color(0xFFB91C1C),
          Icons.mic_off_rounded,
        );
    }
  }

  String _titleForStatus(EvaluationStatus status) {
    switch (status) {
      case EvaluationStatus.perfect:
        return 'Spot On!';
      case EvaluationStatus.good:
        return 'Good Attempt!';
      case EvaluationStatus.capturedAcoustic:
        return 'Voice Heard';
      case EvaluationStatus.needsWork:
        return 'Almost There!';
      case EvaluationStatus.silence:
        return 'No Voice Detected';
    }
  }
}

class _ActionAudioButton extends StatelessWidget {
  const _ActionAudioButton({
    required this.isPlaying,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isLoading = false,
  });

  final bool isPlaying;
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isVoice = color == const Color(0xFF00D26A);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isVoice ? const Color(0xFF00D26A) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: isVoice ? const Color(0xFF00D26A).withOpacity(0.25) : Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isVoice ? Colors.black87 : color,
                  ),
                ),
              )
            else
              Icon(
                icon,
                color: isVoice ? Colors.black87 : color,
                size: 20,
              ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isVoice ? Colors.black87 : color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
