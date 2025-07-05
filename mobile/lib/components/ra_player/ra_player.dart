import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/ra_player/ra_player_handler.dart';
import 'package:radioaktywne/components/ra_player/ra_player_widget.dart';
import 'package:radioaktywne/state/audio_handler_cubit.dart';

class RaPlayer extends HookWidget {
  const RaPlayer({
    super.key,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioHandlerCubit, RaPlayerHandler>(
      builder: (context, audioHandler) {
        return RaPlayerWidget(audioHandler: audioHandler);
      },
    );
  }
}

class MultipleValuesListenableBuilder extends StatelessWidget {
  const MultipleValuesListenableBuilder({
    super.key,
    required this.listenables,
    required this.child,
  });

  final Widget child;

  final List<ValueListenable<dynamic>> listenables;

  Widget _makeNextListenable(BuildContext context, int position, Widget child) {
    if (position >= listenables.length) {
      return child;
    }

    return ValueListenableBuilder(
      valueListenable: listenables.elementAt(position),
      builder: (context, listenable, widget) =>
          _makeNextListenable(context, position + 1, child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _makeNextListenable(context, 0, child);
  }
}
