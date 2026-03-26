import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/auth_flow.dart';
import '../features/shell/presentation/shell_screen.dart';
import '../shared/models/app_models.dart';
import '../shared/widgets/synor_widgets.dart';
import 'application/app_session_controller.dart';
import 'router/app_route_controller.dart';
import 'theme/synor_design_tokens.dart';
import 'theme/synor_theme.dart';

class SynorApp extends ConsumerWidget {
  const SynorApp({super.key});

  Widget _buildStage(WidgetRef ref, AppSessionState session) {
    final router = ref.read(appRouteControllerProvider);
    return switch (session.stage) {
      AuthStage.onboarding => OnboardingScreen(
        key: const ValueKey(AuthStage.onboarding),
        onComplete: () {
          router.completeOnboarding();
        },
      ),
      AuthStage.signIn => SignInScreen(
        key: const ValueKey(AuthStage.signIn),
        onSignUp: router.openSignUp,
      ),
      AuthStage.signUp => SignUpScreen(
        key: const ValueKey(AuthStage.signUp),
        onBack: router.openSignIn,
      ),
      AuthStage.main => SynorAppShell(
        key: const ValueKey(AuthStage.main),
        isDarkMode: session.themeMode == ThemeMode.dark,
        onToggleTheme: router.toggleTheme,
        onSignOut: router.signOut,
      ),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(appSessionControllerProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Synor',
      theme: SynorTheme.light(),
      darkTheme: SynorTheme.dark(),
      themeMode: session.themeMode,
      themeAnimationDuration: SynorMotion.theme,
      themeAnimationCurve: SynorMotion.themeCurve,
      home: SynorViewport(
        child: AnimatedSwitcher(
          duration: SynorMotion.page,
          reverseDuration: SynorMotion.page,
          layoutBuilder: synorStackedLayoutBuilder(fit: StackFit.expand),
          transitionBuilder: (child, animation) {
            final stage = (child.key as ValueKey<AuthStage>).value;
            if (stage == AuthStage.onboarding) {
              return synorFadeSlideTransitionBuilder(
                begin: const Offset(0, 0.025),
              )(child, animation);
            }
            if (stage == AuthStage.signIn || stage == AuthStage.signUp) {
              return synorFadeSlideTransitionBuilder(
                begin: const Offset(0.024, 0),
              )(child, animation);
            }
            return synorFadeSlideTransitionBuilder(
              begin: const Offset(0, 0.018),
            )(child, animation);
          },
          child: _buildStage(ref, session),
        ),
      ),
    );
  }
}
