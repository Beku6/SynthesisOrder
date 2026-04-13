import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/auth_flow.dart';
import '../features/shell/presentation/shell_screen.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_localization_x.dart';
import '../l10n/l10n.dart';
import '../shared/models/app_models.dart';
import '../shared/widgets/synor_widgets.dart';
import 'application/app_session_controller.dart';
import 'router/app_route_controller.dart';
import 'theme/synor_design_tokens.dart';
import 'theme/synor_theme.dart';

class SynorApp extends ConsumerWidget {
  const SynorApp({super.key, this.bootstrapError, this.bootstrapStackTrace});

  final Object? bootstrapError;
  final StackTrace? bootstrapStackTrace;

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
        onSignOut: () {
          router.signOut();
        },
      ),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (bootstrapError != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => context.l10n.app_name,
        theme: SynorTheme.light(),
        darkTheme: SynorTheme.dark(),
        supportedLocales: synorSupportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: SynorViewport(
          child: _SynorBootstrapErrorScreen(
            error: bootstrapError!,
            stackTrace: bootstrapStackTrace,
          ),
        ),
      );
    }

    final session = ref.watch(appSessionControllerProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => context.l10n.app_name,
      theme: SynorTheme.light(),
      darkTheme: SynorTheme.dark(),
      themeMode: session.themeMode,
      locale: session.locale,
      supportedLocales: synorSupportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeAnimationDuration: SynorMotion.theme,
      themeAnimationCurve: SynorMotion.themeCurve,
      home: SynorViewport(
        child: AnimatedSwitcher(
          duration: SynorMotion.page,
          reverseDuration: SynorMotion.page,
          layoutBuilder: synorStackedLayoutBuilder(fit: StackFit.expand),
          transitionBuilder: (child, animation) {
            final keyString = (child.key as ValueKey<String>).value;
            final stage = AuthStage.values.firstWhere(
              (s) => keyString.startsWith(s.name),
              orElse: () => AuthStage.main,
            );

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
          child: KeyedSubtree(
            key: ValueKey('${session.stage.name}-${session.locale.languageCode}'),
            child: _buildStage(ref, session),
          ),
        ),
      ),
    );
  }
}

class _SynorBootstrapErrorScreen extends StatelessWidget {
  const _SynorBootstrapErrorScreen({required this.error, this.stackTrace});

  final Object error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localizedMessage = l10n.appErrorLabel(error.toString());

    return ColoredBox(
      color: const Color(0xFFFAFAFA),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
          child: Column(
            children: [
              const Spacer(flex: 5),
              const SynorBrandLogo(size: 132, radius: 18),
              const SizedBox(height: 28),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: SynorInlineStateCard(
                  icon: Icons.sync_problem_rounded,
                  title: l10n.async_errorTitle,
                  message: localizedMessage,
                  accentColor: SynorColors.rose600,
                ),
              ),
              const Spacer(flex: 6),
              const BekooWordmark(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
