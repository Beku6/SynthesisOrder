import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/synor_design_tokens.dart';
import '../../reminders/application/reminder_controller.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/widgets/synor_widgets.dart';

class AlarmScreen extends ConsumerWidget {
  const AlarmScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(alarmControllerProvider);
    final controller = ref.read(alarmControllerProvider.notifier);
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 48),
      children: [
        Row(
          children: [
            SynorIconActionButton(
              icon: LucideIcons.chevron_left,
              onTap: onBack,
              buttonSize: 40,
              radius: 999,
              size: 24,
              backgroundColor: Colors.transparent,
              borderColor: Colors.transparent,
              boxShadow: const [],
              foregroundColor: synorIsDark(context)
                  ? Colors.white
                  : SynorColors.slate900,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Alarm',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Never miss a class or deadline',
                    style: TextStyle(color: synorSecondaryText(context)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: synorIsDark(context)
                ? SynorColors.white5
                : SynorColors.slate200.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: AlarmMode.values.map((value) {
              final active = value == state.mode;
              return Expanded(
                child: PressableScale(
                  onTap: () => controller.setMode(value),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: active
                          ? (synorIsDark(context)
                                ? SynorColors.panelBlack
                                : Colors.white)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: active ? SynorShadows.soft : null,
                    ),
                    child: Text(
                      value == AlarmMode.personal ? 'Personal' : 'Academic',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: active
                            ? synorPrimaryText(context)
                            : synorSecondaryText(context),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 28),
        AnimatedSwitcher(
          duration: SynorMotion.page,
          reverseDuration: SynorMotion.page,
          layoutBuilder: synorStackedLayoutBuilder(
            alignment: Alignment.topCenter,
          ),
          transitionBuilder: synorFadeSlideTransitionBuilder(
            begin: const Offset(0, 0.02),
          ),
          child: state.mode == AlarmMode.academic
              ? Column(
                  key: const ValueKey('academic'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alert Type',
                      style: TextStyle(
                        color: synorPrimaryText(context),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final itemWidth = (constraints.maxWidth - 12) / 2;
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children:
                              [
                                'Wake up',
                                'Exam prep',
                                'Assignment',
                                'Lecture',
                              ].map((type) {
                                final active = type == state.academicType;
                                return PressableScale(
                                  onTap: () => controller.setAcademicType(type),
                                  child: Container(
                                    width: itemWidth,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: active
                                          ? (synorIsDark(context)
                                                ? SynorColors.indigo500
                                                      .withValues(alpha: 0.12)
                                                : SynorColors.indigo50)
                                          : (synorIsDark(context)
                                                ? SynorColors.white5
                                                : Colors.white),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: active
                                            ? (synorIsDark(context)
                                                  ? SynorColors.indigo500
                                                        .withValues(alpha: 0.2)
                                                  : SynorColors.indigo200)
                                            : (synorIsDark(context)
                                                  ? SynorColors.white10
                                                  : SynorColors.slate200),
                                      ),
                                    ),
                                    child: Text(
                                      type,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: active
                                            ? (synorIsDark(context)
                                                  ? SynorColors.indigo300
                                                  : SynorColors.indigo700)
                                            : synorSecondaryText(context),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                  ],
                )
              : const SizedBox.shrink(key: ValueKey('personal')),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                top: 72,
                bottom: 72,
                child: Center(
                  child: Container(
                    height: 72,
                    margin: const EdgeInsets.symmetric(horizontal: 56),
                    decoration: BoxDecoration(
                      color: synorIsDark(context)
                          ? SynorColors.white10
                          : SynorColors.slate200.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _TimeColumn(
                    previous: ((state.hours - 1 + 24) % 24).toString().padLeft(
                      2,
                      '0',
                    ),
                    current: state.hours.toString().padLeft(2, '0'),
                    next: ((state.hours + 1) % 24).toString().padLeft(2, '0'),
                    onPrevious: () =>
                        controller.adjustTime(isHours: true, delta: -1),
                    onNext: () =>
                        controller.adjustTime(isHours: true, delta: 1),
                  ),
                  Text(
                    ':',
                    style: TextStyle(
                      color: synorPrimaryText(context),
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  _TimeColumn(
                    previous: ((state.minutes - 1 + 60) % 60)
                        .toString()
                        .padLeft(2, '0'),
                    current: state.minutes.toString().padLeft(2, '0'),
                    next: ((state.minutes + 1) % 60).toString().padLeft(2, '0'),
                    onPrevious: () =>
                        controller.adjustTime(isHours: false, delta: -1),
                    onNext: () =>
                        controller.adjustTime(isHours: false, delta: 1),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SynorPrimaryButton(
          label: 'Set Alarm',
          icon: LucideIcons.bell,
          onTap: () async {
            await controller.saveAlarm();
            if (!context.mounted) {
              return;
            }
            showSynorToast(
              context,
              message: 'Alarm set for ${state.formattedTime}',
              subtitle: state.mode == AlarmMode.personal
                  ? 'Personal alarm is active.'
                  : 'Academic alert type: ${state.academicType}',
              icon: LucideIcons.bell,
              accentColor: SynorColors.indigo500,
            );
          },
        ),
      ],
    );
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({
    required this.previous,
    required this.current,
    required this.next,
    required this.onPrevious,
    required this.onNext,
  });

  final String previous;
  final String current;
  final String next;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: Column(
        children: [
          PressableScale(
            onTap: onPrevious,
            child: Text(
              previous,
              style: TextStyle(
                color: synorIsDark(context)
                    ? SynorColors.neutral700
                    : SynorColors.slate300,
                fontSize: 38,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 72,
            child: Center(
              child: Text(
                current,
                style: TextStyle(
                  color: synorPrimaryText(context),
                  fontSize: 58,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          PressableScale(
            onTap: onNext,
            child: Text(
              next,
              style: TextStyle(
                color: synorIsDark(context)
                    ? SynorColors.neutral700
                    : SynorColors.slate300,
                fontSize: 38,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
