import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

extension SynorL10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

const synorSupportedLocales = <Locale>[
  Locale('en'),
  Locale('ru'),
  Locale('kk'),
];

Locale synorLocaleFromCode(String? code) {
  final normalized = (code ?? '').trim().toLowerCase();
  return switch (normalized) {
    'ru' => const Locale('ru'),
    'kk' || 'kz' => const Locale('kk'),
    _ => const Locale('en'),
  };
}
