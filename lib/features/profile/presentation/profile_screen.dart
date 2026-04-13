import 'dart:ui';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/application/app_session_controller.dart';
import '../../../app/router/app_route_controller.dart';
import '../../../app/theme/synor_design_tokens.dart';
import '../../../l10n/app_localization_x.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/widgets/synor_widgets.dart';
import '../application/cover_template_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    super.key,
    required this.profile,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onUpdateCover,
    required this.onUploadCover,
    required this.onOpenMessages,
    required this.showSettings,
    required this.onOpenSettings,
    required this.onCloseSettings,
    required this.onSignOut,
    required this.onUpdateBio,
  });

  final ProfileData profile;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final ValueChanged<String> onUpdateCover;
  final ValueChanged<Uint8List> onUploadCover;
  final ValueChanged<String> onUpdateBio;
  final VoidCallback onOpenMessages;
  final bool showSettings;
  final VoidCallback onOpenSettings;
  final VoidCallback onCloseSettings;
  final VoidCallback onSignOut;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isCoverPickerOpen = false;
  bool _connectionRequested = false;

  void _openCoverPicker() {
    setState(() {
      _isCoverPickerOpen = true;
    });
  }

  Future<void> _pickCoverFromDevice() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'gif'],
      withData: true,
    );
    if (!mounted || result == null) return;

    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      showSynorToast(
        context,
        message: context.l10n.profile_coverUploadFailed,
        subtitle: context.l10n.profile_coverUploadFailedSubtitle,
        icon: LucideIcons.circle_alert,
        accentColor: SynorColors.rose500,
      );
      return;
    }
    if (file.size > 5 * 1024 * 1024) {
      showSynorToast(
        context,
        message: context.l10n.profile_coverTooLarge,
        subtitle: context.l10n.profile_coverTooLargeSubtitle,
        icon: LucideIcons.image_off,
        accentColor: SynorColors.rose500,
      );
      return;
    }

    widget.onUploadCover(bytes);
    if (!mounted) return;
    setState(() {
      _isCoverPickerOpen = false;
    });
    showSynorToast(
      context,
      message: context.l10n.profile_coverUpdated,
      subtitle: file.name,
      icon: LucideIcons.image_plus,
      accentColor: SynorColors.emerald500,
    );
  }

  Future<void> _shareProfile() async {
    await Clipboard.setData(
      ClipboardData(text: 'synor://profile/${widget.profile.username}'),
    );
    if (!mounted) return;
    showSynorToast(
      context,
      message: context.l10n.profile_profileLinkCopied,
      subtitle: widget.profile.username,
      icon: LucideIcons.share_2,
    );
  }

  Future<void> _showQrCode() async {
    await Clipboard.setData(
      ClipboardData(text: 'SYNOR PROFILE ${widget.profile.username}'),
    );
    if (!mounted) return;
    showSynorToast(
      context,
      message: context.l10n.profile_profileCodeCopied,
      subtitle: context.l10n.profile_profileCodeCopiedSubtitle,
      icon: LucideIcons.qr_code,
    );
  }

  void _toggleConnection() {
    setState(() {
      _connectionRequested = !_connectionRequested;
    });
    showSynorToast(
      context,
      message: _connectionRequested
          ? context.l10n.profile_connectionRequestSent
          : context.l10n.profile_connectionRequestRemoved,
      subtitle: widget.profile.name,
      icon: _connectionRequested ? LucideIcons.user_check : LucideIcons.user_x,
      accentColor: _connectionRequested
          ? SynorColors.emerald500
          : SynorColors.amber500,
    );
  }



  @override
  Widget build(BuildContext context) {
    final coverTemplates = ref.watch(coverTemplatesProvider);
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildCoverHeader(context),
            Transform.translate(
              offset: const Offset(0, -96),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 132),
                child: Column(
                  children: [
                    _buildIdentitySection(context),
                    const SizedBox(height: 28),
                    _buildQuickActions(context),
                    const SizedBox(height: 24),
                    _buildActivitySection(context),
                    const SizedBox(height: 24),
                    _buildServicesSection(context),
                    const SizedBox(height: 24),
                    _buildPreferencesSection(context),
                    const SizedBox(height: 20),
                    _buildLogoutButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !widget.showSettings,
            child: AnimatedSwitcher(
              duration: SynorMotion.overlay,
              reverseDuration: SynorMotion.overlay,
              layoutBuilder: synorStackedLayoutBuilder(fit: StackFit.expand),
              transitionBuilder: synorFadeSlideTransitionBuilder(
                begin: const Offset(0.028, 0),
              ),
              child: widget.showSettings
                  ? KeyedSubtree(
                      key: const ValueKey('profile-settings-overlay'),
                      child: _SettingsOverlay(
                        profile: widget.profile,
                        isDarkMode: widget.isDarkMode,
                        onToggleTheme: widget.onToggleTheme,
                        onClose: widget.onCloseSettings,
                        onSignOut: widget.onSignOut,
                      ),
                    )
                  : const SizedBox.shrink(
                      key: ValueKey('profile-settings-hidden'),
                    ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !_isCoverPickerOpen,
            child: AnimatedSwitcher(
              duration: SynorMotion.overlay,
              reverseDuration: SynorMotion.overlay,
              layoutBuilder: synorStackedLayoutBuilder(
                alignment: Alignment.bottomCenter,
                fit: StackFit.expand,
              ),
              transitionBuilder: synorFadeSlideTransitionBuilder(
                begin: const Offset(0, 0.045),
              ),
              child: _isCoverPickerOpen
                  ? KeyedSubtree(
                      key: const ValueKey('cover-picker-overlay'),
                      child: _CoverPickerOverlay(
                        coverTemplates: coverTemplates,
                        selectedCover: widget.profile.coverAsset,
                        hasCustomCover: widget.profile.customCoverBytes != null,
                        onClose: () {
                          setState(() {
                            _isCoverPickerOpen = false;
                          });
                        },
                        onUpload: _pickCoverFromDevice,
                        onSelect: (assetPath) {
                          widget.onUpdateCover(assetPath);
                          setState(() {
                            _isCoverPickerOpen = false;
                          });
                          showSynorToast(
                            context,
                            message: context.l10n.profile_coverUpdated,
                            subtitle: assetPath.split('/').last,
                            icon: LucideIcons.image,
                            accentColor: SynorColors.indigo500,
                          );
                        },
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('cover-picker-hidden')),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoverHeader(BuildContext context) {
    return SizedBox(
      height: 224,
      child: DecoratedBox(
        decoration: const BoxDecoration(boxShadow: SynorShadows.soft),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(SynorRadii.cover),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (widget.profile.customCoverBytes != null)
                Image.memory(
                  widget.profile.customCoverBytes!,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                )
              else
                Image.asset(widget.profile.coverAsset, fit: BoxFit.cover),
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _openCoverPicker,
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                      (synorIsDark(context)
                              ? SynorColors.appBlack
                              : SynorColors.lightBackground)
                          .withValues(alpha: 0.95),
                    ],
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: SynorColors.indigo900.withValues(alpha: 0.2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 42, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        _CoverAction(
                          icon: LucideIcons.share_2,
                          onTap: _shareProfile,
                        ),
                        const SizedBox(width: 12),
                        _CoverAction(
                          icon: LucideIcons.settings,
                          onTap: widget.onOpenSettings,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: _CoverAction(
                        icon: LucideIcons.camera,
                        onTap: _openCoverPicker,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdentitySection(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Transform.scale(
                scale: 1.2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: SynorColors.indigo500.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
            Container(
              width: 144,
              height: 144,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: synorIsDark(context)
                    ? SynorColors.appBlack
                    : SynorColors.slate50,
                boxShadow: SynorShadows.heavy,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: synorIsDark(context)
                        ? SynorColors.white10
                        : SynorColors.slate100,
                    width: 2,
                  ),
                  image: DecorationImage(
                    image: AssetImage(widget.profile.avatarAsset),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 6,
              bottom: 10,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: SynorColors.emerald500,
                  border: Border.all(
                    color: synorIsDark(context)
                        ? SynorColors.appBlack
                        : SynorColors.slate50,
                    width: 3,
                  ),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 9,
                    height: 9,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.profile.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: SynorColors.blue500,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.circle_check_big,
                size: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        if (widget.profile.university != null)
          Text(
            '${widget.profile.username} • ${widget.profile.university}',
            style: TextStyle(
              color: synorSecondaryText(context),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          )
        else
          Text(
            widget.profile.username,
            style: TextStyle(
              color: synorSecondaryText(context),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        const SizedBox(height: 18),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            if (widget.profile.program != null)
              _ProfileTag(
                icon: LucideIcons.brain,
                label: context.l10n.profileProgramLabel(widget.profile.program!),
                color: SynorColors.indigo500,
              ),
            if (widget.profile.yearLabel != null)
              _ProfileTag(
                icon: LucideIcons.graduation_cap,
                label: context.l10n.profileYearLabel(widget.profile.yearLabel!),
              ),
            if (widget.profile.gpa != null)
              _ProfileTag(
                icon: LucideIcons.calculator,
                label: '${context.l10n.profile_currentGpa}: ${widget.profile.gpa!.toStringAsFixed(2)}',
                color: SynorColors.emerald500,
              ),
            _ProfileTag(
              icon: LucideIcons.users,
              label: context.l10n.profileGroupLabel(widget.profile.groupLabel),
            ),
          ],
        ),
        const SizedBox(height: 24),
        PressableScale(
          onTap: () async {
            final currentBio = widget.profile.bio ?? '';
            final controller = TextEditingController(text: currentBio);
            final newBio = await showDialog<String>(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  backgroundColor: synorIsDark(context) ? SynorColors.surfaceBlack : Colors.white,
                  title: Text(
                    'Edit Bio',
                    style: TextStyle(color: synorPrimaryText(context)),
                  ),
                  content: TextField(
                    controller: controller,
                    maxLines: 4,
                    maxLength: 160,
                    style: TextStyle(color: synorPrimaryText(context)),
                    decoration: InputDecoration(
                      hintText: 'Write something about yourself...',
                      hintStyle: TextStyle(color: synorSecondaryText(context)),
                      filled: true,
                      fillColor: synorIsDark(context) ? SynorColors.white5 : SynorColors.slate50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text('Cancel', style: TextStyle(color: synorSecondaryText(context))),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SynorColors.indigo500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.of(dialogContext).pop(controller.text),
                      child: const Text('Save'),
                    ),
                  ],
                );
              },
            );

            if (newBio != null && newBio != currentBio && context.mounted) {
              widget.onUpdateBio(newBio.trim().isEmpty ? '' : newBio.trim());
              showSynorToast(
                context,
                message: 'Bio Updated',
                icon: LucideIcons.circle_check_big,
                accentColor: SynorColors.indigo500,
              );
            }
          },
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: -8,
                child: Text(
                  '"',
                  style: TextStyle(
                    color: synorIsDark(context)
                        ? SynorColors.white5
                        : SynorColors.slate200,
                    fontSize: 44,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                child: Text(
                  (widget.profile.bio == null || widget.profile.bio!.isEmpty)
                      ? 'Tap to add your biography...'
                      : widget.profile.bio!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: (widget.profile.bio == null || widget.profile.bio!.isEmpty)
                        ? synorSecondaryText(context).withValues(alpha: 0.6)
                        : synorSecondaryText(context),
                    fontSize: 14,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: -14,
                child: Text(
                  '"',
                  style: TextStyle(
                    color: synorIsDark(context)
                        ? SynorColors.white5
                        : SynorColors.slate200,
                    fontSize: 44,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: _connectionRequested
                ? context.l10n.profile_connected
                : context.l10n.profile_connect,
            icon: LucideIcons.user_plus,
            filled: true,
            onTap: _toggleConnection,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            label: context.l10n.profile_message,
            icon: LucideIcons.message_square,
            onTap: widget.onOpenMessages,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 56,
          child: _ActionButton(icon: LucideIcons.qr_code, onTap: _showQrCode),
        ),
      ],
    );
  }



  Widget _buildActivitySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: context.l10n.profile_recentActivity,
          actionLabel: context.l10n.profile_viewAll,
        ),
        const SizedBox(height: 14),
        _ActivityCard(
          icon: LucideIcons.file_text,
          color: SynorColors.indigo500,
          title: context.l10n.profile_recentSharedNotesTitle,
          subtitle: context.l10n.profile_recentSharedNotesSubtitle,
          meta: context.l10n.profile_hoursAgo(2),
          showReactions: true,
        ),
        const SizedBox(height: 12),
        _ActivityCard(
          icon: LucideIcons.users,
          color: SynorColors.purple500,
          title: context.l10n.profile_recentJoinedGroupTitle,
          subtitle: context.l10n.profile_recentJoinedGroupSubtitle,
          meta: context.l10n.profile_yesterday,
        ),
      ],
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: context.l10n.profile_studentServices),
        const SizedBox(height: 12),
        _RowGroup(
          children: [
            _ProfileRow(
              icon: LucideIcons.file_badge,
              iconColor: SynorColors.indigo500,
              title: context.l10n.profile_servicesDocuments,
              subtitle: context.l10n.profile_servicesDocumentsSubtitle,
            ),
            _ProfileRow(
              icon: LucideIcons.credit_card,
              iconColor: SynorColors.emerald500,
              title: context.l10n.profile_servicesFinance,
              subtitle: context.l10n.profile_servicesFinanceSubtitle,
            ),
            _ProfileRow(
              icon: LucideIcons.building,
              iconColor: SynorColors.rose500,
              title: context.l10n.profile_servicesHousing,
              subtitle: context.l10n.profile_servicesHousingSubtitle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: context.l10n.profile_settings),
        const SizedBox(height: 12),
        _RowGroup(
          children: [
            _ProfileRow(
              icon: LucideIcons.shield,
              title: context.l10n.profile_privacySecurity,
            ),
            _ProfileToggleRow(
              icon: widget.isDarkMode ? LucideIcons.moon : LucideIcons.sun,
              title: context.l10n.profile_darkMode,
              value: widget.isDarkMode,
              onTap: widget.onToggleTheme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return PressableScale(
      onTap: widget.onSignOut,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: synorIsDark(context)
              ? SynorColors.rose500.withValues(alpha: 0.12)
              : SynorColors.rose50,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: synorIsDark(context)
                ? SynorColors.rose500.withValues(alpha: 0.2)
                : SynorColors.rose100,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.log_out,
              color: synorIsDark(context)
                  ? SynorColors.rose400
                  : SynorColors.rose600,
            ),
            const SizedBox(width: 10),
            Text(
              context.l10n.profile_logOut,
              style: TextStyle(
                color: synorIsDark(context)
                    ? SynorColors.rose400
                    : SynorColors.rose600,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverAction extends StatelessWidget {
  const _CoverAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: SynorColors.white10),
          boxShadow: SynorShadows.soft,
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: ColoredBox(
              color: Colors.black.withValues(alpha: 0.3),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileTag extends StatelessWidget {
  const _ProfileTag({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color;
    final isDark = synorIsDark(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: accent != null
            ? accent.withValues(alpha: isDark ? 0.12 : 0.08)
            : (isDark ? SynorColors.white5 : SynorColors.slate100),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accent != null
              ? accent.withValues(alpha: isDark ? 0.22 : 0.14)
              : (isDark ? SynorColors.white10 : SynorColors.slate200),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent ?? synorSecondaryText(context)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: accent ?? synorPrimaryText(context),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    this.label,
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final String? label;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final isDark = synorIsDark(context);
    return PressableScale(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: filled
              ? (isDark ? Colors.white : SynorColors.slate900)
              : (isDark ? SynorColors.white5 : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: filled
                ? Colors.transparent
                : (isDark ? SynorColors.white10 : SynorColors.slate200),
          ),
          boxShadow: SynorShadows.soft,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: filled
                    ? (isDark ? Colors.black : Colors.white)
                    : synorPrimaryText(context),
              ),
              if (label != null) ...[
                const SizedBox(width: 8),
                Text(
                  label!,
                  style: TextStyle(
                    fontSize: 14,
                    color: filled
                        ? (isDark ? Colors.black : Colors.white)
                        : synorPrimaryText(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}



class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel});

  final String title;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: synorPrimaryText(context),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        if (actionLabel != null)
          Text(
            actionLabel!,
            style: TextStyle(
              color: synorIsDark(context)
                  ? SynorColors.indigo400
                  : SynorColors.indigo600,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.meta,
    this.showReactions = false,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String meta;
  final bool showReactions;

  @override
  Widget build(BuildContext context) {
    return SynorGlassPanel(
      radius: SynorRadii.card,
      padding: const EdgeInsets.all(16),
      backgroundColor: synorIsDark(context) ? SynorColors.white5 : Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(
                alpha: synorIsDark(context) ? 0.12 : 0.08,
              ),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: synorPrimaryText(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      meta,
                      style: TextStyle(
                        color: synorSecondaryText(context),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: synorSecondaryText(context),
                    height: 1.45,
                  ),
                ),
                if (showReactions) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.thumbs_up,
                        size: 16,
                        color: synorSecondaryText(context),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '24',
                        style: TextStyle(
                          color: synorSecondaryText(context),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Icon(
                        LucideIcons.message_square,
                        size: 16,
                        color: synorSecondaryText(context),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '5',
                        style: TextStyle(
                          color: synorSecondaryText(context),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RowGroup extends StatelessWidget {
  const _RowGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: synorIsDark(context) ? SynorColors.white5 : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: synorIsDark(context)
              ? SynorColors.white10
              : SynorColors.slate200,
        ),
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isEven) {
            return children[index ~/ 2];
          }
          return Divider(
            height: 1,
            color: synorIsDark(context)
                ? SynorColors.white5
                : SynorColors.slate100,
          );
        }),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (iconColor ?? SynorColors.slate500).withValues(
                alpha: synorIsDark(context) ? 0.14 : 0.08,
              ),
            ),
            child: Icon(
              icon,
              color: iconColor ?? synorSecondaryText(context),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: synorPrimaryText(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle!,
                      style: TextStyle(
                        color: synorSecondaryText(context),
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Icon(
            LucideIcons.chevron_right,
            size: 18,
            color: synorSecondaryText(context),
          ),
        ],
      ),
    );
    if (onTap == null) {
      return content;
    }
    return PressableScale(onTap: onTap!, child: content);
  }
}

class _ProfileToggleRow extends StatelessWidget {
  const _ProfileToggleRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: synorIsDark(context)
                    ? SynorColors.indigo500.withValues(alpha: 0.14)
                    : SynorColors.indigo50,
              ),
              child: Icon(
                icon,
                color: synorIsDark(context)
                    ? SynorColors.indigo400
                    : SynorColors.indigo600,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: synorPrimaryText(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            AnimatedContainer(
              duration: SynorMotion.fast,
              width: 48,
              height: 26,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: value
                    ? SynorColors.indigo600
                    : (synorIsDark(context)
                          ? SynorColors.neutral700
                          : SynorColors.slate300),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Align(
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(width: 20, height: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsOverlay extends ConsumerWidget {
  const _SettingsOverlay({
    required this.profile,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onClose,
    required this.onSignOut,
  });

  final ProfileData profile;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onClose;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appSessionControllerProvider).locale;
    return Material(
      color: synorIsDark(context)
          ? SynorColors.appBlack
          : SynorColors.lightBackground,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
            decoration: BoxDecoration(
              color: synorIsDark(context)
                  ? SynorColors.surfaceBlack
                  : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: synorIsDark(context)
                      ? SynorColors.white10
                      : SynorColors.slate200,
                ),
              ),
            ),
            child: Row(
              children: [
                SynorIconActionButton(
                  icon: LucideIcons.chevron_left,
                  onTap: onClose,
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
                Text(
                  context.l10n.profile_settings,
                  style: TextStyle(
                    color: synorPrimaryText(context),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              children: [
                SynorGlassPanel(
                  radius: SynorRadii.card,
                  padding: const EdgeInsets.all(16),
                  backgroundColor: synorIsDark(context)
                      ? SynorColors.white5
                      : Colors.white,
                  child: Row(
                    children: [
                      AvatarCircle(
                        assetPath: profile.avatarAsset,
                        fallbackIcon: LucideIcons.user,
                        size: 64,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: TextStyle(
                                color: synorPrimaryText(context),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (profile.program != null)
                              Text(
                                context.l10n.profileProgramLabel(profile.program!),
                                style: TextStyle(
                                  color: synorSecondaryText(context),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: synorIsDark(context)
                              ? SynorColors.indigo500.withValues(alpha: 0.14)
                              : SynorColors.indigo50,
                        ),
                        child: Icon(
                          LucideIcons.pen_line,
                          color: synorIsDark(context)
                              ? SynorColors.indigo400
                              : SynorColors.indigo600,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _SettingsCaption(label: context.l10n.profile_preferences),
                const SizedBox(height: 12),
                _RowGroup(
                  children: [
                    _ProfileToggleRow(
                      icon: isDarkMode ? LucideIcons.moon : LucideIcons.sun,
                      title: context.l10n.profile_darkMode,
                      value: isDarkMode,
                      onTap: onToggleTheme,
                    ),
                    _ProfileRow(
                      icon: LucideIcons.globe,
                      iconColor: SynorColors.emerald500,
                      title: context.l10n.profile_language,
                      subtitle: context.l10n.localeLabel(locale),
                      onTap: () async {
                        final selected = await showModalBottomSheet<Locale>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (sheetContext) =>
                              _LanguagePickerSheet(currentLocale: locale),
                        );
                        if (!context.mounted || selected == null) {
                          return;
                        }
                        ref
                            .read(appRouteControllerProvider)
                            .setLocale(selected);
                        showSynorToast(
                          context,
                          message: context.l10n.profile_languageChanged,
                          subtitle: context.l10n
                              .profile_languageChangedSubtitle(
                                context.l10n.localeLabel(selected),
                              ),
                          icon: LucideIcons.languages,
                          accentColor: SynorColors.indigo500,
                        );
                      },
                    ),
                    _ProfileRow(
                      icon: LucideIcons.bell,
                      iconColor: SynorColors.rose500,
                      title: context.l10n.profile_notifications,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _SettingsCaption(label: context.l10n.profile_security),
                const SizedBox(height: 12),
                _RowGroup(
                  children: [
                    _ProfileRow(
                      icon: LucideIcons.shield,
                      iconColor: SynorColors.amber500,
                      title: context.l10n.profile_passwordSecurity,
                    ),
                    _ProfileRow(
                      icon: LucideIcons.lock,
                      iconColor: SynorColors.blue500,
                      title: context.l10n.profile_privacySettings,
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                PressableScale(
                  onTap: onSignOut,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: synorIsDark(context)
                          ? SynorColors.rose500.withValues(alpha: 0.12)
                          : SynorColors.rose50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.log_out,
                          color: synorIsDark(context)
                              ? SynorColors.rose400
                              : SynorColors.rose600,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          context.l10n.profile_logOut,
                          style: TextStyle(
                            color: synorIsDark(context)
                                ? SynorColors.rose400
                                : SynorColors.rose600,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCaption extends StatelessWidget {
  const _SettingsCaption({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: synorSecondaryText(context),
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
      ),
    );
  }
}

class _LanguagePickerSheet extends StatelessWidget {
  const _LanguagePickerSheet({required this.currentLocale});

  final Locale currentLocale;

  @override
  Widget build(BuildContext context) {
    final options = [
      const Locale('en'),
      const Locale('ru'),
      const Locale('kk'),
    ];
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const SynorModalScrim(opacity: 0.6),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: synorIsDark(context)
                  ? SynorColors.surfaceBlack
                  : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SynorBottomSheetHandle(),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.profile_language,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ...options.map((locale) {
                      final selected =
                          locale.languageCode == currentLocale.languageCode;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: PressableScale(
                          onTap: () => Navigator.of(context).pop(locale),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? (synorIsDark(context)
                                        ? SynorColors.indigo500.withValues(
                                            alpha: 0.12,
                                          )
                                        : SynorColors.indigo50)
                                  : (synorIsDark(context)
                                        ? SynorColors.white5
                                        : SynorColors.slate50),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: selected
                                    ? (synorIsDark(context)
                                          ? SynorColors.indigo500.withValues(
                                              alpha: 0.28,
                                            )
                                          : SynorColors.indigo200)
                                    : (synorIsDark(context)
                                          ? SynorColors.white10
                                          : SynorColors.slate200),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    context.l10n.localeLabel(locale),
                                    style: TextStyle(
                                      color: synorPrimaryText(context),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (selected)
                                  Icon(
                                    LucideIcons.circle_check_big,
                                    color: synorIsDark(context)
                                        ? SynorColors.indigo300
                                        : SynorColors.indigo600,
                                    size: 18,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CoverPickerOverlay extends StatelessWidget {
  const _CoverPickerOverlay({
    required this.coverTemplates,
    required this.selectedCover,
    required this.hasCustomCover,
    required this.onClose,
    required this.onUpload,
    required this.onSelect,
  });

  final List<CoverTemplate> coverTemplates;
  final String selectedCover;
  final bool hasCustomCover;
  final VoidCallback onClose;
  final VoidCallback onUpload;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: const SynorModalScrim(opacity: 0.6),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: math.min(
                MediaQuery.sizeOf(context).height * 0.85,
                720,
              ),
            ),
            decoration: BoxDecoration(
              color: synorIsDark(context)
                  ? SynorColors.surfaceBlack
                  : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                      decoration: BoxDecoration(
                        color: synorIsDark(context)
                            ? SynorColors.surfaceBlack.withValues(alpha: 0.8)
                            : Colors.white.withValues(alpha: 0.8),
                        border: Border(
                          bottom: BorderSide(
                            color: synorIsDark(context)
                                ? SynorColors.white5
                                : SynorColors.slate100,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            context.l10n.profile_editCover,
                            style: TextStyle(
                              color: synorPrimaryText(context),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          SynorIconActionButton(
                            icon: LucideIcons.x,
                            onTap: onClose,
                            buttonSize: 40,
                            radius: 999,
                            backgroundColor: synorIsDark(context)
                                ? SynorColors.white5
                                : SynorColors.slate100,
                            borderColor: Colors.transparent,
                            boxShadow: const [],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                    children: [
                      _UploadCard(isSelected: hasCustomCover, onTap: onUpload),
                      const SizedBox(height: 24),
                      Text(
                        context.l10n.profile_chooseFromTemplates,
                        style: TextStyle(
                          color: synorPrimaryText(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: coverTemplates.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 4 / 3,
                            ),
                        itemBuilder: (context, index) {
                          final template = coverTemplates[index];
                          final selected = template.assetPath == selectedCover;
                          return PressableScale(
                            onTap: () => onSelect(template.assetPath),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: selected
                                      ? SynorColors.indigo500
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      template.assetPath,
                                      fit: BoxFit.cover,
                                    ),
                                    if (selected)
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: SynorColors.indigo500
                                              .withValues(alpha: 0.2),
                                        ),
                                        child: const Center(
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: SynorColors.indigo500,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Icon(
                                                LucideIcons.circle_check_big,
                                                color: Colors.white,
                                              ),
                                            ),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({required this.onTap, required this.isSelected});

  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: isSelected
              ? SynorColors.indigo500
              : (synorIsDark(context)
                    ? SynorColors.white20
                    : SynorColors.slate300),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? (synorIsDark(context)
                            ? SynorColors.indigo500.withValues(alpha: 0.14)
                            : SynorColors.indigo50)
                      : (synorIsDark(context)
                            ? SynorColors.white5
                            : SynorColors.slate100),
                ),
                child: Icon(
                  isSelected
                      ? LucideIcons.circle_check_big
                      : LucideIcons.upload,
                  color: isSelected
                      ? (synorIsDark(context)
                            ? SynorColors.indigo300
                            : SynorColors.indigo600)
                      : synorSecondaryText(context),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                isSelected
                    ? context.l10n.profile_usingUploadedCover
                    : context.l10n.profile_uploadFromDevice,
                style: TextStyle(
                  color: synorPrimaryText(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isSelected
                    ? context.l10n.profile_replaceUploadedCover
                    : context.l10n.profile_uploadRequirements,
                style: TextStyle(
                  color: synorSecondaryText(context),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    const dash = 9.0;
    const gap = 6.0;
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(24),
    );
    final path = Path()..addRRect(rect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = math.min(distance + dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
