import 'dart:ui';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../app/theme/synor_design_tokens.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/widgets/synor_widgets.dart';

class ProfileScreen extends StatefulWidget {
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
  });

  final ProfileData profile;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final ValueChanged<String> onUpdateCover;
  final ValueChanged<Uint8List> onUploadCover;
  final VoidCallback onOpenMessages;
  final bool showSettings;
  final VoidCallback onOpenSettings;
  final VoidCallback onCloseSettings;
  final VoidCallback onSignOut;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        message: 'Cover upload failed',
        subtitle: 'The selected image could not be loaded.',
        icon: LucideIcons.circle_alert,
        accentColor: SynorColors.rose500,
      );
      return;
    }
    if (file.size > 5 * 1024 * 1024) {
      showSynorToast(
        context,
        message: 'Image is too large',
        subtitle: 'Choose a JPG, PNG, or GIF under 5MB.',
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
      message: 'Cover updated',
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
      message: 'Profile link copied',
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
      message: 'Profile code copied',
      subtitle: 'Ready to paste into a campus kiosk or chat.',
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
          ? 'Connection request sent'
          : 'Connection request removed',
      subtitle: widget.profile.name,
      icon: _connectionRequested ? LucideIcons.user_check : LucideIcons.user_x,
      accentColor: _connectionRequested
          ? SynorColors.emerald500
          : SynorColors.amber500,
    );
  }

  void _showStatusUpdateHint() {
    showSynorToast(
      context,
      message: 'Status updated',
      subtitle: 'Your active study signal stays visible on the profile card.',
      icon: LucideIcons.sparkles,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    const SizedBox(height: 28),
                    _buildStatusSection(context),
                    const SizedBox(height: 20),
                    _buildStatsSection(context),
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
                            message: 'Cover updated',
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: SynorColors.white10),
                            boxShadow: SynorShadows.soft,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.award,
                                size: 14,
                                color: SynorColors.amber400,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Top 5% Student',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
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
        const SizedBox(height: 6),
        Text(
          '${widget.profile.username} • ${widget.profile.university}',
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
            _ProfileTag(
              icon: LucideIcons.brain,
              label: widget.profile.program,
              color: SynorColors.indigo500,
            ),
            _ProfileTag(
              icon: LucideIcons.graduation_cap,
              label: widget.profile.yearLabel,
            ),
            _ProfileTag(
              icon: LucideIcons.users,
              label: widget.profile.groupLabel,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Stack(
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
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                widget.profile.bio,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: synorSecondaryText(context),
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
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: _connectionRequested ? 'Connected' : 'Connect',
            icon: LucideIcons.user_plus,
            filled: true,
            onTap: _toggleConnection,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            label: 'Message',
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

  Widget _buildStatusSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Current Status',
              style: TextStyle(
                color: synorPrimaryText(context),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            PressableScale(
              onTap: _showStatusUpdateHint,
              child: Text(
                'Update',
                style: TextStyle(
                  color: synorIsDark(context)
                      ? SynorColors.indigo400
                      : SynorColors.indigo600,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: synorIsDark(context)
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      SynorColors.indigo500.withValues(alpha: 0.14),
                      SynorColors.purple500.withValues(alpha: 0.1),
                    ],
                  )
                : SynorGradients.profileSignal,
            borderRadius: BorderRadius.circular(SynorRadii.card),
            border: Border.all(
              color: synorIsDark(context)
                  ? SynorColors.indigo500.withValues(alpha: 0.18)
                  : SynorColors.indigo100,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: synorIsDark(context)
                      ? SynorColors.white10
                      : Colors.white,
                ),
                child: Icon(
                  LucideIcons.book_open,
                  color: synorIsDark(context)
                      ? SynorColors.indigo400
                      : SynorColors.indigo600,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: SynorColors.emerald500,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'IN LECTURE',
                          style: TextStyle(
                            color: synorIsDark(context)
                                ? SynorColors.indigo300
                                : SynorColors.indigo700,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Databases',
                      style: TextStyle(
                        color: synorPrimaryText(context),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Room B-204',
                      style: TextStyle(color: synorSecondaryText(context)),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '27m',
                    style: TextStyle(
                      color: synorIsDark(context)
                          ? SynorColors.indigo400
                          : SynorColors.indigo600,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'LEFT',
                    style: TextStyle(
                      color: synorIsDark(context)
                          ? SynorColors.indigo500
                          : SynorColors.indigo400,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SynorHorizontalViewportBleed(
          height: 44,
          child: SizedBox(
            height: 44,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: SynorSpacing.xxl),
              scrollDirection: Axis.horizontal,
              children: const [
                _SignalChip(icon: LucideIcons.coffee, label: 'Coffee break'),
                SizedBox(width: 8),
                _SignalChip(
                  icon: LucideIcons.users,
                  label: 'Looking for study group',
                  active: true,
                ),
                SizedBox(width: 8),
                _SignalChip(
                  icon: LucideIcons.file_text,
                  label: 'Sharing notes',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatCard(
            icon: LucideIcons.award,
            iconColor: SynorColors.emerald500,
            title: '3.8',
            subtitle: 'Current GPA',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: LucideIcons.circle_check_big,
            iconColor: SynorColors.blue500,
            title: '92%',
            subtitle: 'Attendance',
          ),
        ),
      ],
    );
  }

  Widget _buildActivitySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _SectionHeader(title: 'Recent Activity', actionLabel: 'View All'),
        SizedBox(height: 14),
        _ActivityCard(
          icon: LucideIcons.file_text,
          color: SynorColors.indigo500,
          title: 'Shared Notes: Databases',
          subtitle:
              'Compiled all the SQL queries and normalization rules we covered.',
          meta: '2h ago',
          showReactions: true,
        ),
        SizedBox(height: 12),
        _ActivityCard(
          icon: LucideIcons.users,
          color: SynorColors.purple500,
          title: 'Joined Study Group',
          subtitle: 'Advanced Algorithms Prep Group',
          meta: 'Yesterday',
        ),
      ],
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _SectionHeader(title: 'Student Services'),
        SizedBox(height: 12),
        _RowGroup(
          children: [
            _ProfileRow(
              icon: LucideIcons.file_badge,
              iconColor: SynorColors.indigo500,
              title: 'Certificates & Documents',
              subtitle: 'Transcripts, study certificates',
            ),
            _ProfileRow(
              icon: LucideIcons.credit_card,
              iconColor: SynorColors.emerald500,
              title: 'Finance & Payments',
              subtitle: 'Tuition, dormitory fees',
            ),
            _ProfileRow(
              icon: LucideIcons.building,
              iconColor: SynorColors.rose500,
              title: 'Housing & Dormitory',
              subtitle: 'Requests, rules, status',
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
        const _SectionHeader(title: 'Settings'),
        const SizedBox(height: 12),
        _RowGroup(
          children: [
            const _ProfileRow(
              icon: LucideIcons.shield,
              title: 'Privacy & Security',
            ),
            _ProfileToggleRow(
              icon: widget.isDarkMode ? LucideIcons.moon : LucideIcons.sun,
              title: 'Dark Mode',
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
              'Log Out',
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

class _SignalChip extends StatelessWidget {
  const _SignalChip({
    required this.icon,
    required this.label,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final isDark = synorIsDark(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: active
            ? (isDark ? Colors.white : SynorColors.slate900)
            : (isDark ? SynorColors.white5 : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active
              ? Colors.transparent
              : (isDark ? SynorColors.white10 : SynorColors.slate200),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: active
                ? (isDark ? Colors.black : Colors.white)
                : synorSecondaryText(context),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: active
                  ? (isDark ? Colors.black : Colors.white)
                  : synorSecondaryText(context),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SynorGlassPanel(
      radius: SynorRadii.card,
      padding: const EdgeInsets.all(16),
      backgroundColor: synorIsDark(context) ? SynorColors.white5 : Colors.white,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withValues(
                alpha: synorIsDark(context) ? 0.12 : 0.08,
              ),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: synorPrimaryText(context),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: synorSecondaryText(context),
                    fontSize: 12,
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
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
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

class _SettingsOverlay extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                  'Settings',
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
                            Text(
                              profile.program,
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
                const _SettingsCaption(label: 'Preferences'),
                const SizedBox(height: 12),
                _RowGroup(
                  children: [
                    _ProfileToggleRow(
                      icon: isDarkMode ? LucideIcons.moon : LucideIcons.sun,
                      title: 'Dark Mode',
                      value: isDarkMode,
                      onTap: onToggleTheme,
                    ),
                    const _ProfileRow(
                      icon: LucideIcons.globe,
                      iconColor: SynorColors.emerald500,
                      title: 'Language',
                      subtitle: 'English',
                    ),
                    const _ProfileRow(
                      icon: LucideIcons.bell,
                      iconColor: SynorColors.rose500,
                      title: 'Notifications',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const _SettingsCaption(label: 'Security'),
                const SizedBox(height: 12),
                const _RowGroup(
                  children: [
                    _ProfileRow(
                      icon: LucideIcons.shield,
                      iconColor: SynorColors.amber500,
                      title: 'Password & Security',
                    ),
                    _ProfileRow(
                      icon: LucideIcons.lock,
                      iconColor: SynorColors.blue500,
                      title: 'Privacy Settings',
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
                          'Log Out',
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

class _CoverPickerOverlay extends StatelessWidget {
  const _CoverPickerOverlay({
    required this.selectedCover,
    required this.hasCustomCover,
    required this.onClose,
    required this.onUpload,
    required this.onSelect,
  });

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
                            'Edit Cover',
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
                        'Choose from templates',
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
                        itemCount: SynorMockData.coverTemplates.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 4 / 3,
                            ),
                        itemBuilder: (context, index) {
                          final template = SynorMockData.coverTemplates[index];
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
                isSelected ? 'Using uploaded cover' : 'Upload from device',
                style: TextStyle(
                  color: synorPrimaryText(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isSelected
                    ? 'Tap to replace with another image'
                    : 'JPG, PNG or GIF (max. 5MB)',
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
