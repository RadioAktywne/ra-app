import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/assets.gen.dart';
import 'package:simple_animations/simple_animations.dart';

/// Represents play/pause animated button.
class RaPlayButton extends HookWidget {
  const RaPlayButton({
    super.key,
    required this.size,
    required this.onPressed,
    this.audioProcessingState = AudioProcessingState.idle,
    this.shrinkAnimationDuration = const Duration(milliseconds: 150),
  });

  /// Size of the button (in pixels).
  final double size;

  /// Action called every time the button is pressed
  final void Function() onPressed;
  final AudioProcessingState audioProcessingState;

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
    final sizeSlider = useState(size);

    return Container(
      width: size + 1,
      height: size + 1,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () async {
          sizeSlider.value = 0.0;
          await Future<dynamic>.delayed(shrinkAnimationDuration);
          onPressed();
          sizeSlider.value = size;
        },
        child: AnimatedContainer(
          curve: Curves.easeIn,
          duration: shrinkAnimationDuration,
          width: sizeSlider.value,
          height: sizeSlider.value,
          child: _PlayButtonImage(
            size: size,
            audioProcessingState: audioProcessingState,
          ),
        ),
      ),
    );
  }
}

// TODO: Rethink RAPlayButton with loading animation in mind. Stream is loading
// TODO: for 1s after 'play' is pressed, the app lacks visual feedback of this.
// TODO: Loading indication of some kind is needed.

/// Image appropriate to the state of the widget.
class _PlayButtonImage extends StatelessWidget {
  _PlayButtonImage({
    required this.size,
    this.audioProcessingState = AudioProcessingState.idle,
  });

  /// Size of every variation of the button
  final double size;

  // TODO: use some sort of enum instead of bool for describing state.
  // Could use AudioProcessingState from audio_service directly.
  final AudioProcessingState audioProcessingState;

  final _tween = Tween<double>(begin: 0, end: 2);

  /// Image while paused.
  static final _pauseIcon = const SvgGenImage('assets/icons/pause.svg').svg();

  /// Image while playing.
  static final _playIcon = const SvgGenImage('assets/icons/play.svg').svg();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('AudioProcessingState = $audioProcessingState');
    }
    return FittedBox(
      child: Center(
        child: switch (audioProcessingState) {
          AudioProcessingState.ready => ShadowedWidget(
              size: size,
              child: LoopAnimationBuilder(
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: pi * value,
                    child: _playIcon,
                  );
                },
                duration: const Duration(seconds: 6),
                tween: _tween,
              ),
            ),
          AudioProcessingState.loading ||
          AudioProcessingState.buffering =>
            _RaPlayButtonImageLoading(size: size),
          _ => _pauseIcon,
        },
      ),
    );
  }
}

class ShadowedWidget extends StatelessWidget {
  const ShadowedWidget({
    super.key,
    required this.size,
    this.child,
  });

  final double size;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colors.highlightGreen,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _RaPlayButtonImageLoading extends StatelessWidget {
  const _RaPlayButtonImageLoading({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      // fit: StackFit.expand,
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: context.colors.highlightGreen,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 5,
                offset: Offset(0, 5),
              ),
            ],
          ),
        ),
        SizedBox(
          width: size - 11,
          height: size - 11,
          child: CircularProgressIndicator(
            color: context.colors.highlightRed,
            strokeWidth: 2,
          ),
        ),
      ],
    );
  }
}
