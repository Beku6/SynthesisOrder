import 'package:flutter/material.dart';

import '../../app/theme/synor_design_tokens.dart';
import 'base_layout.dart';
import 'surface_tiles.dart';

class SynorSkeletonShimmer extends StatefulWidget {
  const SynorSkeletonShimmer({super.key, required this.child});

  final Widget child;

  @override
  State<SynorSkeletonShimmer> createState() => _SynorSkeletonShimmerState();
}

class _SynorSkeletonShimmerState extends State<SynorSkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = synorIsDark(context)
        ? SynorColors.white10
        : SynorColors.slate100;
    final highlightColor = synorIsDark(context)
        ? SynorColors.white20
        : Colors.white.withValues(alpha: 0.94);

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                baseColor,
                highlightColor,
                baseColor,
                baseColor,
              ],
              stops: const [0, 0.36, 0.5, 0.64, 1],
              transform: _SlidingGradientTransform(
                slidePercent: (_controller.value * 2) - 1,
              ),
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}

class SynorSkeletonBlock extends StatelessWidget {
  const SynorSkeletonBlock({
    super.key,
    this.width,
    required this.height,
    this.radius = 14,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final color = synorIsDark(context)
        ? SynorColors.white10
        : SynorColors.slate100;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class SynorSkeletonCircle extends StatelessWidget {
  const SynorSkeletonCircle({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final color = synorIsDark(context)
        ? SynorColors.white10
        : SynorColors.slate100;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class SynorShellLoadingSkeleton extends StatelessWidget {
  const SynorShellLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SynorSkeletonShimmer(
      key: const ValueKey('synor-shell-skeleton'),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 132),
        children: [
          Row(
            children: const [
              SynorSkeletonBlock(width: 36, height: 36, radius: 18),
              SizedBox(width: 12),
              SynorSkeletonBlock(width: 112, height: 20, radius: 10),
              Spacer(),
              SynorSkeletonBlock(width: 44, height: 44, radius: 22),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: const [
              Expanded(child: _SearchFieldSkeleton()),
              SizedBox(width: 12),
              SynorSkeletonBlock(width: 52, height: 52, radius: 16),
              SizedBox(width: 12),
              SynorSkeletonBlock(width: 52, height: 52, radius: 16),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: StoryCard.dimension,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (context, index) => const _StoryCardSkeleton(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 44,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final widths = [116.0, 80.0, 100.0, 124.0];
                return SynorSkeletonBlock(
                  width: widths[index],
                  height: 44,
                  radius: 22,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const _LessonCardSkeleton(),
          const SizedBox(height: 16),
          const _LessonCardSkeleton(),
          const SizedBox(height: 16),
          const _LessonCardSkeleton(),
        ],
      ),
    );
  }
}

class SynorServicesLoadingSkeleton extends StatelessWidget {
  const SynorServicesLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SynorSkeletonShimmer(
      key: const ValueKey('synor-services-skeleton'),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 132),
        children: [
          const SynorSkeletonBlock(width: 108, height: 30, radius: 12),
          const SizedBox(height: 16),
          const _SearchFieldSkeleton(),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.95,
            children: const [
              _ServiceCardSkeleton(),
              _ServiceCardSkeleton(),
              _ServiceCardSkeleton(),
              _ServiceCardSkeleton(),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            children: const [
              SynorSkeletonBlock(width: 156, height: 24, radius: 10),
              Spacer(),
              SynorSkeletonBlock(width: 60, height: 16, radius: 8),
            ],
          ),
          const SizedBox(height: 16),
          const _RequestTileSkeleton(),
          const SizedBox(height: 12),
          const _RequestTileSkeleton(),
          const SizedBox(height: 12),
          const _RequestTileSkeleton(),
        ],
      ),
    );
  }
}

class SynorQuickAlertLoadingSkeleton extends StatelessWidget {
  const SynorQuickAlertLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SynorSkeletonShimmer(
      key: const ValueKey('synor-quick-alert-skeleton'),
      child: Column(
        children: List.generate(
          4,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: synorIsDark(context)
                    ? SynorColors.white5
                    : SynorColors.slate50,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  SynorSkeletonCircle(size: 18),
                  SizedBox(width: 12),
                  Expanded(child: SynorSkeletonBlock(height: 14, radius: 7)),
                  SizedBox(width: 12),
                  SynorSkeletonBlock(width: 18, height: 18, radius: 9),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchFieldSkeleton extends StatelessWidget {
  const _SearchFieldSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: synorIsDark(context) ? SynorColors.white5 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: synorIsDark(context)
              ? SynorColors.white10
              : SynorColors.slate200,
        ),
      ),
      child: const Row(
        children: [
          SynorSkeletonBlock(width: 18, height: 18, radius: 9),
          SizedBox(width: 12),
          Expanded(child: SynorSkeletonBlock(height: 14, radius: 7)),
        ],
      ),
    );
  }
}

class _StoryCardSkeleton extends StatelessWidget {
  const _StoryCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: StoryCard.dimension,
      child: Container(
        decoration: BoxDecoration(
          color: synorIsDark(context) ? SynorColors.panelBlack : Colors.white,
          borderRadius: BorderRadius.circular(StoryCard.outerRadius),
          border: Border.all(
            color: synorIsDark(context)
                ? SynorColors.white10
                : SynorColors.slate200,
          ),
          boxShadow: SynorShadows.soft,
        ),
        padding: const EdgeInsets.all(12),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SynorSkeletonCircle(size: 40),
            Spacer(),
            SynorSkeletonBlock(width: 54, height: 13, radius: 7),
            SizedBox(height: 6),
            SynorSkeletonBlock(width: 42, height: 13, radius: 7),
          ],
        ),
      ),
    );
  }
}

class _LessonCardSkeleton extends StatelessWidget {
  const _LessonCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return SynorGlassPanel(
      radius: SynorRadii.cardLarge,
      backgroundColor: synorIsDark(context)
          ? SynorColors.surfaceBlack
          : Colors.white,
      gradient: synorIsDark(context) ? SynorGradients.glassDark : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SynorSkeletonBlock(width: 180, height: 18, radius: 9),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: const [
                    _InfoRowSkeleton(),
                    SizedBox(height: 14),
                    _InfoRowSkeleton(),
                    SizedBox(height: 14),
                    _InfoRowSkeleton(),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const SizedBox(
                height: 104,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SynorSkeletonBlock(width: 92, height: 28, radius: 12),
                    SynorSkeletonBlock(width: 72, height: 22, radius: 10),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRowSkeleton extends StatelessWidget {
  const _InfoRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SynorSkeletonCircle(size: 18),
        SizedBox(width: 12),
        Expanded(child: SynorSkeletonBlock(height: 14, radius: 7)),
      ],
    );
  }
}

class _ServiceCardSkeleton extends StatelessWidget {
  const _ServiceCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return SynorGlassPanel(
      radius: SynorRadii.cardLarge,
      gradient: synorIsDark(context) ? SynorGradients.glassDark : null,
      child: const Column(
        children: [
          SynorSkeletonCircle(size: 56),
          SizedBox(height: 12),
          SynorSkeletonBlock(width: 96, height: 16, radius: 8),
          SizedBox(height: 8),
          SynorSkeletonBlock(width: 78, height: 12, radius: 6),
          SizedBox(height: 6),
          SynorSkeletonBlock(width: 88, height: 12, radius: 6),
        ],
      ),
    );
  }
}

class _RequestTileSkeleton extends StatelessWidget {
  const _RequestTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return SynorGlassPanel(
      radius: SynorRadii.card,
      padding: const EdgeInsets.all(16),
      backgroundColor: synorIsDark(context) ? SynorColors.white5 : Colors.white,
      child: const Row(
        children: [
          SynorSkeletonCircle(size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SynorSkeletonBlock(width: 148, height: 14, radius: 7),
                SizedBox(height: 8),
                SynorSkeletonBlock(width: 102, height: 12, radius: 6),
              ],
            ),
          ),
          SizedBox(width: 12),
          SynorSkeletonBlock(width: 68, height: 24, radius: 12),
        ],
      ),
    );
  }
}
