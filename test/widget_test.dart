import 'package:flutter_test/flutter_test.dart';

import 'package:synor/features/auth/presentation/auth_flow.dart';
import 'package:synor/shared/widgets/synor_widgets.dart';

import 'test_helpers/synor_app_tester.dart';

void main() {
  testWidgets('Synor startup renders onboarding without an extra app splash', (
    tester,
  ) async {
    await pumpSynorApp(tester);

    expect(find.byType(SynorBrandedSplashScreen), findsNothing);
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
