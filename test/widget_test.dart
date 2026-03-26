import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:synor/app/synor_app.dart';
import 'package:synor/features/auth/presentation/auth_flow.dart';
import 'package:synor/core/persistence/shared_preferences_provider.dart';
import 'package:synor/shared/widgets/synor_widgets.dart';

void main() {
  testWidgets('Synor startup renders onboarding without an extra app splash', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
        child: const SynorApp(),
      ),
    );

    expect(find.byType(SynorBrandedSplashScreen), findsNothing);
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
