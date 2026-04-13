import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../app/theme/synor_design_tokens.dart';
import '../../l10n/app_localization_x.dart';
import '../../l10n/l10n.dart';
import '../models/app_models.dart';
import 'base_layout.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({super.key, required this.story, this.onTap});

  static const double dimension = 112; // Increased slightly for better look
  static const double outerRadius = 26;
  static const double outerBorderWidth = 3;
  static const double innerInset = 4;
  static const double innerRadius = outerRadius - innerInset;

  final StoryItem story;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: _buildCard(context),
    );
  }

  Widget _buildCard(BuildContext context) {
    final isDark = synorIsDark(context);
    final glow = switch (story.borderColor) {
      SynorColors.purple600 =>
        isDark ? SynorShadows.storyPurpleGlow : SynorShadows.soft,
      SynorColors.rose500 =>
        isDark ? SynorShadows.storyRoseGlow : SynorShadows.soft,
      SynorColors.emerald500 =>
        isDark ? SynorShadows.storyEmeraldGlow : SynorShadows.soft,
      SynorColors.cyan500 =>
        isDark ? SynorShadows.storyCyanGlow : SynorShadows.soft,
      SynorColors.yellow400 =>
        isDark ? SynorShadows.storyYellowGlow : SynorShadows.soft,
      _ => isDark ? SynorShadows.medium : SynorShadows.soft,
    };
    final innerSurfaceColor = isDark
        ? SynorColors.surfaceBlack.withValues(alpha: 0.94)
        : Colors.white.withValues(alpha: 0.98);
    final innerBorderColor = isDark ? SynorColors.white8 : SynorColors.slate100;
    final avatarBackground = isDark ? Colors.white : SynorColors.slate100;
    final avatarBorder = isDark ? SynorColors.white10 : SynorColors.slate200;
    final fallbackIconColor = isDark ? Colors.black : SynorColors.slate800;

    return SizedBox.square(
      dimension: dimension,
      child: AnimatedContainer(
        duration: SynorMotion.theme,
        curve: SynorMotion.themeCurve,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(outerRadius),
          border: Border.all(
            color: story.isAddStory || story.hasUnviewed
                ? story.borderColor
                : (isDark ? SynorColors.white10 : SynorColors.slate200),
            width: outerBorderWidth,
          ),
          boxShadow: (story.isAddStory || story.hasUnviewed) ? glow : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(innerInset),
          child: TweenAnimationBuilder<double>(
            duration: SynorMotion.theme,
            curve: SynorMotion.themeCurve,
            tween: Tween(end: isDark ? SynorBlur.light : SynorBlur.subtle),
            builder: (context, blur, _) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(innerRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: AnimatedContainer(
                    duration: SynorMotion.theme,
                    curve: SynorMotion.themeCurve,
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 13),
                    decoration: BoxDecoration(
                      color: innerSurfaceColor,
                      gradient: isDark
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                SynorColors.panelBlack.withValues(alpha: 0.96),
                                SynorColors.surfaceBlack.withValues(
                                  alpha: 0.92,
                                ),
                              ],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(innerRadius),
                      border: Border.all(color: innerBorderColor, width: 0.75),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedContainer(
                              duration: SynorMotion.theme,
                              curve: SynorMotion.themeCurve,
                              width: 39,
                              height: 39,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: avatarBackground,
                                border: Border.all(color: avatarBorder),
                                image: story.avatarAsset != null
                                    ? DecorationImage(
                                        image: AssetImage(story.avatarAsset!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: story.avatarAsset == null
                                  ? TweenAnimationBuilder<Color?>(
                                      duration: SynorMotion.theme,
                                      curve: SynorMotion.themeCurve,
                                      tween: ColorTween(end: fallbackIconColor),
                                      builder: (context, color, _) {
                                        return Icon(
                                          story.icon ?? LucideIcons.user,
                                          size: 24,
                                          color: color ?? fallbackIconColor,
                                        );
                                      },
                                    )
                                  : null,
                            ),
                            if (story.isAddStory)
                              Positioned(
                                right: -4,
                                bottom: -4,
                                child: AnimatedContainer(
                                  duration: SynorMotion.theme,
                                  curve: SynorMotion.themeCurve,
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDark
                                        ? SynorColors.neutral800
                                        : Colors.white,
                                    border: Border.all(
                                      color: isDark
                                          ? SynorColors.neutral400
                                          : SynorColors.slate200,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: TweenAnimationBuilder<Color?>(
                                    duration: SynorMotion.theme,
                                    curve: SynorMotion.themeCurve,
                                    tween: ColorTween(
                                      end: isDark
                                          ? Colors.white
                                          : SynorColors.slate800,
                                    ),
                                    builder: (context, color, _) {
                                      return Icon(
                                        LucideIcons.plus,
                                        size: 12,
                                        color: color,
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: AnimatedDefaultTextStyle(
                            duration: SynorMotion.theme,
                            curve: SynorMotion.themeCurve,
                            style: TextStyle(
                              color: synorPrimaryText(context),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              height: 1.0,
                              letterSpacing: 0.1,
                            ),
                            child: Text(
                              story.isAddStory
                                  ? context.l10n.home_addStoryLabel
                                  : story.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: SynorGlassPanel(
        radius: SynorRadii.cardLarge,
        gradient: synorIsDark(context) ? SynorGradients.glassDark : null,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(
                  alpha: synorIsDark(context) ? 0.16 : 0.1,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: synorPrimaryText(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: synorSecondaryText(context),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestTile extends StatelessWidget {
  const RequestTile({super.key, required this.request, required this.onTap});

  final ServiceRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = switch (request.type) {
      RequestType.document => LucideIcons.file_text,
      RequestType.housing => LucideIcons.building,
      RequestType.payment => LucideIcons.credit_card,
      RequestType.support => LucideIcons.circle_question_mark,
    };

    return PressableScale(
      onTap: onTap,
      child: SynorGlassPanel(
        radius: SynorRadii.card,
        padding: const EdgeInsets.all(16),
        backgroundColor: synorIsDark(context)
            ? SynorColors.white5
            : Colors.white,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: synorIsDark(context)
                    ? Colors.black.withValues(alpha: 0.2)
                    : SynorColors.slate100,
              ),
              child: Icon(icon, size: 20, color: synorSecondaryText(context)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.serviceRequestTitleLabel(request.title),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: synorPrimaryText(context),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${context.l10n.services_date}: ${context.l10n.serviceRequestDateLabel(request.date)}',
                    style: TextStyle(
                      color: synorSecondaryText(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 108),
              child: Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: RequestStatusBadge(status: request.status),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestStatusBadge extends StatelessWidget {
  const RequestStatusBadge({super.key, required this.status});

  final RequestStatus status;

  @override
  Widget build(BuildContext context) {
    late final Color background;
    late final Color foreground;
    final isDark = synorIsDark(context);
    switch (status) {
      case RequestStatus.ready:
        background = isDark
            ? SynorColors.emerald500.withValues(alpha: 0.1)
            : SynorColors.emerald50;
        foreground = isDark ? SynorColors.emerald400 : SynorColors.emerald600;
      case RequestStatus.pending:
      case RequestStatus.processing:
      case RequestStatus.open:
        background = isDark
            ? SynorColors.blue500.withValues(alpha: 0.1)
            : const Color(0xFFEFF6FF);
        foreground = isDark ? SynorColors.blue400 : SynorColors.blue600;
      case RequestStatus.inProgress:
        background = isDark
            ? SynorColors.amber500.withValues(alpha: 0.1)
            : SynorColors.amber50;
        foreground = isDark ? SynorColors.amber400 : SynorColors.amber600;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        context.l10n.requestStatusLabel(status),
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile({super.key, required this.preview, this.onTap});

  final MessagePreview preview;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: SynorGlassPanel(
        radius: SynorRadii.xl,
        padding: const EdgeInsets.all(16),
        backgroundColor: synorIsDark(context) ? SynorColors.white5 : Colors.white,
        child: Row(
          children: [
            AvatarCircle(
              assetPath: preview.avatarAsset,
              fallbackIcon: preview.fallbackIcon ?? LucideIcons.user,
              size: 48,
              backgroundColor: preview.avatarAsset == null
                  ? (synorIsDark(context)
                        ? SynorColors.indigo500.withValues(alpha: 0.2)
                        : SynorColors.indigo100)
                  : null,
              foregroundColor: synorIsDark(context)
                  ? SynorColors.indigo400
                  : SynorColors.indigo600,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.l10n.messageNameLabel(preview.name),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: synorPrimaryText(context),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        context.l10n.messageTimestampLabel(preview.timestamp),
                        style: TextStyle(
                          color: synorIsDark(context)
                              ? SynorColors.neutral500
                              : SynorColors.slate400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.messagePreviewLabel(preview.preview),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: synorSecondaryText(context),
                      fontSize: 14,
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
}

class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    required this.assetPath,
    required this.fallbackIcon,
    required this.size,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String? assetPath;
  final IconData fallbackIcon;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(
          color: synorIsDark(context)
              ? SynorColors.white10
              : SynorColors.slate200,
        ),
        image: assetPath != null
            ? DecorationImage(image: AssetImage(assetPath!), fit: BoxFit.cover)
            : null,
      ),
      child: assetPath == null
          ? Icon(
              fallbackIcon,
              size: size / 2.2,
              color: foregroundColor ?? synorSecondaryText(context),
            )
          : null,
    );
  }
}
