import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:synor/app/application/app_session_controller.dart';
import 'package:synor/app/synor_app.dart';
import 'package:synor/core/persistence/shared_preferences_provider.dart';

const synorViewportSize = Size(430, 932);
const synorCompactViewportSize = Size(430, 640);
const synorWidePhoneViewportSize = Size(480, 932);

Future<ProviderContainer> pumpSynorApp(
  WidgetTester tester, {
  Size surfaceSize = synorViewportSize,
  Map<String, Object> preferences = const {},
}) async {
  tester.view.physicalSize = surfaceSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  SharedPreferences.setMockInitialValues(preferences);
  final sharedPreferences = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const SynorApp(),
    ),
  );
  await tester.pump();
  return synorContainer(tester);
}

ProviderContainer synorContainer(WidgetTester tester) {
  return ProviderScope.containerOf(tester.element(find.byType(SynorApp)));
}

Future<ProviderContainer> pumpSignInSynorApp(
  WidgetTester tester, {
  Size surfaceSize = synorViewportSize,
}) async {
  final container = await pumpSynorApp(
    tester,
    surfaceSize: surfaceSize,
    preferences: const {'app.onboarding_completed': true},
  );
  await settleSynorTransitions(tester, duration: const Duration(seconds: 2));
  return container;
}

Future<ProviderContainer> pumpSignedInSynorApp(
  WidgetTester tester, {
  Size surfaceSize = synorViewportSize,
}) async {
  final container = await pumpSignInSynorApp(tester, surfaceSize: surfaceSize);
  container.read(appSessionControllerProvider.notifier).signIn();
  await settleSynorTransitions(tester, duration: const Duration(seconds: 1));
  return container;
}

Future<void> settleSynorTransitions(
  WidgetTester tester, {
  Duration duration = const Duration(milliseconds: 400),
}) async {
  await tester.pump();
  await tester.pump(duration);
}
