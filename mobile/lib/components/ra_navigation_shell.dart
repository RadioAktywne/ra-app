import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/ra_appbar.dart';
import 'package:radioaktywne/components/ra_bottomnavbar.dart';
import 'package:radioaktywne/components/ra_burger_menu.dart';
import 'package:radioaktywne/components/radio_player/radio_player_widget.dart';
import 'package:radioaktywne/extensions/build_context.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:radioaktywne/router/ra_routes.dart';
import 'package:radioaktywne/state/audio_handler_cubit.dart';

class RaNavigationShell extends HookWidget {
  RaNavigationShell({
    super.key,
    required this.child,
    required this.state,
  });

  final Widget child;
  final GoRouterState state;

  final _scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: 'Inner scaffold');

  static const _navigationItems = {
    RaRoutes.home: 'Radio Aktywne',
    RaRoutes.recordings: 'Nagrania',
    RaRoutes.albumOfTheWeek: 'Płyta tygodnia',
    RaRoutes.articles: 'Publicystyka',
    RaRoutes.radioPeople: 'Radiowcy',
    RaRoutes.ramowka: 'Ramówka',
    RaRoutes.broadcasts: 'Audycje',
    RaRoutes.about: 'O nas',
  };

  int _determineSelected() {
    final index = _navigationItems.keys.toList().indexOf(
          _navigationItems.keys.firstWhere(
            (key) => key == state.fullPath,
            orElse: () => RaRoutes.home,
          ),
        );
    return max(index, 0);
  }

  @override
  Widget build(BuildContext context) {
    final burgerMenuIconController = useAnimationController(
      duration: const Duration(milliseconds: 450),
      reverseDuration: const Duration(milliseconds: 250),
    );

    final selectedPageIndex = _determineSelected();

    return BlocProvider(
      create: (_) => AudioHandlerCubit(),
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: context.colors.backgroundDark,
        ),
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
                  ? _scaffoldKey.currentState?.closeEndDrawer()
                  : _scaffoldKey.currentState?.openEndDrawer(),
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: burgerMenuIconController,
                color: context.colors.highlightGreen,
                size: 32,
                semanticLabel: 'RA AppBar menu button',
              ),
            ),
            text: 'Radio\nAktywne',
            iconPath: 'assets/ra_logo/RA_logo.svg',
            titlePadding: const EdgeInsets.only(left: 4, top: 8, bottom: 16),
            imageHeight: 40,
          ),
          body: SafeArea(
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.transparent,
              drawerScrimColor: context.colors.drawerBackgroundOverlay,
              onEndDrawerChanged: (isOpened) => isOpened
                  ? burgerMenuIconController.forward()
                  : burgerMenuIconController.reverse(),
              endDrawer: RaBurgerMenu(
                onItemClicked: burgerMenuIconController.reverse,
                selectedIndex: selectedPageIndex,
                navigationItems: _navigationItems,
              ),
              body: child,
            ),
          ),
          bottomNavigationBar: RaBottomNavigationBar(
            selectedPageIndex: selectedPageIndex,
            onTap: burgerMenuIconController.reverse,
          ),
          bottomSheet: const Padding(
            padding: RaPageConstraints.outerWidgetPagePadding,
            child: RadioPlayerWidget(),
          ),
          resizeToAvoidBottomInset: true,
        ),
      ),
    );
  }
}