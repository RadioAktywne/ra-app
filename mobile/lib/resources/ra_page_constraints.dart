import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';
import 'package:radioaktywne/state/audio_handler_cubit.dart';

/// Constants representing page constraints
/// that have to be accessible all over the app.
abstract class RaPageConstraints {
  const RaPageConstraints._();

  static const double ramowkaListRowHeight = 22;
  static const double pagePaddingValue = 16;
  static const outerWidgetPagePadding =
      EdgeInsets.symmetric(horizontal: pagePaddingValue);
  static const outerTextPagePadding = EdgeInsets.symmetric(horizontal: 26);
  static const pagePadding = EdgeInsets.only(
    top: pagePaddingValue,
    bottom: _radioPlayerPaddingValue,
    left: pagePaddingValue,
    right: pagePaddingValue,
  );

  static const double headerTextPaddingLeft = 6;
  static const double radioPlayerHeight = 55;
  static const double _radioPlayerPaddingValue = 1.5 * radioPlayerHeight;
  static const double recordingPlayerHeight = radioPlayerHeight * 2.5;
  static const double _recordingPlayerPaddingValue =
      1.1 * recordingPlayerHeight;

  static const double textPageTitlePaddingValue = 8;
  static const textPageTitlePadding = EdgeInsets.all(textPageTitlePaddingValue);
}

extension PlayerPaddingValue on BuildContext {
  double get playerPaddingValue =>
      switch (BlocProvider.of<AudioHandlerCubit>(this).state.mediaKind.value) {
        MediaKind.radio => RaPageConstraints._radioPlayerPaddingValue,
        MediaKind.recording => RaPageConstraints._recordingPlayerPaddingValue,
      };
}
