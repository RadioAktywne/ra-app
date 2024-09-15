import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:radioaktywne/components/ra_navigation_shell.dart';
import 'package:radioaktywne/extensions/themes.dart';
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
        // TODO: Implement
        GoRoute(
          path: RaRoutes.radioPeople,
          builder: (context, state) => _DummyPage(name: state.fullPath ?? ''),
        ),
        GoRoute(
          path: RaRoutes.ramowka,
          builder: (context, state) => const RamowkaPage(),
        ),
        // TODO: Implement
        GoRoute(
          path: RaRoutes.broadcasts,
          builder: (context, state) => _DummyPage(name: state.fullPath ?? ''),
        ),
        // TODO: Implement
        GoRoute(
          path: RaRoutes.about,
          builder: (context, state) => _DummyPage(name: state.fullPath ?? ''),
        ),
        // TODO: Implement
        GoRoute(
          path: RaRoutes.radioPeople,
          builder: (context, state) => _DummyPage(name: state.fullPath ?? ''),
        ),
        GoRoute(
          path: RaRoutes.ramowka,
          builder: (context, state) => const RamowkaPage(),
        ),
        // TODO: Implement
        GoRoute(
          path: RaRoutes.broadcasts,
          builder: (context, state) => _DummyPage(name: state.fullPath ?? ''),
        ),
        // TODO: Implement
        GoRoute(
          path: RaRoutes.about,
          builder: (context, state) => _DummyPage(name: state.fullPath ?? ''),
        ),
      ],
      builder: (context, state, child) =>
          RaNavigationShell(state: state, child: child),
    ),
  ],
);

/// Mock page for testing
class _DummyPage extends StatelessWidget {
  const _DummyPage({
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Page `$name` doesn't (yet) exist...",
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
