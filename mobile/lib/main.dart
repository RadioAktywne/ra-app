import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/newest_article/newest_article_widget.dart';
import 'package:radioaktywne/components/newest_recording/newest_recording_widget.dart';
import 'package:radioaktywne/components/ramowka/ramowka_widget.dart';
import 'package:radioaktywne/components/teraz_gramy/teraz_gramy_widget.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/l10n/localizations.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:radioaktywne/router/ra_router_config.dart';

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
      routerConfig: raRouter,
    );
  }
}

// TODO: needs major refactor
class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
  });

  static const _widgetPadding = EdgeInsets.only(
    top: RaPageConstraints.pagePadding,
    left: RaPageConstraints.pagePadding,
    right: RaPageConstraints.pagePadding,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.backgroundLight,
      width: double.infinity,
      height: double.infinity,
      child: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: RaPageConstraints.radioPlayerPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// Ramówka widget
                  Padding(
                    padding: _widgetPadding,
                    child: RamowkaWidget(),
                  ),
                  /// Teraz Gramy widget
                  Padding(
                    padding: _widgetPadding,
                    child: AspectRatio(
                      aspectRatio: 1.7,
                      child: TerazGramyWidget(),
                    ),
                  ),
                  /// Najnowsze Nagrania widget & Najnowsze Artykuły Widget
                  Padding(
                    padding: _widgetPadding,
                    child: Row(
                      children: [
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: NewestRecordingWidget(),
                          ),
                        ),
                        SizedBox(
                          width: RaPageConstraints.pagePadding,
                        ),
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: NewestArticleWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
