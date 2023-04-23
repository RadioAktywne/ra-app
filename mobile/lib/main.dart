import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/l10n/localizations.dart';
import 'components/colorShadowedWidget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: context.theme,
      locale: const Locale('pl'),
      supportedLocales: context.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateTitle: (context) => context.l10n.hello,
      home: Scaffold(
        body: Center(
          child: ColoredBox(
            color: context.colors.primary,
            child: ColorShadowedWidget(
              shadowColor: Colors.green,
              child: Container(
                color: Colors.amber,
                padding: const EdgeInsets.all(20),
                child: const Text('hello world'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
