import 'package:material_ui/material_ui.dart';

import 'app_localizations.dart';

/// Zwraca teksty z lokalizacji aplikacji.
///
/// Gdy widget jest używany bez [AppLocalizations.delegate] (np. w izolowanym
/// teście widgetu), wybiera wersję językową na podstawie locale'u platformy.
/// Dzięki temu tooltipy i podpowiedzi nie są stringami wpisanymi na sztywno
/// w kodzie UI.
AppLocalizations resolveAppLocalizations(BuildContext context) {
  final fromDelegate = Localizations.of<AppLocalizations>(
    context,
    AppLocalizations,
  );
  if (fromDelegate != null) {
    return fromDelegate;
  }

  final locale = WidgetsBinding.instance.platformDispatcher.locale;
  for (final supported in AppLocalizations.supportedLocales) {
    if (supported.languageCode == locale.languageCode) {
      return lookupAppLocalizations(supported);
    }
  }
  return lookupAppLocalizations(const Locale('en'));
}

/// Zwraca locale używany do formatowania dat i kwot.
///
/// W izolowanym teście widgetu nie ma delegata [AppLocalizations], więc
/// formatowanie korzysta z locale'u platformy — tak samo jak teksty
/// zwracane przez [resolveAppLocalizations].
Locale resolveLocale(BuildContext context) {
  final fromDelegate = Localizations.of<AppLocalizations>(
    context,
    AppLocalizations,
  );
  if (fromDelegate != null) {
    return Localizations.localeOf(context);
  }
  return WidgetsBinding.instance.platformDispatcher.locale;
}
