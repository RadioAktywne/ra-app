import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/color_shadowed_card.dart';
import 'package:radioaktywne/components/ra_appbar.dart';
import 'package:radioaktywne/components/ra_burger_menu.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/l10n/localizations.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends HookWidget {
  MainApp({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: 'Inner scaffold');

  @override
  Widget build(BuildContext context) {
    final burgerMenuIconController = useAnimationController(
      duration: const Duration(milliseconds: 450),
      reverseDuration: const Duration(milliseconds: 250),
    );
    return MaterialApp(
      theme: context.theme,
      locale: const Locale('pl'),
      supportedLocales: context.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateTitle: (context) => context.l10n.hello,
      home: SafeArea(
        child: Scaffold(
          appBar: RaAppBar(
            height: 75,
            icon: Icon(
              Icons.menu,
              color: context.colors.highlightGreen,
              size: 32,
              semanticLabel: 'RA AppBar menu button',
            ),
            bottomSize: 5,
            mainColor: context.colors.backgroundDark,
            accentColor: context.colors.highlightGreen,
            iconButton: IconButton(
              onPressed: () => _scaffoldKey.currentState!.isEndDrawerOpen
                  ? _scaffoldKey.currentState!.closeEndDrawer()
                  : _scaffoldKey.currentState!.openEndDrawer(),
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: burgerMenuIconController,
                color: context.colors.highlightGreen,
                size: 32,
                semanticLabel: 'RA AppBar menu button',
              ),
            ),
            text: 'Radio\nAktywne',
            iconPath: 'assets/RA_logo.svg',
            titlePadding: const EdgeInsets.only(left: 4, top: 8, bottom: 16),
            imageHeight: 40,
          ),
          body: Scaffold(
            key: _scaffoldKey,
            // Special color to match background color from Figma
            // while not making everything else look so yellow at the same time.
            drawerScrimColor: const Color.fromRGBO(19, 9, 0, 0.354),
            onEndDrawerChanged: (isOpened) => isOpened
                ? burgerMenuIconController.forward()
                : burgerMenuIconController.reverse(),
            endDrawer: RaBurgerMenu(
              titles: const [
                'Radio Aktywne',
                'Nagrania',
                'Płyta tygodnia',
                'Publicystyka',
                'Radiowcy',
                'Ramówka',
                'Audycje',
                'O nas',
              ],
              links: [
                () {},
                () {},
                () {},
                () {},
                () {},
                () {},
                () {},
                () {},
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ColorShadowedCard(
                      shadowColor: context.colors.highlightYellow,
                      header: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            'Ramówka na dziś',
                            style: context.textStyles.textMedium,
                          ),
                        ),
                      ),
                      footer: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
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
                          style: context.textStyles.textSmall,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ColorShadowedCard(
                              shadowColor: context.colors.highlightPurple,
                              header: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  'Nagłówek',
                                  style: context.textStyles.textMedium,
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'Lorem ipsum',
                                  style: context.textStyles.textSmall,
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  'Stopka',
                                  style: context.textStyles.textSmall,
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'Lorem ipsum',
                                  style: context.textStyles.textSmall,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ColorShadowedCard(
                      shadowColor: context.colors.highlightRed,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'hello world',
                          style: context.textStyles.textSmall,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
