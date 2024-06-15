import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/ra_navigation_shell.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/l10n/localizations.dart';
import 'package:radioaktywne/pages/plyta_tygodnia_page.dart';

import 'components/ramowka/ramowka_widget.dart';

void main() {
  /// Setup so the orientation stays in portrait mode
  ///
  /// Also, in the AndroidManifest.xml file,
  /// added a line: `android:screenOrientation="portrait"`
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(const MainApp()));
}

final _router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const MainPage(),
        ),
        GoRoute(
          path: '/album',
          builder: (context, state) => const PlytaTygodniaPage(),
        ),
      ],
      builder: (context, state, child) =>
          RaNavigationShell(state: state, child: child),
    ),
  ],

  // TODO: debug only, will delete later
  // (because there will be no way to go to page
  // that doesn't exist).
  errorBuilder: (context, state) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Page `$state` doesn't (yet) exist...",
          style: context.textStyles.textMedium,
        ),
        TextButton(
          onPressed: () => context.go('/home'),
          child: Text(
            'Home',
            style: context.textStyles.polibudzka,
          ),
        ),
      ],
    ),
  ),
);

class MainApp extends HookWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: context.theme.copyWith(
        scaffoldBackgroundColor: context.colors.backgroundLight,
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.transparent),
      ),
      locale: const Locale('pl'),
      supportedLocales: context.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateTitle: (context) => context.l10n.hello,
      routerConfig: _router,
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
  });

  static const _widgetPadding = EdgeInsets.symmetric(
    vertical: 8,
    horizontal: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.backgroundLight,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Ramówka widget
              const Padding(
                padding: _widgetPadding,
                child: RamowkaWidget(),
              ),

              /// Old Ramowka
              Padding(
                padding: _widgetPadding,
                child: ColorShadowedCard(
                  shadowColor: context.colors.highlightYellow,
                  header: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'Ramówka na dziś',
                      style: context.textStyles.textMedium,
                    ),
                  ),
                  footer: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                          ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                          ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                          ),
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
                padding: _widgetPadding,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ColorShadowedCard(
                          shadowColor: context.colors.highlightPurple,
                          header: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                            ),
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
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                            ),
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
            ],
          ),
        ],
      ),
    );
  }
}
