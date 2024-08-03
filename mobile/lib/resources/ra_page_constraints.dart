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
  static const EdgeInsets outerWidgetPagePadding =
      EdgeInsets.symmetric(horizontal: pagePaddingValue);
  static const EdgeInsets outerTextPagePadding =
      EdgeInsets.symmetric(horizontal: 26);
  static const EdgeInsets pagePadding = EdgeInsets.only(
    top: pagePaddingValue,
    bottom: _radioPlayerPaddingValue,
    left: pagePaddingValue,
    right: pagePaddingValue,
  );
  static const double radioPlayerHeight = 50;
  static const double _radioPlayerPaddingValue = 1.5 * radioPlayerHeight;
  static const double recordingPlayerHeight = radioPlayerHeight * 2.5;
  static const double _recordingPlayerPaddingValue =
      1.1 * recordingPlayerHeight;
}

extension PlayerPaddingValue on BuildContext {
  double get playerPaddingValue =>
      switch (BlocProvider.of<AudioHandlerCubit>(this).state.mediaKind) {
        MediaKind.radio => RaPageConstraints._radioPlayerPaddingValue,
        MediaKind.recording => RaPageConstraints._recordingPlayerPaddingValue,
      };
}
