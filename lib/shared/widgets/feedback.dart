import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/theme/synor_design_tokens.dart';
import 'base_layout.dart';

OverlayEntry? _activeToastEntry;

void showSynorToast(
  BuildContext context, {
  required String message,
  String? subtitle,
  IconData? icon,
  Color? accentColor,
  Duration duration = const Duration(seconds: 2),
}) {
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return;

  _activeToastEntry?.remove();
  _activeToastEntry = null;

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => _SynorToastHost(
      message: message,
      subtitle: subtitle,
      icon: icon,
      accentColor: accentColor,
      duration: duration,
      onDismissed: () {
        if (_activeToastEntry == entry) {
          _activeToastEntry = null;
        }
        if (entry.mounted) {
          entry.remove();
        }
      },
    ),
  );

  _activeToastEntry = entry;
  overlay.insert(entry);
}

class _SynorToastHost extends StatefulWidget {
  const _SynorToastHost({
    required this.message,
    this.subtitle,
    this.icon,
    this.accentColor,
    required this.duration,
    required this.onDismissed,
  });

  final String message;
  final String? subtitle;
  final IconData? icon;
  final Color? accentColor;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_SynorToastHost> createState() => _SynorToastHostState();
}

class _SynorToastHostState extends State<_SynorToastHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _dismissTimer;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      reverseDuration: const Duration(milliseconds: 220),
    )..forward();
    _dismissTimer = Timer(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_isDismissing) {
      return;
    }
    _isDismissing = true;
    _dismissTimer?.cancel();
    await _controller.reverse();
    if (mounted) {
      widget.onDismissed();
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent =
        widget.accentColor ??
        (synorIsDark(context) ? SynorColors.indigo400 : SynorColors.indigo600);
    final blur = synorIsDark(context) ? 18.0 : 10.0;
    final slide = Tween<Offset>(
      begin: const Offset(0, -0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    return Positioned.fill(
      child: IgnorePointer(
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Align(
              alignment: Alignment.topCenter,
              child: FadeTransition(
                opacity: _controller,
                child: SlideTransition(
                  position: slide,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: TweenAnimationBuilder<double>(
                      duration: SynorMotion.theme,
                      curve: SynorMotion.themeCurve,
                      tween: Tween(end: blur),
                      builder: (context, animatedBlur, _) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(SynorRadii.card),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: animatedBlur,
                              sigmaY: animatedBlur,
                            ),
                            child: AnimatedContainer(
                              key: const ValueKey('synor-toast-banner'),
                              duration: SynorMotion.theme,
                              curve: SynorMotion.themeCurve,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: synorIsDark(context)
                                      ? [
                                          SynorColors.panelBlack.withValues(
                                            alpha: 0.98,
                                          ),
                                          SynorColors.surfaceBlack.withValues(
                                            alpha: 0.96,
                                          ),
                                        ]
                                      : [
                                          Colors.white.withValues(alpha: 0.98),
                                          SynorColors.slate50.withValues(
                                            alpha: 0.96,
                                          ),
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(
                                  SynorRadii.card,
                                ),
                                border: Border.all(
                                  color: accent.withValues(
                                    alpha: synorIsDark(context) ? 0.24 : 0.16,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: synorIsDark(context)
                                        ? const Color(0x38000000)
                                        : const Color(0x140F172A),
                                    blurRadius: synorIsDark(context) ? 26 : 18,
                                    spreadRadius: synorIsDark(context)
                                        ? -6
                                        : -5,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 16,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (widget.icon != null) ...[
                                      AnimatedContainer(
                                        duration: SynorMotion.theme,
                                        curve: SynorMotion.themeCurve,
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: accent.withValues(
                                            alpha: synorIsDark(context)
                                                ? 0.16
                                                : 0.1,
                                          ),
                                        ),
                                        child: TweenAnimationBuilder<Color?>(
                                          duration: SynorMotion.theme,
                                          curve: SynorMotion.themeCurve,
                                          tween: ColorTween(end: accent),
                                          builder: (context, color, _) {
                                            return Icon(
                                              widget.icon,
                                              size: 18,
                                              color: color,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AnimatedDefaultTextStyle(
                                            duration: SynorMotion.theme,
                                            curve: SynorMotion.themeCurve,
                                            style: TextStyle(
                                              color: synorPrimaryText(context),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              height: 1.2,
                                            ),
                                            child: Text(widget.message),
                                          ),
                                          if (widget.subtitle != null) ...[
                                            const SizedBox(height: 4),
                                            AnimatedDefaultTextStyle(
                                              duration: SynorMotion.theme,
                                              curve: SynorMotion.themeCurve,
                                              style: TextStyle(
                                                color: synorSecondaryText(
                                                  context,
                                                ),
                                                fontSize: 12,
                                                height: 1.35,
                                              ),
                                              child: Text(widget.subtitle!),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SynorInlineStateCard extends StatelessWidget {
  const SynorInlineStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.accentColor = SynorColors.indigo500,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return SynorGlassPanel(
      radius: SynorRadii.cardLarge,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withValues(
                alpha: synorIsDark(context) ? 0.14 : 0.1,
              ),
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: synorPrimaryText(context),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: synorSecondaryText(context),
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
