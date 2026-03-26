import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:synor/app/application/app_session_controller.dart';
import 'package:synor/app/router/app_route_controller.dart';
import 'package:synor/app/synor_app.dart';
import 'package:synor/features/auth/presentation/auth_flow.dart';
import 'package:synor/features/shell/application/shell_navigation_controller.dart';
import 'package:synor/shared/models/app_models.dart';
import 'package:synor/shared/widgets/synor_widgets.dart';

import 'test_helpers/synor_app_tester.dart';

void main() {
  Finder textFieldWithHint(String hintText) {
    return find.byWidgetPredicate(
      (widget) =>
          widget is TextField && widget.decoration?.hintText == hintText,
    );
  }

  testWidgets(
    'startup opens directly into onboarding without an extra app splash',
    (tester) async {
      await pumpSynorApp(tester);

      expect(find.byType(SynorBrandedSplashScreen), findsNothing);
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.byType(SignInScreen), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('mobile viewport host does not render side border seams', (
    tester,
  ) async {
    await pumpSynorApp(tester);

    final host = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey('synor-viewport-host')),
    );
    final decoration = host.decoration! as BoxDecoration;

    expect(decoration.border, isNull);
    expect(decoration.boxShadow, isNull);
  });

  testWidgets(
    'wide phone layouts use the real device width instead of a 430px shell',
    (tester) async {
      final container = await pumpSignedInSynorApp(
        tester,
        surfaceSize: synorWidePhoneViewportSize,
      );

      final hostBox = tester.renderObject<RenderBox>(
        find.byKey(const ValueKey('synor-viewport-host')),
      );
      expect(hostBox.size.width, synorWidePhoneViewportSize.width);

      expect(
        tester.getSize(find.byType(SynorSearchField)).width,
        greaterThan(300),
      );

      container.read(appRouteControllerProvider).goToTab(ShellTab.schedule);
      await settleSynorTransitions(tester);

      final scheduleModeControl = find.byWidgetPredicate(
        (widget) => widget is SynorSegmentedControl<ScheduleMode>,
      );
      expect(tester.getSize(scheduleModeControl).width, greaterThan(400));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'sign-in fields render and accept input without Material ancestry failures',
    (tester) async {
      await pumpSignInSynorApp(tester);

      expect(find.byType(SignInScreen), findsOneWidget);

      await tester.enterText(
        find.byType(TextFormField).first,
        'student@synor.app',
      );
      await tester.enterText(find.byType(TextFormField).last, 'secret123');
      await tester.pump();

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('sign-in expands to the full wide-phone content width', (
    tester,
  ) async {
    await pumpSignInSynorApp(tester, surfaceSize: synorWidePhoneViewportSize);

    expect(
      tester.getSize(find.byType(TextFormField).first).width,
      greaterThan(400),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('auth screens stay overflow-safe on a compact viewport', (
    tester,
  ) async {
    final container = await pumpSignInSynorApp(
      tester,
      surfaceSize: synorCompactViewportSize,
    );

    expect(find.byType(SignInScreen), findsOneWidget);
    expect(tester.takeException(), isNull);

    container.read(appRouteControllerProvider).openSignUp();
    await settleSynorTransitions(tester);

    expect(find.byType(SignUpScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'home search and services inputs render without runtime framework errors',
    (tester) async {
      final container = await pumpSignedInSynorApp(tester);

      expect(find.byType(SynorApp), findsOneWidget);
      expect(textFieldWithHint('Search...'), findsOneWidget);

      await tester.enterText(textFieldWithHint('Search...'), 'Computer');
      await tester.pump();
      expect(tester.takeException(), isNull);

      container
          .read(appRouteControllerProvider)
          .goToServiceView(ServiceView.housing);
      await settleSynorTransitions(tester);

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Electrical').last);
      await settleSynorTransitions(tester);
      await tester.enterText(
        textFieldWithHint('Describe the issue...'),
        'Broken light fixture near the desk.',
      );
      await tester.pump();
      expect(tester.takeException(), isNull);

      container
          .read(appRouteControllerProvider)
          .goToServiceView(ServiceView.support);
      await settleSynorTransitions(tester);

      await tester.enterText(
        textFieldWithHint('Brief summary...'),
        'Need account access help',
      );
      await tester.enterText(
        textFieldWithHint('How can we help you?'),
        'Please restore access to the student portal.',
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'signed-in shell shows a professional skeleton before data loads',
    (tester) async {
      final container = await pumpSignInSynorApp(tester);

      container.read(appSessionControllerProvider.notifier).signIn();
      await tester.pump();

      expect(
        find.byKey(const ValueKey('synor-shell-skeleton')),
        findsOneWidget,
      );

      await settleSynorTransitions(
        tester,
        duration: const Duration(seconds: 1),
      );

      expect(find.byKey(const ValueKey('synor-shell-skeleton')), findsNothing);
      expect(find.byType(SynorSearchField), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('services screen uses skeleton loading instead of plain text', (
    tester,
  ) async {
    final container = await pumpSignedInSynorApp(tester);

    container.read(appRouteControllerProvider).goToTab(ShellTab.services);
    await tester.pump();

    expect(
      find.byKey(const ValueKey('synor-services-skeleton')),
      findsOneWidget,
    );

    await settleSynorTransitions(tester, duration: const Duration(seconds: 1));

    expect(find.byKey(const ValueKey('synor-services-skeleton')), findsNothing);
    expect(find.text('Services'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('toast feedback renders as a top-floating replacement banner', (
    tester,
  ) async {
    await pumpSignedInSynorApp(tester);

    final context = tester.element(find.byType(SynorSearchField));
    showSynorToast(
      context,
      message: 'First message',
      subtitle: 'Initial banner',
      icon: Icons.check_circle_outline,
      duration: const Duration(seconds: 3),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final banner = find.byKey(const ValueKey('synor-toast-banner'));
    expect(banner, findsOneWidget);
    expect(tester.getTopLeft(banner).dy, lessThan(100));
    expect(find.byType(SynorBottomNavBar), findsOneWidget);

    showSynorToast(
      context,
      message: 'Second message',
      subtitle: 'Replacement banner',
      icon: Icons.notifications_outlined,
      duration: const Duration(seconds: 3),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('First message'), findsNothing);
    expect(find.text('Second message'), findsOneWidget);
    expect(find.byKey(const ValueKey('synor-toast-banner')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('quick alert and profile settings overlays render cleanly', (
    tester,
  ) async {
    final container = await pumpSignedInSynorApp(tester);

    container.read(shellNavigationControllerProvider.notifier).openAlert(1);
    await settleSynorTransitions(tester);

    expect(find.text('Quick Alert'), findsOneWidget);
    expect(tester.takeException(), isNull);

    container.read(appRouteControllerProvider).goToTab(ShellTab.profile);
    await settleSynorTransitions(tester);
    container.read(appRouteControllerProvider).goToProfileSettings();
    await settleSynorTransitions(tester);

    expect(find.text('Settings'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
