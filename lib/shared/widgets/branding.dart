import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/assets/synor_assets.dart';
import '../../app/theme/synor_design_tokens.dart';
import '../../l10n/l10n.dart';

enum SynorBrandAsset { synorLogo, bekooWordmark }

String synorBrandAssetPath(BuildContext context, SynorBrandAsset asset) {
  final brightness = Theme.of(context).brightness;
  return switch (asset) {
    SynorBrandAsset.synorLogo => SynorAssets.synorLogoForBrightness(brightness),
    SynorBrandAsset.bekooWordmark => SynorAssets.bekooWordmarkForBrightness(
      brightness,
    ),
  };
}

/// The supplied branding files are raster payloads stored under `.svg` names.
/// Use image decoding instead of `flutter_svg` so the provided assets render.
class SynorBrandImage extends StatelessWidget {
  const SynorBrandImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final SynorBrandAsset asset;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      synorBrandAssetPath(context, asset),
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      gaplessPlayback: true,
    );
  }
}

class SynorBrandLogo extends StatelessWidget {
  const SynorBrandLogo({
    super.key,
    required this.size,
    this.radius = 18,
    this.assetPath,
  });

  final double size;
  final double radius;
  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: assetPath != null
          ? Image.asset(
              assetPath!,
              width: size,
              height: size,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              isAntiAlias: true,
              gaplessPlayback: true,
            )
          : SynorBrandImage(
              asset: SynorBrandAsset.synorLogo,
              width: size,
              height: size,
            ),
    );
  }
}

class BekooWordmark extends StatelessWidget {
  const BekooWordmark({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SynorBrandImage(
      asset: SynorBrandAsset.bekooWordmark,
      height: height,
    );
  }
}

class SynorBrandFooterLockup extends StatelessWidget {
  const SynorBrandFooterLockup({
    super.key,
    this.wordmarkHeight = 22,
    this.fromFontSize = 14,
    this.spacing = 6,
  });

  final double wordmarkHeight;
  final double fromFontSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textColor = brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.7)
        : SynorColors.slate900.withValues(alpha: 0.7);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedDefaultTextStyle(
          duration: SynorMotion.theme,
          curve: SynorMotion.themeCurve,
          style: TextStyle(
            fontFamily: SynorTypography.supportFamily,
            fontSize: fromFontSize,
            fontWeight: FontWeight.w700,
            color: textColor,
            height: 1,
          ),
          child: Text(context.l10n.branding_from),
        ),
        SizedBox(height: spacing),
        BekooWordmark(height: wordmarkHeight),
      ],
    );
  }
}

class SynorBrandedSplashScreen extends StatefulWidget {
  const SynorBrandedSplashScreen({
    super.key,
    required this.onComplete,
    this.duration = const Duration(milliseconds: 1600),
  });

  final VoidCallback onComplete;
  final Duration duration;

  @override
  State<SynorBrandedSplashScreen> createState() =>
      _SynorBrandedSplashScreenState();
}

class _SynorBrandedSplashScreenState extends State<SynorBrandedSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _dismissTimer = Timer(widget.duration, widget.onComplete);
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.62, curve: Curves.easeOutCubic),
    );
    final creditAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.38, 1, curve: Curves.easeOutCubic),
    );

    return ColoredBox(
      color: const Color(0xFFFAFAFA),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 32, 40, 40),
          child: Column(
            children: [
              const Spacer(flex: 6),
              FadeTransition(
                opacity: logoAnimation,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.965,
                    end: 1,
                  ).animate(logoAnimation),
                  child: const SynorBrandLogo(
                    size: 184,
                    radius: 18,
                    assetPath: SynorAssets.synorLogoDark,
                  ),
                ),
              ),
              const Spacer(flex: 7),
              FadeTransition(
                opacity: creditAnimation,
                child: Image.asset(
                  SynorAssets.bekooWordmarkDark,
                  height: 60,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true,
                  gaplessPlayback: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
