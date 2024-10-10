import 'package:go_router/go_router.dart';
import 'package:radioaktywne/components/ra_navigation_shell.dart';
import 'package:radioaktywne/main.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/pages/article_page.dart';
import 'package:radioaktywne/pages/article_selection_page.dart';
import 'package:radioaktywne/pages/plyta_tygodnia_page.dart';
import 'package:radioaktywne/pages/ramowka_page.dart';
import 'package:radioaktywne/pages/recordings_page.dart';
import 'package:radioaktywne/router/ra_routes.dart';

final raRouter = GoRouter(
  initialLocation: RaRoutes.home,
  routes: [
    ShellRoute(
      routes: [
        GoRoute(
          path: RaRoutes.home,
          builder: (context, state) => const MainPage(),
        ),
        GoRoute(
          path: RaRoutes.albumOfTheWeek,
          builder: (context, state) => const PlytaTygodniaPage(),
        ),
        GoRoute(
          path: RaRoutes.recordings,
          builder: (context, state) => const RecordingsPage(),
        ),
        GoRoute(
          path: RaRoutes.articles,
          builder: (context, state) => const ArticleSelectionPage(),
        ),
        GoRoute(
          path: RaRoutes.article,
          builder: (context, state) =>
              ArticlePage(article: state.extra! as ArticleInfo),
        ),
        GoRoute(
          path: RaRoutes.ramowka,
          builder: (context, state) => const RamowkaPage(),
        ),
        GoRoute(
          path: RaRoutes.ramowka,
          builder: (context, state) => const RamowkaPage(),
        ),
      ],
      builder: (context, state, child) =>
          RaNavigationShell(state: state, child: child),
    ),
  ],
);
