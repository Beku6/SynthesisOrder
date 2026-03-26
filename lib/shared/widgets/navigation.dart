import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../app/theme/synor_design_tokens.dart';
import '../models/app_models.dart';
import 'base_layout.dart';

class SynorBottomNavBar extends StatelessWidget {
  const SynorBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onChanged,
  });

  final ShellTab currentTab;
  final ValueChanged<ShellTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = synorIsDark(context);
    final blur = isDark ? 24.0 : 12.0;
    final backgroundColor = isDark
        ? const Color(0x990A0A0A)
        : const Color(0xEBFFFFFF);
    final borderColor = isDark
        ? SynorColors.white10
        : SynorColors.slate300.withValues(alpha: 0.95);
    final lightShadow = [
      const BoxShadow(
        color: Color(0x140F172A),
        blurRadius: 18,
        spreadRadius: -4,
        offset: Offset(0, 4),
      ),
      const BoxShadow(
        color: Color(0x08FFFFFF),
        blurRadius: 10,
        spreadRadius: -5,
        offset: Offset(0, -1),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: TweenAnimationBuilder<double>(
        duration: SynorMotion.theme,
        curve: SynorMotion.themeCurve,
        tween: Tween(end: blur),
        builder: (context, animatedBlur, _) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: animatedBlur,
                sigmaY: animatedBlur,
              ),
              child: AnimatedContainer(
                duration: SynorMotion.theme,
                curve: SynorMotion.themeCurve,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    if (isDark)
                      const BoxShadow(
                        color: Color(0x73000000),
                        blurRadius: 28,
                        spreadRadius: -3,
                        offset: Offset(0, 12),
                      )
                    else
                      ...lightShadow,
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ShellTab.values
                      .map(
                        (tab) => _BottomNavItem(
                          tab: tab,
                          selected: tab == currentTab,
                          isDark: isDark,
                          onTap: () => onChanged(tab),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.tab,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  final ShellTab tab;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = switch (tab) {
      ShellTab.home => LucideIcons.house,
      ShellTab.schedule => LucideIcons.calendar,
      ShellTab.studies => LucideIcons.book_open,
      ShellTab.services => LucideIcons.compass,
      ShellTab.profile => LucideIcons.user,
    };

    return PressableScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: SynorMotion.theme,
        curve: SynorMotion.themeCurve,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: selected ? SynorGradients.activePill : null,
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? Border.all(
                  color: isDark
                      ? SynorColors.white20
                      : SynorColors.slate700.withValues(alpha: 0.5),
                )
              : null,
          boxShadow: selected
              ? [
                  if (isDark)
                    const BoxShadow(color: Color(0x1AFFFFFF), blurRadius: 15)
                  else
                    ...SynorShadows.lightPill,
                ]
              : null,
        ),
        child: TweenAnimationBuilder<Color?>(
          duration: SynorMotion.theme,
          curve: SynorMotion.themeCurve,
          tween: ColorTween(
            end: selected
                ? Colors.white
                : (isDark ? SynorColors.neutral500 : SynorColors.slate400),
          ),
          builder: (context, color, _) {
            return Icon(icon, size: 24, color: color);
          },
        ),
      ),
    );
  }
}
