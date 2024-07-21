import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:radioaktywne/components/ra_navigation_shell.dart';
import 'package:radioaktywne/extensions/themes.dart';
import 'package:radioaktywne/main.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/pages/article_page.dart';
import 'package:radioaktywne/pages/article_selection_page.dart';
import 'package:radioaktywne/pages/plyta_tygodnia_page.dart';
import 'package:radioaktywne/pages/ramowka_page.dart';
import 'package:radioaktywne/router/ra_routes.dart';
import 'package:radioaktywne/state/audio_handler_cubit.dart';

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
        // TODO: This is just a mock. Replace with proper page.
        GoRoute(
          path: RaRoutes.recordings,
          builder: (context, state) => Container(
            color: context.colors.backgroundLight,
            child: Center(
              child: BlocBuilder<AudioHandlerCubit, AudioHandler?>(
                builder: (context, audioHandler) {
                  return TextButton(
                    onPressed: () {
                      audioHandler?.playMediaItem(
                        MediaItem(
                          id: 'https://radioaktywne.pl/wp-content/uploads/2024/06/ola-olczyk.mp3',
                          title:
                              'Stream title not provided', // TODO: zmienić na 'Radio Aktywne'
                          album:
                              'Stream name not provided', // TODO: zmienić na 'Radio Aktywne'
                          artUri: Uri.parse(
                            'https://cdn-profiles.tunein.com/s10187/images/logod.png',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Przełącz na `ola-olczyk.mp3`',
                      style: context.textStyles.textSmallGreen,
                    ),
                  );
                },
              ),
            ),
          ),
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
