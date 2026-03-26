import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/synor_design_tokens.dart';
import '../application/auth_controller.dart';
import '../domain/auth_models.dart';
import '../../../shared/widgets/synor_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  static const _slides = [
    (
      'Your academic life, finally organized.',
      'Synor keeps your schedule, tasks, reminders, and study flow in one place.',
      LucideIcons.calendar,
      SynorColors.indigo400,
    ),
    (
      'Schedule, study, and routine — in one flow.',
      'Everything you need to succeed, seamlessly integrated.',
      LucideIcons.circle_check,
      SynorColors.violet400,
    ),
    (
      'Less chaos. More control.',
      'Focus on what matters. We\'ll handle the rest.',
      LucideIcons.bell,
      SynorColors.blue400,
    ),
  ];

  late final AnimationController _floatController;
  int _step = 0;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < _slides.length - 1) {
      setState(() {
        _step += 1;
      });
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_step];
    return SynorAuthBackground(
      showBottomGlow: true,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 24,
              right: 24,
              child: PressableScale(
                onTap: widget.onComplete,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: SynorColors.neutral400,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _floatController,
              builder: (context, _) {
                final topShift = (_floatController.value - 0.5) * 20;
                final bottomShift = (0.5 - _floatController.value) * 24;
                return Stack(
                  children: [
                    Positioned(
                      top: 120 + topShift,
                      left: 16,
                      child: Opacity(
                        opacity: _step == 0 ? 1 : 0.5,
                        child: Transform.rotate(
                          angle: (_floatController.value - 0.5) * 0.07,
                          child: Transform.scale(
                            scale: _step == 0 ? 1 : 0.9,
                            child: _FloatingCard(
                              width: 128,
                              height: 96,
                              child: Container(
                                width: 64,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: SynorColors.white10,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 180 + bottomShift,
                      child: Opacity(
                        opacity: _step == 1 ? 1 : 0.5,
                        child: Transform.rotate(
                          angle: (0.5 - _floatController.value) * 0.1,
                          child: Transform.scale(
                            scale: _step == 1 ? 1 : 0.9,
                            child: _FloatingCard(
                              width: 160,
                              height: 112,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: SynorColors.white10,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: 80,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: SynorColors.white10,
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned.fill(
              child: SynorFillScrollView(
                padding: const EdgeInsets.fromLTRB(32, 96, 32, 36),
                child: Column(
                  children: [
                    const Spacer(),
                    AnimatedSwitcher(
                      duration: SynorMotion.medium,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(
                              begin: 0.95,
                              end: 1,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        key: ValueKey(_step),
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: SynorColors.white5,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: SynorColors.white10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0DFFFFFF),
                                  blurRadius: 30,
                                ),
                              ],
                            ),
                            child: Icon(slide.$3, color: slide.$4, size: 32),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            slide.$1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.8,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            slide.$2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: SynorColors.neutral400,
                              fontSize: 18,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (index) => AnimatedContainer(
                          duration: SynorMotion.medium,
                          width: index == _step ? 32 : 8,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: index == _step
                                ? SynorColors.indigo500
                                : SynorColors.white20,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SynorPrimaryButton(
                      label: _step == _slides.length - 1
                          ? 'Get Started'
                          : 'Continue',
                      icon: LucideIcons.arrow_right,
                      onTap: _next,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key, required this.onSignUp});

  final VoidCallback onSignUp;

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text == value) {
      return;
    }
    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }

  Future<void> _submit() async {
    final success = await ref.read(signInControllerProvider.notifier).submit();
    if (!mounted || success) {
      return;
    }
    final state = ref.read(signInControllerProvider);
    if (state.emailError != null) {
      _emailFocus.requestFocus();
      return;
    }
    if (state.passwordError != null) {
      _passwordFocus.requestFocus();
    }
  }

  Future<void> _submitGoogle() async {
    await ref.read(signInControllerProvider.notifier).submitWithGoogle();
  }

  Future<void> _handleForgotPassword() async {
    final email = await ref
        .read(signInControllerProvider.notifier)
        .sendRecoveryLink();
    if (!mounted) {
      return;
    }
    if (email == null) {
      _emailFocus.requestFocus();
      return;
    }
    showSynorToast(
      context,
      message: 'Recovery link sent',
      subtitle: email,
      icon: LucideIcons.mail_check,
      accentColor: SynorColors.indigo500,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInControllerProvider);
    _syncController(_emailController, state.draft.email);
    _syncController(_passwordController, state.draft.password);

    return SynorAuthBackground(
      child: SafeArea(
        child: SynorFillScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            children: [
              const Spacer(),
              SynorResponsiveContentLimit(
                maxWidth: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SynorBrandLogo(size: 64),
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to access your schedule, study hub, and smart routine.',
                      style: TextStyle(
                        color: SynorColors.neutral400,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _AuthField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      icon: LucideIcons.mail,
                      hintText: 'Student ID / Email',
                      errorText: state.emailError,
                      textInputAction: TextInputAction.next,
                      onChanged: ref
                          .read(signInControllerProvider.notifier)
                          .updateEmail,
                      onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                    ),
                    const SizedBox(height: 16),
                    _AuthField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      icon: LucideIcons.lock,
                      hintText: 'Password',
                      obscureText: true,
                      errorText: state.passwordError,
                      textInputAction: TextInputAction.done,
                      onChanged: ref
                          .read(signInControllerProvider.notifier)
                          .updatePassword,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: PressableScale(
                        onTap: _handleForgotPassword,
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: SynorColors.indigo400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SynorPrimaryButton(
                      label: state.isSubmitting ? 'Signing In...' : 'Sign In',
                      onTap: state.isSubmitting ? () {} : _submit,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Expanded(child: Divider(color: SynorColors.white10)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: TextStyle(
                              color: SynorColors.neutral500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: SynorColors.white10)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    PressableScale(
                      onTap: _submitGoogle,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: SynorColors.white5,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: SynorColors.white10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const _GoogleGlyph(),
                            const SizedBox(width: 12),
                            Text(
                              state.isGoogleSubmitting
                                  ? 'Connecting...'
                                  : 'Continue with Google',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'New here? ',
                    style: TextStyle(
                      color: SynorColors.neutral400,
                      fontSize: 16,
                    ),
                  ),
                  PressableScale(
                    onTap: widget.onSignUp,
                    child: const Text(
                      'Create account',
                      style: TextStyle(
                        color: SynorColors.indigo400,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.icon,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
    this.errorText,
  });

  final IconData icon;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        textInputAction: textInputAction,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: SynorColors.neutral500, size: 20),
          prefixIconConstraints: const BoxConstraints(minWidth: 48),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: SynorColors.neutral500,
            fontSize: 16,
          ),
          errorText: errorText,
          errorStyle: const TextStyle(
            color: SynorColors.rose300,
            fontSize: 12,
            height: 1.25,
          ),
          fillColor: SynorColors.white5,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: SynorColors.white10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: SynorColors.indigo500),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: SynorColors.rose400),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: SynorColors.rose400),
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
  final TextEditingController _courseYearController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _universityController.dispose();
    _facultyController.dispose();
    _courseYearController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text == value) {
      return;
    }
    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }

  Future<void> _next() async {
    await ref.read(signUpControllerProvider.notifier).completeCurrentStep();
  }

  void _prev(int step) {
    if (step > 1) {
      ref.read(signUpControllerProvider.notifier).previousStep();
    } else {
      widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpControllerProvider);
    final controller = ref.read(signUpControllerProvider.notifier);

    _syncController(_fullNameController, state.draft.fullName);
    _syncController(_emailController, state.draft.email);
    _syncController(_passwordController, state.draft.password);
    _syncController(_universityController, state.draft.university);
    _syncController(_facultyController, state.draft.faculty);
    _syncController(_courseYearController, state.draft.courseYear);
    _syncController(_groupController, state.draft.group);

    return SynorAuthBackground(
      child: SafeArea(
        child: SynorFillScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              Row(
                children: [
                  PressableScale(
                    onTap: () => _prev(state.draft.step),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0),
                      ),
                      child: const Icon(
                        LucideIcons.arrow_left,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (index) => AnimatedContainer(
                            duration: SynorMotion.medium,
                            width: index < state.draft.step ? 32 : 16,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: index < state.draft.step
                                  ? SynorColors.indigo500
                                  : SynorColors.white20,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SynorResponsiveContentLimit(
                  maxWidth: 400,
                  child: AnimatedSwitcher(
                    duration: SynorMotion.page,
                    reverseDuration: SynorMotion.page,
                    layoutBuilder: synorStackedLayoutBuilder(
                      alignment: Alignment.topCenter,
                    ),
                    transitionBuilder: synorFadeSlideTransitionBuilder(
                      begin: const Offset(0.028, 0),
                    ),
                    child: _SignUpStepContent(
                      draft: state.draft,
                      fullNameController: _fullNameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      universityController: _universityController,
                      facultyController: _facultyController,
                      courseYearController: _courseYearController,
                      groupController: _groupController,
                      onFullNameChanged: controller.updateFullName,
                      onEmailChanged: controller.updateEmail,
                      onPasswordChanged: controller.updatePassword,
                      onUniversityChanged: controller.updateUniversity,
                      onFacultyChanged: controller.updateFaculty,
                      onCourseYearChanged: controller.updateCourseYear,
                      onGroupChanged: controller.updateGroup,
                      onCycleCampus: controller.cycleCampus,
                      onToggleStudyMode: controller.toggleStudyMode,
                      onToggleSmartNotifications:
                          controller.toggleSmartNotifications,
                      onToggleCalendarSync: controller.toggleCalendarSync,
                      key: ValueKey(state.draft.step),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SynorResponsiveContentLimit(
                maxWidth: 400,
                child: SynorPrimaryButton(
                  label: state.isSubmitting
                      ? 'Completing...'
                      : state.draft.step == 4
                      ? 'Complete Setup'
                      : 'Continue',
                  icon: LucideIcons.arrow_right,
                  onTap: _next,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignUpStepContent extends StatelessWidget {
  const _SignUpStepContent({
    super.key,
    required this.draft,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.universityController,
    required this.facultyController,
    required this.courseYearController,
    required this.groupController,
    required this.onFullNameChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onUniversityChanged,
    required this.onFacultyChanged,
    required this.onCourseYearChanged,
    required this.onGroupChanged,
    required this.onCycleCampus,
    required this.onToggleStudyMode,
    required this.onToggleSmartNotifications,
    required this.onToggleCalendarSync,
  });

  final SignUpDraft draft;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController universityController;
  final TextEditingController facultyController;
  final TextEditingController courseYearController;
  final TextEditingController groupController;
  final ValueChanged<String> onFullNameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onUniversityChanged;
  final ValueChanged<String> onFacultyChanged;
  final ValueChanged<String> onCourseYearChanged;
  final ValueChanged<String> onGroupChanged;
  final VoidCallback onCycleCampus;
  final VoidCallback onToggleStudyMode;
  final VoidCallback onToggleSmartNotifications;
  final VoidCallback onToggleCalendarSync;

  @override
  Widget build(BuildContext context) {
    return switch (draft.step) {
      1 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepHeader(
            title: 'Create your account',
            subtitle: 'Let\'s start with your basic identity.',
          ),
          _AuthField(
            controller: fullNameController,
            onChanged: onFullNameChanged,
            icon: LucideIcons.user,
            hintText: 'Full Name',
          ),
          const SizedBox(height: 16),
          _AuthField(
            controller: emailController,
            onChanged: onEmailChanged,
            icon: LucideIcons.mail,
            hintText: 'Email Address',
          ),
          const SizedBox(height: 16),
          _AuthField(
            icon: LucideIcons.lock,
            hintText: 'Create Password',
            obscureText: true,
            controller: passwordController,
            onChanged: onPasswordChanged,
          ),
        ],
      ),
      2 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepHeader(
            title: 'Academic setup',
            subtitle: 'Tell us where and what you study.',
          ),
          _AuthField(
            icon: LucideIcons.building_2,
            hintText: 'University',
            controller: universityController,
            onChanged: onUniversityChanged,
          ),
          const SizedBox(height: 16),
          _AuthField(
            icon: LucideIcons.graduation_cap,
            hintText: 'Faculty / Department',
            controller: facultyController,
            onChanged: onFacultyChanged,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _CompactAuthField(
                  hintText: 'Course Year',
                  controller: courseYearController,
                  onChanged: onCourseYearChanged,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _CompactAuthField(
                  hintText: 'Group',
                  controller: groupController,
                  onChanged: onGroupChanged,
                ),
              ),
            ],
          ),
        ],
      ),
      3 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepHeader(
            title: 'Personalize your flow',
            subtitle:
                'This helps Synor personalize your schedule, reminders, and study experience.',
          ),
          _PreferenceTile(
            title: 'Campus Preferences',
            subtitle: draft.campusPreference,
            icon: LucideIcons.map_pin,
            onTap: onCycleCampus,
          ),
          const SizedBox(height: 16),
          _PreferenceToggleTile(
            title: 'Study Mode',
            subtitle: draft.deepFocusEnabled ? 'Deep Focus' : 'Flexible',
            value: draft.deepFocusEnabled,
            onTap: onToggleStudyMode,
          ),
        ],
      ),
      _ => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepHeader(
            title: 'Turn on smart features',
            subtitle: 'Enable these to get the full Synor experience.',
          ),
          _FeatureToggleTile(
            title: 'Smart Notifications',
            subtitle: 'Get alerts for classes & tasks',
            icon: LucideIcons.bell,
            color: SynorColors.indigo400,
            value: draft.smartNotificationsEnabled,
            onTap: onToggleSmartNotifications,
          ),
          const SizedBox(height: 16),
          _FeatureToggleTile(
            title: 'Calendar Sync',
            subtitle: 'Connect your personal calendar',
            icon: LucideIcons.calendar_sync,
            color: SynorColors.violet400,
            value: draft.calendarSyncEnabled,
            onTap: onToggleCalendarSync,
          ),
        ],
      ),
    };
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: SynorColors.neutral400,
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactAuthField extends StatelessWidget {
  const _CompactAuthField({
    required this.hintText,
    this.controller,
    this.onChanged,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: SynorColors.neutral500,
            fontSize: 16,
          ),
          fillColor: SynorColors.white5,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: SynorColors.white10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: SynorColors.indigo500),
          ),
        ),
      ),
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  const _PreferenceTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SynorColors.white5,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: SynorColors.white10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: SynorColors.neutral400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(icon, color: SynorColors.indigo400, size: 20),
          ],
        ),
      ),
    );
  }
}

class _PreferenceToggleTile extends StatelessWidget {
  const _PreferenceToggleTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SynorColors.white5,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: SynorColors.white10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: SynorColors.neutral400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _TogglePill(value: value),
          ],
        ),
      ),
    );
  }
}

class _FeatureToggleTile extends StatelessWidget {
  const _FeatureToggleTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.value,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SynorColors.white5,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: SynorColors.white10),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: SynorColors.neutral400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _TogglePill(value: value),
          ],
        ),
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  const _TogglePill({required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: SynorMotion.fast,
      width: 40,
      height: 24,
      decoration: BoxDecoration(
        color: value ? SynorColors.indigo500 : SynorColors.neutral600,
        borderRadius: BorderRadius.circular(999),
      ),
      child: AnimatedAlign(
        duration: SynorMotion.fast,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _GoogleGlyph extends StatelessWidget {
  const _GoogleGlyph();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleGlyphPainter()),
    );
  }
}

class _GoogleGlyphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width / 5.5;
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.width - stroke) / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.1,
      1.1,
      false,
      paint,
    );
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      1.0,
      1.3,
      false,
      paint,
    );
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.3,
      0.9,
      false,
      paint,
    );
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.2,
      1.5,
      false,
      paint,
    );

    final linePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.55, size.height * 0.52),
      Offset(size.width * 0.95, size.height * 0.52),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FloatingCard extends StatelessWidget {
  const _FloatingCard({
    required this.width,
    required this.height,
    required this.child,
  });

  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: SynorColors.white5,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: SynorColors.white10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x4D000000),
                blurRadius: 32,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
