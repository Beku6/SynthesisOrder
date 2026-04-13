import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/synor_design_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/widgets/synor_widgets.dart';
import '../../reminders/application/reminder_controller.dart';
import '../../reminders/domain/reminder_models.dart';

class AlarmEditorSheet extends ConsumerStatefulWidget {
  const AlarmEditorSheet({super.key, this.alarm});

  final SavedAlarm? alarm;

  @override
  ConsumerState<AlarmEditorSheet> createState() => _AlarmEditorSheetState();
}

class _AlarmEditorSheetState extends ConsumerState<AlarmEditorSheet> {
  late int _hours;
  late int _minutes;
  late String _label;
  late List<int> _days;
  late bool _snooze;
  late AlarmMode _mode;
  late String? _academicType;

  @override
  void initState() {
    super.initState();
    final a = widget.alarm;
    _hours = a?.hours ?? 7;
    _minutes = a?.minutes ?? 30;
    _label = a?.label ?? '';
    _days = List.from(a?.days ?? []);
    _snooze = a?.snoozeEnabled ?? true;
    _mode = a?.mode ?? AlarmMode.personal;
    _academicType = a?.academicType ?? 'alarm.type.wakeUp';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = synorIsDark(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? SynorColors.panelBlack : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(context),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildTimePicker(),
                const SizedBox(height: 32),
                _buildDaySelector(),
                const SizedBox(height: 24),
                _buildOptions(),
                const SizedBox(height: 48),
                if (widget.alarm != null) _buildDeleteButton(),
              ],
            ),
          ),
          _buildSaveButton(context),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        width: 42,
        height: 4,
        decoration: BoxDecoration(
          color: SynorColors.slate300.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.alarm == null ? 'Add Alarm' : 'Edit Alarm',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          SynorIconActionButton(
            icon: LucideIcons.x,
            onTap: () => Navigator.pop(context),
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            boxShadow: const [],
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: synorIsDark(context) ? SynorColors.white5 : SynorColors.slate50,
        borderRadius: BorderRadius.circular(24),
      ),
      child: CupertinoTheme(
        data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: TextStyle(
              color: synorPrimaryText(context),
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          use24hFormat: true,
          initialDateTime: DateTime(2026, 1, 1, _hours, _minutes),
          onDateTimeChanged: (dt) {
            setState(() {
              _hours = dt.hour;
              _minutes = dt.minute;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repeat',
          style: TextStyle(
            color: synorSecondaryText(context),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final dayIndex = index + 1;
            final isSelected = _days.contains(dayIndex);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _days.remove(dayIndex);
                  } else {
                    _days.add(dayIndex);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isSelected ? SynorColors.indigo500 : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? SynorColors.indigo500
                        : SynorColors.slate300.withValues(alpha: 0.4),
                  ),
                ),
                child: Center(
                  child: Text(
                    weekdays[index][0],
                    style: TextStyle(
                      color: isSelected ? Colors.white : synorPrimaryText(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildOptions() {
    return SynorGlassPanel(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildOptionRow(
            label: 'Label',
            trailing: Expanded(
              child: TextField(
                textAlign: TextAlign.end,
                onChanged: (v) => _label = v,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Alarm',
                ),
                style: TextStyle(color: synorSecondaryText(context)),
              ),
            ),
          ),
          const Divider(height: 1),
          _buildOptionRow(
            label: 'Snooze',
            trailing: Switch.adaptive(
              value: _snooze,
              onChanged: (v) => setState(() => _snooze = v),
              activeColor: SynorColors.indigo500,
            ),
          ),
          const Divider(height: 1),
          _buildOptionRow(
            label: 'Academic Mode',
            trailing: Switch.adaptive(
              value: _mode == AlarmMode.academic,
              onChanged: (v) {
                setState(() {
                  _mode = v ? AlarmMode.academic : AlarmMode.personal;
                });
              },
              activeColor: SynorColors.emerald500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow({required String label, required Widget trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: synorPrimaryText(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return SynorPrimaryButton(
      label: 'Delete Alarm',
      gradient: SynorGradients.destructive,
      onTap: () {
        ref.read(alarmListProvider.notifier).deleteAlarm(widget.alarm!.id);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SynorPrimaryButton(
        label: 'Save Alarm',
        onTap: () {
          final id = widget.alarm?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
          final alarm = SavedAlarm(
            id: id,
            hours: _hours,
            minutes: _minutes,
            label: _label.isEmpty ? 'Alarm' : _label,
            isEnabled: true,
            mode: _mode,
            days: _days,
            snoozeEnabled: _snooze,
            academicType: _academicType,
          );

          if (widget.alarm == null) {
            ref.read(alarmListProvider.notifier).addAlarm(alarm);
          } else {
            ref.read(alarmListProvider.notifier).updateAlarm(alarm);
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}
