import 'dart:math';

import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/resources/assets.gen.dart';
import 'package:simple_animations/simple_animations.dart';

/// Represents play/pause animated button.
class RaPlayButton extends HookWidget {
  const RaPlayButton({
    super.key,
    required this.size,
    required this.onPressed,
    this.shrinkAnimationDuration = const Duration(milliseconds: 150),
  });

  /// Size of the button (in pixels).
  final double size;

  final void Function() onPressed;

  /// Duration of the shrink animation applied
  /// to the button on play/pause.
  ///
  /// Default: 150 ms.
  final Duration shrinkAnimationDuration;

  @override
  Widget build(BuildContext context) {
    // TODO: Refactor RAPlayButton state so that it depends on (listens to)
    // TODO: radio stream processing state
    // hint: check implementation of processing state in RadioAudioService
    // widget with BlockBuilder and StreamBuilder.
    final playing = useState(false);
    final sizeSlider = useState(size);

    return Container(
      width: size + 1,
      height: size + 1,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () async {
          onPressed();
          sizeSlider.value = 0.0;
          await Future<dynamic>.delayed(shrinkAnimationDuration);
          playing.value = !playing.value;
          sizeSlider.value = size;
        },
        child: AnimatedContainer(
          curve: Curves.easeIn,
          duration: shrinkAnimationDuration,
          width: sizeSlider.value,
          height: sizeSlider.value,
          child: _PlayButtonImage(
            playing: playing.value,
          ),
        ),
      ),
    );
  }
}

// TODO: Rethink RAPlayButton with loading animation in mind. Stream is loading
// TODO: for 1s after 'play' is pressed, the app lacks visual feedback of this.
// TODO: Loading indication of some kind is needed.

class _PlayButtonImage extends HookWidget {
  _PlayButtonImage({
    this.playing = false,
  });

  // TODO: use some sort of enum instead of bool for describing state.
  // Could use AudioProcessingState from audio_service directly.
  final bool playing;

  final _tween = Tween<double>(begin: 0, end: 2);

  /// Image while paused.
  static final _pause = const SvgGenImage('assets/icons/pause.svg').svg();

  /// Image while playing.
  static final _play = const SvgGenImage('assets/icons/play.svg').svg();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Center(
        child: playing
            ? LoopAnimationBuilder(
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: pi * value,
                    child: _play,
                  );
                },
                duration: const Duration(seconds: 6),
                tween: _tween,
              )
            : _pause,
      ),
    );
  }
}
