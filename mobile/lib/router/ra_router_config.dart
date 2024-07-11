import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:radioaktywne/components/ra_navigation_shell.dart';
import 'package:radioaktywne/extensions/build_context.dart';
import 'package:radioaktywne/main.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/pages/article_page.dart';
import 'package:radioaktywne/pages/article_selection_page.dart';
import 'package:radioaktywne/pages/plyta_tygodnia_page.dart';
import 'package:radioaktywne/pages/ramowka_page.dart';
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
        // TODO: Implement page for this route
        GoRoute(
          path: RaRoutes.recordings,
          builder: (context, state) => DummyRoute(state: state),
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
        // TODO: Implement following pages:
        GoRoute(
          path: RaRoutes.radioPeople,
          builder: (context, state) => DummyRoute(state: state),
        ),
        GoRoute(
          path: RaRoutes.ramowka,
          builder: (context, state) => const RamowkaPage(),
        ),
        GoRoute(
          path: RaRoutes.broadcasts,
          builder: (context, state) => DummyRoute(state: state),
        ),
        GoRoute(
          path: RaRoutes.about,
          builder: (context, state) => DummyRoute(state: state),
        ),
      ],
      builder: (context, state, child) =>
          RaNavigationShell(state: state, child: child),
    ),
  ],
);

class DummyRoute extends StatelessWidget {
  const DummyRoute({
    super.key,
    required this.state,
  });

  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Page `${state.fullPath}` doesn't (yet) exist...",
            style: context.textStyles.textMedium,
          ),
          TextButton(
            onPressed: () => context.go(RaRoutes.home),
            child: Text(
              'Home',
              style: context.textStyles.textMedium.copyWith(
                decoration: TextDecoration.underline,
                decorationColor: context.colors.highlightGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
