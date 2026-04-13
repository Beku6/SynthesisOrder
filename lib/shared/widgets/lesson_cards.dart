import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../app/theme/synor_design_tokens.dart';
import '../../l10n/app_localization_x.dart';
import '../../l10n/l10n.dart';
import '../models/app_models.dart';
import 'animated_icons.dart';
import 'base_layout.dart';
import 'feedback.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({super.key, required this.lesson, required this.onAlertTap});

  final Lesson lesson;
  final VoidCallback onAlertTap;

  @override
  Widget build(BuildContext context) {
    final palette = lessonPalette(context, lesson.colorVariant);
    return SwipeRevealCard(
      actions: [
        QuickActionButton(
          icon: LucideIcons.bell,
          label: context.l10n.lesson_actionAlert,
          onTap: onAlertTap,
          backgroundColor: synorIsDark(context)
              ? SynorColors.indigo500.withValues(alpha: 0.2)
              : SynorColors.indigo100,
          foregroundColor: synorIsDark(context)
              ? SynorColors.indigo400
              : SynorColors.indigo600,
        ),
        QuickActionButton(
          icon: LucideIcons.file_text,
          label: context.l10n.lesson_actionNotes,
          onTap: noop,
        ),
        QuickActionButton(
          icon: LucideIcons.ellipsis,
          label: context.l10n.lesson_actionMore,
          onTap: noop,
        ),
      ],
      child: SynorGlassPanel(
        radius: SynorRadii.cardLarge,
        borderColor: palette.borderColor,
        backgroundColor: synorIsDark(context)
            ? SynorColors.surfaceBlack
            : Colors.white,
        gradient: synorIsDark(context) ? SynorGradients.glassDark : null,
        child: Stack(
          children: [
            Positioned(
              top: 4,
              right: 4,
              child: AnimatedContainer(
                duration: SynorMotion.theme,
                curve: SynorMotion.themeCurve,
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: palette.accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: palette.accent.withValues(
                        alpha: synorIsDark(context) ? 0.5 : 0.18,
                      ),
                      blurRadius: synorIsDark(context) ? 10 : 6,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    context.l10n.lessonTitleLabel(lesson.title),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: synorPrimaryText(context),
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          InfoRow(
                            iconWidget: AnimatedClockIcon(
                              isActive: lesson.isStarted || lesson.isNear,
                              size: 18,
                              color: synorSecondaryText(context),
                            ),
                            text: lesson.resolvedTime,
                            emphasize: true,
                          ),
                          const SizedBox(height: 14),
                          InfoRow(
                            icon: LucideIcons.map_pin,
                            text: context.l10n.lessonLocationLabel(
                              lesson.location,
                            ),
                          ),
                          const SizedBox(height: 14),
                          InfoRow(
                            icon: LucideIcons.user,
                            text: context.l10n.lessonTeacherLabel(
                              lesson.teacher,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 104,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          lesson.isOngoing
                              ? LessonCountdownChip(
                                  lesson: lesson,
                                  iconColor: SynorColors.emerald400,
                                  textColor: SynorColors.emerald400,
                                  backgroundColor: SynorColors.emerald500.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderColor: SynorColors.emerald500.withValues(
                                    alpha: 0.2,
                                  ),
                                )
                              : LessonCountdownChip(
                                  lesson: lesson,
                                  iconColor: palette.badgeIconColor,
                                  textColor: palette.badgeTextColor,
                                  backgroundColor: palette.badgeBackground,
                                  borderColor: palette.borderInner,
                                ),
                          if (lesson.alertLabel != null)
                            PressableScale(
                              onTap: onAlertTap,
                              child: SynorStatusChip(
                                label: context.l10n.quickAlertPresetLabel(
                                  lesson.alertLabel!,
                                ),
                                icon: LucideIcons.bell,
                                backgroundColor: synorIsDark(context)
                                    ? SynorColors.indigo500.withValues(
                                        alpha: 0.1,
                                      )
                                    : SynorColors.indigo50,
                                foregroundColor: synorIsDark(context)
                                    ? SynorColors.indigo400
                                    : SynorColors.indigo600,
                                borderColor: synorIsDark(context)
                                    ? SynorColors.indigo500.withValues(
                                        alpha: 0.2,
                                      )
                                    : SynorColors.indigo100,
                                compact: true,
                              ),
                            )
                          else
                            const SizedBox(width: 32, height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimelineLessonCard extends StatelessWidget {
  const TimelineLessonCard({
    super.key,
    required this.lesson,
    required this.onAlertTap,
  });

  final Lesson lesson;
  final VoidCallback onAlertTap;

  @override
  Widget build(BuildContext context) {
    final palette = lessonPalette(context, lesson.colorVariant);
    return Padding(
      padding: const EdgeInsets.only(left: 48),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -33,
            top: 22,
            child: AnimatedContainer(
              duration: SynorMotion.theme,
              curve: SynorMotion.themeCurve,
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: palette.accent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: synorIsDark(context)
                      ? SynorColors.appBlack
                      : SynorColors.slate50,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: palette.accent.withValues(
                      alpha: synorIsDark(context) ? 0.5 : 0.18,
                    ),
                    blurRadius: synorIsDark(context) ? 10 : 6,
                  ),
                ],
              ),
            ),
          ),
          SwipeRevealCard(
            actions: [
              QuickActionButton(
                icon: LucideIcons.bell,
                label: context.l10n.lesson_actionAlert,
                onTap: onAlertTap,
                backgroundColor: synorIsDark(context)
                    ? SynorColors.indigo500.withValues(alpha: 0.2)
                    : SynorColors.indigo100,
                foregroundColor: synorIsDark(context)
                    ? SynorColors.indigo400
                    : SynorColors.indigo600,
              ),
              QuickActionButton(
                icon: LucideIcons.file_text,
                label: context.l10n.lesson_actionNotes,
                onTap: noop,
              ),
              QuickActionButton(
                icon: LucideIcons.ellipsis,
                label: context.l10n.lesson_actionMore,
                onTap: noop,
              ),
            ],
            child: SynorGlassPanel(
              radius: SynorRadii.cardLarge,
              borderColor: palette.borderColor,
              backgroundColor: synorIsDark(context)
                  ? SynorColors.surfaceBlack
                  : Colors.white,
              gradient: synorIsDark(context) ? SynorGradients.glassDark : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          context.l10n.lessonTitleLabel(lesson.title),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: synorPrimaryText(context),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          lesson.isOngoing
                              ? LessonCountdownChip(
                                  lesson: lesson,
                                  iconColor: SynorColors.emerald400,
                                  textColor: SynorColors.emerald400,
                                  backgroundColor: SynorColors.emerald500.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderColor: SynorColors.emerald500.withValues(
                                    alpha: 0.2,
                                  ),
                                  compact: true,
                                )
                              : LessonCountdownChip(
                                  lesson: lesson,
                                  iconColor: synorIsDark(context)
                                      ? SynorColors.neutral500
                                      : SynorColors.slate400,
                                  textColor: synorIsDark(context)
                                      ? SynorColors.neutral300
                                      : SynorColors.slate600,
                                  backgroundColor: synorIsDark(context)
                                      ? SynorColors.white5
                                      : SynorColors.slate50,
                                  borderColor: synorIsDark(context)
                                      ? SynorColors.white10
                                      : SynorColors.slate200,
                                  compact: true,
                                ),
                          if (lesson.alertLabel != null) ...[
                            const SizedBox(height: 8),
                            PressableScale(
                              onTap: onAlertTap,
                              child: SynorStatusChip(
                                label: context.l10n.quickAlertPresetLabel(
                                  lesson.alertLabel!,
                                ),
                                icon: LucideIcons.bell,
                                backgroundColor: synorIsDark(context)
                                    ? SynorColors.indigo500.withValues(
                                        alpha: 0.1,
                                      )
                                    : SynorColors.indigo50,
                                foregroundColor: synorIsDark(context)
                                    ? SynorColors.indigo400
                                    : SynorColors.indigo600,
                                borderColor: synorIsDark(context)
                                    ? SynorColors.indigo500.withValues(
                                        alpha: 0.2,
                                      )
                                    : SynorColors.indigo100,
                                compact: true,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  InfoRow(
                    iconWidget: AnimatedClockIcon(
                      isActive: lesson.isStarted || lesson.isNear,
                      size: 18,
                      color: synorSecondaryText(context),
                    ),
                    text: lesson.resolvedTime,
                    emphasize: true,
                  ),
                  const SizedBox(height: 12),
                  InfoRow(
                    icon: LucideIcons.map_pin,
                    text: context.l10n.lessonLocationLabel(lesson.location),
                  ),
                  const SizedBox(height: 12),
                  InfoRow(
                    icon: LucideIcons.user,
                    text: context.l10n.lessonTeacherLabel(lesson.teacher),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SwipeRevealCard extends StatefulWidget {
  const SwipeRevealCard({
    super.key,
    required this.child,
    required this.actions,
  });

  final Widget child;
  final List<Widget> actions;

  @override
  State<SwipeRevealCard> createState() => _SwipeRevealCardState();
}

class _SwipeRevealCardState extends State<SwipeRevealCard> {
  static const _maxReveal = 220.0;
  double _offset = 0;

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _offset = (_offset + details.delta.dx).clamp(-_maxReveal, 0);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      _offset = _offset < -100 ? -_maxReveal : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = synorIsDark(context);
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedContainer(
            duration: SynorMotion.theme,
            curve: SynorMotion.themeCurve,
            decoration: BoxDecoration(
              color: isDark ? SynorColors.panelBlack : SynorColors.slate100,
              borderRadius: BorderRadius.circular(SynorRadii.cardLarge),
            ),
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: widget.actions,
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutBack,
          transform: Matrix4.translationValues(_offset, 0, 0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: _handleDragEnd,
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

class QuickActionButton extends StatelessWidget {
  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = synorIsDark(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: PressableScale(
        onTap: () {
          if (identical(onTap, noop)) {
            showSynorToast(
              context,
              message: label == context.l10n.lesson_actionNotes
                  ? context.l10n.lesson_notesUnavailableTitle
                  : context.l10n.lesson_moreUnavailableTitle,
              subtitle: label == context.l10n.lesson_actionNotes
                  ? context.l10n.lesson_notesUnavailableSubtitle
                  : context.l10n.lesson_moreUnavailableSubtitle,
              icon: icon,
              accentColor: label == context.l10n.lesson_actionNotes
                  ? SynorColors.indigo500
                  : SynorColors.slate500,
            );
            return;
          }
          onTap();
        },
        child: AnimatedContainer(
          duration: SynorMotion.theme,
          curve: SynorMotion.themeCurve,
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color:
                backgroundColor ?? (isDark ? SynorColors.white5 : Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<Color?>(
                duration: SynorMotion.theme,
                curve: SynorMotion.themeCurve,
                tween: ColorTween(
                  end: foregroundColor ?? synorSecondaryText(context),
                ),
                builder: (context, color, _) {
                  return Icon(icon, size: 20, color: color);
                },
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: SynorMotion.theme,
                curve: SynorMotion.themeCurve,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: foregroundColor ?? synorSecondaryText(context),
                  letterSpacing: 0.6,
                ),
                child: Text(label.toUpperCase()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    this.icon,
    this.iconWidget,
    required this.text,
    this.emphasize = false,
  });

  final IconData? icon;
  final Widget? iconWidget;
  final String text;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 18,
          child:
              iconWidget ??
              Icon(icon, size: 18, color: synorSecondaryText(context)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AnimatedDefaultTextStyle(
            duration: SynorMotion.theme,
            curve: SynorMotion.themeCurve,
            style: TextStyle(
              color: synorIsDark(context)
                  ? SynorColors.neutral300
                  : SynorColors.slate600,
              fontSize: 14,
              fontWeight: emphasize ? FontWeight.w500 : FontWeight.w400,
            ),
            child: Text(text),
          ),
        ),
      ],
    );
  }
}

class LessonPalette {
  const LessonPalette({
    required this.accent,
    required this.borderColor,
    required this.badgeTextColor,
    required this.badgeIconColor,
    required this.badgeBackground,
    required this.borderInner,
  });

  final Color accent;
  final Color borderColor;
  final Color badgeTextColor;
  final Color badgeIconColor;
  final Color badgeBackground;
  final Color borderInner;
}

LessonPalette lessonPalette(BuildContext context, LessonColorVariant variant) {
  final isDark = synorIsDark(context);
  return switch (variant) {
    LessonColorVariant.rose => LessonPalette(
      accent: SynorColors.rose500,
      borderColor: isDark
          ? SynorColors.rose500.withValues(alpha: 0.2)
          : SynorColors.rose200,
      badgeTextColor: isDark ? SynorColors.rose100 : SynorColors.rose600,
      badgeIconColor: isDark ? SynorColors.rose400 : SynorColors.rose500,
      badgeBackground: isDark
          ? SynorColors.rose500.withValues(alpha: 0.1)
          : SynorColors.rose50,
      borderInner: isDark
          ? SynorColors.rose500.withValues(alpha: 0.2)
          : SynorColors.rose100,
    ),
    LessonColorVariant.emerald => LessonPalette(
      accent: SynorColors.emerald500,
      borderColor: isDark
          ? SynorColors.emerald500.withValues(alpha: 0.2)
          : SynorColors.emerald200,
      badgeTextColor: isDark ? SynorColors.emerald100 : SynorColors.emerald600,
      badgeIconColor: isDark ? SynorColors.emerald400 : SynorColors.emerald500,
      badgeBackground: isDark
          ? SynorColors.emerald500.withValues(alpha: 0.1)
          : SynorColors.emerald50,
      borderInner: isDark
          ? SynorColors.emerald500.withValues(alpha: 0.2)
          : SynorColors.emerald100,
    ),
    LessonColorVariant.indigo => LessonPalette(
      accent: SynorColors.indigo500,
      borderColor: isDark
          ? SynorColors.indigo500.withValues(alpha: 0.2)
          : SynorColors.indigo200,
      badgeTextColor: isDark ? SynorColors.indigo100 : SynorColors.indigo600,
      badgeIconColor: isDark ? SynorColors.indigo400 : SynorColors.indigo500,
      badgeBackground: isDark
          ? SynorColors.indigo500.withValues(alpha: 0.1)
          : SynorColors.indigo50,
      borderInner: isDark
          ? SynorColors.indigo500.withValues(alpha: 0.2)
          : SynorColors.indigo100,
    ),
  };
}

class LessonCountdownChip extends StatefulWidget {
  const LessonCountdownChip({
    super.key,
    required this.lesson,
    required this.iconColor,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    this.compact = false,
  });

  final Lesson lesson;
  final Color iconColor;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final bool compact;

  @override
  State<LessonCountdownChip> createState() => _LessonCountdownChipState();
}

class _LessonCountdownChipState extends State<LessonCountdownChip> {
  Timer? _timer;
  late String _label;

  @override
  void initState() {
    super.initState();
    _label = widget.lesson.resolvedCountdown;
    _startTimer();
  }

  @override
  void didUpdateWidget(LessonCountdownChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh label when widget updates from parent
    _label = widget.lesson.resolvedCountdown;
    
    // If the lesson changed or was restarted, reset the timer
    if (oldWidget.lesson.id != widget.lesson.id || 
        oldWidget.lesson.isFinished != widget.lesson.isFinished) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.lesson.isFinished) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      final newLabel = widget.lesson.resolvedCountdown;
      if (newLabel != _label) {
        setState(() {
          _label = newLabel;
        });
      }
      
      if (widget.lesson.isFinished) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = widget.compact ? 12.0 : 16.0;
    final horizontalPadding = widget.compact ? 8.0 : 12.0;
    final verticalPadding = widget.compact ? 4.0 : 6.0;
    final gap = widget.compact ? 6.0 : 8.0;
    final radius = widget.compact ? 8.0 : 12.0;
    final fontSize = widget.compact ? 10.0 : 14.0;
    final isOngoing = widget.lesson.isOngoing;

    return AnimatedContainer(
      duration: SynorMotion.theme,
      curve: SynorMotion.themeCurve,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: widget.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isOngoing
              ? PulseAnimation(
                  child: Icon(
                    LucideIcons.play,
                    size: iconSize,
                    color: widget.iconColor,
                  ),
                )
              : AnimatedHourglassIcon(
                  timeLeft: _label,
                  isActive: true,
                  size: iconSize,
                  color: widget.iconColor,
                ),
          SizedBox(width: gap),
          AnimatedDefaultTextStyle(
            duration: SynorMotion.theme,
            curve: SynorMotion.themeCurve,
            style: TextStyle(
              color: widget.textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
            child: Text(isOngoing ? 'LIVE  $_label' : _label),
          ),
        ],
      ),
    );
  }
}

class PulseAnimation extends StatefulWidget {
  const PulseAnimation({super.key, required this.child});
  final Widget child;

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.didUpdateWidget(widget);
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}

void noop() {}
