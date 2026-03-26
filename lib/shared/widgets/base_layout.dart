import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/assets/synor_assets.dart';
import '../../app/theme/synor_design_tokens.dart';

bool synorIsDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

bool synorUsesFramedShell(BuildContext context) =>
    MediaQuery.sizeOf(context).shortestSide >= 600;

Color synorPrimaryText(BuildContext context) =>
    Theme.of(context).textTheme.bodyLarge?.color ??
    (synorIsDark(context) ? Colors.white : SynorColors.slate900);

Color synorSecondaryText(BuildContext context) =>
    Theme.of(context).textTheme.bodyMedium?.color ??
    (synorIsDark(context) ? SynorColors.neutral400 : SynorColors.slate500);

class SynorViewport extends StatelessWidget {
  const SynorViewport({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = synorIsDark(context);
    final usesFramedShell = synorUsesFramedShell(context);
    final host = AnimatedContainer(
      duration: SynorMotion.theme,
      curve: SynorMotion.themeCurve,
      key: const ValueKey('synor-viewport-host'),
      width: double.infinity,
      height: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: isDark ? const Color(0x66000000) : const Color(0x99FFFFFF),
        border: usesFramedShell
            ? Border.symmetric(
                vertical: BorderSide(
                  color: isDark ? SynorColors.white5 : SynorColors.slate200,
                ),
              )
            : null,
        boxShadow: usesFramedShell ? SynorShadows.heavy : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: child,
        ),
      ),
    );
    return AnimatedContainer(
      duration: SynorMotion.theme,
      curve: SynorMotion.themeCurve,
      color: isDark ? SynorColors.appBlack : SynorColors.lightBackground,
      child: Stack(
        children: [
          const Positioned.fill(child: _AmbientGlowBackground()),
          if (usesFramedShell)
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: host,
              ),
            )
          else
            Positioned.fill(child: host),
        ],
      ),
    );
  }
}

class SynorResponsiveContentLimit extends StatelessWidget {
  const SynorResponsiveContentLimit({
    super.key,
    required this.child,
    required this.maxWidth,
    this.alignment = Alignment.center,
  });

  final Widget child;
  final double maxWidth;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    if (!synorUsesFramedShell(context)) {
      return child;
    }
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

class SynorHorizontalViewportBleed extends StatelessWidget {
  const SynorHorizontalViewportBleed({
    super.key,
    required this.child,
    required this.height,
    this.horizontalInset = SynorSpacing.xxl,
  });

  final Widget child;
  final double height;
  final double horizontalInset;

  @override
  Widget build(BuildContext context) {
    if (synorUsesFramedShell(context)) {
      return child;
    }

    final width = MediaQuery.sizeOf(context).width;
    return SizedBox(
      height: height,
      child: Transform.translate(
        offset: Offset(-horizontalInset, 0),
        child: OverflowBox(
          alignment: Alignment.centerLeft,
          minWidth: width,
          maxWidth: width,
          minHeight: height,
          maxHeight: height,
          child: SizedBox(width: width, height: height, child: child),
        ),
      ),
    );
  }
}

class _AmbientGlowBackground extends StatelessWidget {
  const _AmbientGlowBackground();

  @override
  Widget build(BuildContext context) {
    final isDark = synorIsDark(context);
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -80,
          child: _GlowBubble(
            color: isDark ? const Color(0x332E1065) : const Color(0x1A312E81),
          ),
        ),
        Positioned(
          bottom: -80,
          right: -80,
          child: _GlowBubble(
            color: isDark ? const Color(0x331D4ED8) : const Color(0x1A1D4ED8),
          ),
        ),
      ],
    );
  }
}

class _GlowBubble extends StatelessWidget {
  const _GlowBubble({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      duration: SynorMotion.theme,
      curve: SynorMotion.themeCurve,
      tween: ColorTween(end: color),
      builder: (context, animatedColor, _) {
        return ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: SynorBlur.ambient,
            sigmaY: SynorBlur.ambient,
          ),
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              color: animatedColor ?? color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedSynorIcon extends StatelessWidget {
  const _AnimatedSynorIcon({
    required this.icon,
    required this.color,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      duration: SynorMotion.theme,
      curve: SynorMotion.themeCurve,
      tween: ColorTween(end: color),
      builder: (context, animatedColor, _) {
        return Icon(icon, size: size, color: animatedColor ?? color);
      },
    );
  }
}

class _AnimatedTextColor extends StatelessWidget {
  const _AnimatedTextColor({
    required this.text,
    required this.style,
    this.textAlign,
  });

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: SynorMotion.theme,
      curve: SynorMotion.themeCurve,
      style: style,
      child: Text(text, textAlign: textAlign),
    );
  }
}

/// Design texture copied from the exported Synor auth screens.
///
/// This is not a Flutter debug grid and should remain enabled in normal builds.
class SynorAuthGridTexture extends StatelessWidget {
  const SynorAuthGridTexture({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = synorIsDark(context);
    return CustomPaint(
      painter: _GridPainter(
        color: isDark ? const Color(0x12808080) : const Color(0x0D808080),
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const step = 24.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.color != color;
}

class SynorNoiseOverlay extends StatelessWidget {
  const SynorNoiseOverlay({super.key, this.opacity = 0.18});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: SvgPicture.asset(SynorAssets.noise, fit: BoxFit.cover),
      ),
    );
  }
}

class SynorAuthBackground extends StatelessWidget {
  const SynorAuthBackground({
    super.key,
    required this.child,
    this.showBottomGlow = false,
  });

  final Widget child;
  final bool showBottomGlow;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SynorColors.appBlack,
      child: Stack(
        children: [
          const Positioned.fill(child: SynorNoiseOverlay(opacity: 0.2)),
          const Positioned.fill(child: SynorAuthGridTexture()),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    SynorColors.indigo900.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          if (showBottomGlow)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      SynorColors.violet600.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }
}

class SynorFillScrollView extends StatelessWidget {
  const SynorFillScrollView({
    super.key,
    required this.padding,
    required this.child,
  });

  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: padding.add(EdgeInsets.only(bottom: viewInsets.bottom)),
            child: child,
          ),
        ),
      ],
    );
  }
}

class SynorGlassPanel extends StatelessWidget {
  const SynorGlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = SynorRadii.card,
    this.backgroundColor,
    this.borderColor,
    this.gradient,
    this.shadows,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Gradient? gradient;
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    final isDark = synorIsDark(context);
    final blur = isDark ? SynorBlur.medium : SynorBlur.subtle;
    return TweenAnimationBuilder<double>(
      duration: SynorMotion.theme,
      curve: SynorMotion.themeCurve,
      tween: Tween(begin: blur, end: blur),
      builder: (context, animatedBlur, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: animatedBlur,
              sigmaY: animatedBlur,
            ),
            child: AnimatedContainer(
              duration: SynorMotion.theme,
              curve: SynorMotion.themeCurve,
              padding: padding,
              decoration: BoxDecoration(
                color:
                    backgroundColor ??
                    (isDark
                        ? SynorColors.surfaceBlack.withValues(alpha: 0.7)
                        : Colors.white),
                gradient: gradient,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color:
                      borderColor ??
                      (isDark ? SynorColors.white10 : SynorColors.slate200),
                ),
                boxShadow: shadows ?? SynorShadows.soft,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class SynorPrimaryButton extends StatelessWidget {
  const SynorPrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.gradient = SynorGradients.authButton,
    this.foregroundColor = Colors.white,
    this.height = 56,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Gradient gradient;
  final Color foregroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: SynorShadows.indigoGlow,
        ),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: foregroundColor, size: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SynorSegmentedControl<T> extends StatelessWidget {
  const SynorSegmentedControl({
    super.key,
    required this.values,
    required this.selected,
    required this.labelBuilder,
    required this.onChanged,
    this.compact = false,
    this.backgroundColor,
  });

  final List<T> values;
  final T selected;
  final String Function(T value) labelBuilder;
  final ValueChanged<T> onChanged;
  final bool compact;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = synorIsDark(context);
    return AnimatedContainer(
      duration: SynorMotion.theme,
      curve: SynorMotion.themeCurve,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDark ? SynorColors.white5 : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? SynorColors.white10 : SynorColors.slate200,
        ),
      ),
      child: Row(
        children: values.map((value) {
          final active = value == selected;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: PressableScale(
                onTap: () => onChanged(value),
                child: AnimatedContainer(
                  duration: SynorMotion.theme,
                  curve: SynorMotion.themeCurve,
                  padding: EdgeInsets.symmetric(vertical: compact ? 8 : 12),
                  decoration: BoxDecoration(
                    gradient: active ? SynorGradients.activePill : null,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: active
                        ? [
                            if (!isDark) ...SynorShadows.lightPill,
                            if (isDark)
                              const BoxShadow(
                                color: Color(0x1AFFFFFF),
                                blurRadius: 15,
                              ),
                          ]
                        : null,
                  ),
                  child: _AnimatedTextColor(
                    text: labelBuilder(value),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: active
                          ? Colors.white
                          : (isDark
                                ? SynorColors.neutral400
                                : SynorColors.slate600),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SynorSearchField extends StatelessWidget {
  const SynorSearchField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.prefixIcon,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final isDark = synorIsDark(context);
    const radius = 20.0;
    return AnimatedContainer(
      duration: SynorMotion.theme,
      curve: SynorMotion.themeCurve,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? SynorColors.white5 : Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: isDark ? SynorColors.white10 : SynorColors.slate200,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(radius),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: TextStyle(color: synorPrimaryText(context), fontSize: 14),
          decoration: InputDecoration(
            filled: false,
            fillColor: Colors.transparent,
            hintText: hintText,
            hintStyle: TextStyle(
              color: isDark ? SynorColors.neutral500 : SynorColors.slate400,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: _AnimatedSynorIcon(
                icon: prefixIcon ?? Icons.search_rounded,
                size: 18,
                color: isDark ? SynorColors.neutral500 : SynorColors.slate400,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 42),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}

class SynorStatusChip extends StatelessWidget {
  const SynorStatusChip({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
    this.icon,
    this.leading,
    this.compact = false,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final IconData? icon;
  final Widget? leading;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: SynorMotion.theme,
      curve: SynorMotion.themeCurve,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(compact ? 10 : 12),
        border: Border.all(color: borderColor ?? backgroundColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null || icon != null) ...[
            leading ??
                _AnimatedSynorIcon(
                  icon: icon!,
                  size: compact ? 12 : 14,
                  color: foregroundColor,
                ),
            const SizedBox(width: 6),
          ],
          _AnimatedTextColor(
            text: label,
            style: TextStyle(
              color: foregroundColor,
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w700,
              letterSpacing: compact ? 0.2 : 0,
            ),
          ),
        ],
      ),
    );
  }
}

class SynorBottomSheetHandle extends StatelessWidget {
  const SynorBottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 48,
        height: 6,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: synorIsDark(context)
              ? SynorColors.white20
              : SynorColors.slate200,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class SynorModalScrim extends StatelessWidget {
  const SynorModalScrim({super.key, this.opacity = 0.4});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: SynorMotion.theme,
      curve: SynorMotion.themeCurve,
      tween: Tween(begin: SynorBlur.light, end: SynorBlur.light),
      builder: (context, blur, _) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: AnimatedContainer(
            duration: SynorMotion.theme,
            curve: SynorMotion.themeCurve,
            color: Colors.black.withValues(alpha: opacity),
          ),
        );
      },
    );
  }
}

class SynorIconActionButton extends StatelessWidget {
  const SynorIconActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 20,
    this.buttonSize = 48,
    this.radius = 18,
    this.backgroundColor,
    this.borderColor,
    this.foregroundColor,
    this.boxShadow,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double buttonSize;
  final double radius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? foregroundColor;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final isDark = synorIsDark(context);
    return PressableScale(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: SynorMotion.theme,
        curve: SynorMotion.themeCurve,
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color:
              backgroundColor ?? (isDark ? SynorColors.white5 : Colors.white),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color:
                borderColor ??
                (isDark ? SynorColors.white10 : SynorColors.slate200),
          ),
          boxShadow: boxShadow ?? (isDark ? SynorShadows.soft : const []),
        ),
        child: _AnimatedSynorIcon(
          icon: icon,
          size: size,
          color:
              foregroundColor ??
              (isDark ? SynorColors.neutral300 : SynorColors.slate600),
        ),
      ),
    );
  }
}

class PressableScale extends StatefulWidget {
  const PressableScale({super.key, required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() {
        _pressed = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.98 : 1,
        child: widget.child,
      ),
    );
  }
}
