import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/ramowka/ramowka_widget.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card_2.dart';
import 'package:radioaktywne/components/utility/swipable_card.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/l10n/localizations.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
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
class MainPage extends HookWidget {
  const MainPage({
    super.key,
  });


  static const _widgetPadding = EdgeInsets.symmetric(
    vertical: 8,
    horizontal: 16,
  );

  @override
  Widget build(BuildContext context) {
    final articles = useState<Iterable<ArticleInfo>>([]);
    final isLoading = useState(false);
    final hasError = useState(false);

    Future<void> fetchArticles() async {
      if (isLoading.value) {
        return;
      }
      isLoading.value = true;

      final pageUri = Uri.parse(
        'https://radioaktywne.pl/wp-json/wp/v2/posts?_embed=true&page=1&per_page=3',
      );

      try {
        final newArticles = await fetchData(pageUri, ArticleInfo.fromJson);
        articles.value = newArticles;
      } on TimeoutException catch (_) {
        hasError.value = true;
      } catch (e) {
        hasError.value = true;
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      fetchArticles();
      return null;
    }, [],);
    return Container(
      color: context.colors.backgroundLight,
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 50),
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
                  Padding(
                    padding: _widgetPadding,
                    child: ColorShadowedCard2(
                      shadowColor: context.colors.highlightRed,
                      footer: DefaultTextStyle(
                        style: context.textStyles.textSmall.copyWith(
                          color: context.colors.highlightGreen,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Teraz gramy \n',
                                  style: context.textStyles.textMedium.copyWith(
                                    color: context.colors.highlightGreen,
                                    height: 1.5,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Lorem Ipsum', // TODO: Place for the song title
                                  style: context.textStyles.textSmall.copyWith(
                                    color: context.colors.highlightGreen,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(80),
                        child: Text( // TODO: Place for the spining vyinyl record
                          '',
                          style: context.textStyles.textSmall,
                        ),
                      ),
                    ),
                  ),
                  GridView.builder( // Najnowsze nagrania i artykuły
                    padding: const EdgeInsets.all(15),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ColorShadowedCard2(
                          shadowColor: context.colors.highlightGreen,
                          header: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Text(
                              'Najnowsze nagrania',
                              style: context.textStyles.textSmall,
                            ),
                          ),
                          footer: DefaultTextStyle(
                            style: context.textStyles.textSmall.copyWith(
                              color: context.colors.highlightGreen,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Text('Lorem ipsum'),
                            ),
                          ),
                          indicator: 0,
                          child: Image.asset(
                            'assets/defaultMedia.png',
                            fit: BoxFit.fill,
                          ),
                        );
                      } else {
                        return SwipableCard(
                          articles: articles.value, 
                          isLoading: isLoading.value,
                          shadowColor: context.colors.highlightYellow,
                          header: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Text(
                              'Najnowsze artykuły',
                              style: context.textStyles.textSmall,
                            ),
                          ),
                        );
                      }
                    },
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
