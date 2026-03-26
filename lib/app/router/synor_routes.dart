import '../../shared/models/app_models.dart';

abstract final class SynorRoutes {
  static const onboarding = '/';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';

  static const home = '/home';
  static const schedule = '/schedule';
  static const studies = '/studies';
  static const services = '/services';
  static const profile = '/profile';

  static const messages = '/messages';
  static const alarm = '/alarm';
  static const profileSettings = '/profile/settings';

  static const servicesDocuments = '/services/documents';
  static const servicesPayments = '/services/payments';
  static const servicesHousing = '/services/housing';
  static const servicesSupport = '/services/support';
  static const servicesRequests = '/services/requests';

  static String tabPath(ShellTab tab) {
    return switch (tab) {
      ShellTab.home => home,
      ShellTab.schedule => schedule,
      ShellTab.studies => studies,
      ShellTab.services => services,
      ShellTab.profile => profile,
    };
  }

  static String serviceViewPath(ServiceView view) {
    return switch (view) {
      ServiceView.main => services,
      ServiceView.documents => servicesDocuments,
      ServiceView.payments => servicesPayments,
      ServiceView.housing => servicesHousing,
      ServiceView.support => servicesSupport,
      ServiceView.allRequests => servicesRequests,
    };
  }
}
