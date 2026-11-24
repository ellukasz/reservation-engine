import 'package:material_ui/material_ui.dart';

import 'l10n/app_localizations.dart';
import 'pricing/model/in_memory_pricing_repository.dart';
import 'pricing/model/pricing_repository.dart';
import 'pricing/pricing_controller.dart';
import 'pricing/pricing_screen.dart';
import 'theme/app_theme.dart';

/// Strona cennika z własnym kontrolerem i repozytorium.
class PricingPage extends StatefulWidget {
  const PricingPage({this.repository, super.key});

  final PricingRepository? repository;

  @override
  State<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> {
  late final PricingController _controller = PricingController(
    widget.repository ?? InMemoryPricingRepository(),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PricingScreen(controller: _controller);
  }
}

/// Główny widget aplikacji cennika.
class PricingApp extends StatelessWidget {
  const PricingApp({this.repository, super.key});

  final PricingRepository? repository;

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
      home: PricingPage(repository: repository),
    );
  }
}
