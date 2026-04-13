import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/synor_design_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/widgets/synor_widgets.dart';
import '../../reminders/application/reminder_controller.dart';
import '../../reminders/domain/reminder_models.dart';
import 'alarm_editor_sheet.dart';

class AlarmScreen extends ConsumerWidget {
  const AlarmScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarms = ref.watch(alarmListProvider);
    final isDark = synorIsDark(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: alarms.isEmpty
                ? _buildEmptyState(context)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                    itemCount: alarms.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _AlarmCard(alarm: alarms[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _buildAddButton(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SynorIconActionButton(
                icon: LucideIcons.chevron_left,
                onTap: onBack,
                backgroundColor: Colors.transparent,
                borderColor: Colors.transparent,
                boxShadow: const [],
              ),
              const SizedBox(width: 12),
              Text(
                context.l10n.alarm_title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          SynorIconActionButton(
            icon: LucideIcons.pencil,
            onTap: () {
              // Toggle edit mode in future
            },
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            boxShadow: const [],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: SynorColors.indigo500.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.bell_off,
              size: 48,
              color: SynorColors.indigo500,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Alarms',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first alarm',
            style: TextStyle(color: synorSecondaryText(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 8),
      child: FloatingActionButton(
        onPressed: () => _showEditor(context),
        backgroundColor: SynorColors.indigo500,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }

  void _showEditor(BuildContext context, [SavedAlarm? alarm]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlarmEditorSheet(alarm: alarm),
    );
  }
}

class _AlarmCard extends ConsumerWidget {
  const _AlarmCard({required this.alarm});

  final SavedAlarm alarm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = synorIsDark(context);

    return PressableScale(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => AlarmEditorSheet(alarm: alarm),
        );
      },
      child: SynorGlassPanel(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        alarm.formattedTime,
                        style: TextStyle(
                          color: alarm.isEnabled
                              ? synorPrimaryText(context)
                              : synorSecondaryText(context),
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1,
                        ),
                      ),
                      if (alarm.mode == AlarmMode.academic) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: SynorColors.emerald500.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            LucideIcons.graduation_cap,
                            size: 14,
                            color: SynorColors.emerald500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (alarm.label.isNotEmpty) ...[
                        Text(
                          alarm.label,
                          style: TextStyle(
                            color: synorPrimaryText(context),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('•'),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        _getRepeatSummary(alarm),
                        style: TextStyle(
                          color: synorSecondaryText(context),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: alarm.isEnabled,
              activeColor: SynorColors.indigo500,
              onChanged: (v) {
                ref.read(alarmListProvider.notifier).toggleAlarm(alarm.id, v);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getRepeatSummary(SavedAlarm alarm) {
    if (alarm.days.isEmpty) return 'Once';
    if (alarm.days.length == 7) return 'Every day';
    if (alarm.days.length == 5 &&
        !alarm.days.contains(6) &&
        !alarm.days.contains(7)) {
      return 'Weekdays';
    }
    
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final sorted = List<int>.from(alarm.days)..sort();
    return sorted.map((d) => dayNames[d - 1]).join(', ');
  }
}
