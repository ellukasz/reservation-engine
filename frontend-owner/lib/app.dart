import 'package:material_ui/material_ui.dart';

import 'l10n/app_localizations.dart';
import 'theme/app_theme.dart';

/// Placeholder ekranu cennika (Task 1).
/// Pełna implementacja z kontrolerem i repozytorium pojawi się w Tasku 8.
class PricingPage extends StatelessWidget {
  const PricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).pricingTitle),
      ),
      body: const Center(),
    );
  }
}

/// Główny widget aplikacji cennika.
class PricingApp extends StatelessWidget {
  const PricingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const PricingPage(),
    );
  }
}
