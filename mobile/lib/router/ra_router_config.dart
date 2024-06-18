import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:radioaktywne/components/ra_navigation_shell.dart';
import 'package:radioaktywne/extensions/build_context.dart';
import 'package:radioaktywne/main.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/pages/article_page.dart';
import 'package:radioaktywne/pages/article_selection_page.dart';
import 'package:radioaktywne/pages/plyta_tygodnia_page.dart';
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
          path: RaRoutes.articles,
          builder: (context, state) => const ArticleSelectionPage(),
        ),
        GoRoute(
          path: RaRoutes.article,
          builder: (context, state) =>
              ArticlePage(article: state.extra! as ArticleInfo),
        ),
        // TODO: Add other routes instead of error page
        // TODO: for better end-user experience
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
          onPressed: () => context.go(RaRoutes.home),
          child: Text(
            'Home',
            style: context.textStyles.polibudzka,
          ),
        ),
      ],
    ),
  ),
);
