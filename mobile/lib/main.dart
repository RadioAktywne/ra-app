import 'package:flutter/material.dart';
import 'package:radioaktywne/components/color_shadowed_card.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/l10n/localizations.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final temporaryTextStyle = TextStyle(color: context.colors.highlightGreen, fontWeight: FontWeight.bold);

    return MaterialApp(
      theme: context.theme,
      locale: const Locale('pl'),
      supportedLocales: context.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateTitle: (context) => context.l10n.hello,
      home: Scaffold(
        backgroundColor: context.colors.backgroundLight,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ColorShadowedCard(
                    shadowColor: context.colors.highlightYellow,
                    header: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('Ramówka na dziś', style: temporaryTextStyle.merge(const TextStyle(fontSize: 16))),
                      ),
                    ),
                    footer: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Lorem ipsum',
                        style: temporaryTextStyle,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ColorShadowedCard(
                            shadowColor: context.colors.highlightPurple,
                            header: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text('Nagłówek', style: temporaryTextStyle.merge(const TextStyle(fontSize: 12))),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'Lorem ipsum',
                                style: temporaryTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ColorShadowedCard(
                            shadowColor: context.colors.highlightBlue,
                            footer: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text('Stopka', style: temporaryTextStyle.merge(const TextStyle(fontSize: 12))),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'Lorem ipsum',
                                style: temporaryTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ColorShadowedCard(
                    shadowColor: context.colors.highlightRed,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'hello world',
                        style: temporaryTextStyle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
