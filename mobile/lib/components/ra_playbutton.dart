import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/utility/shadowed_container.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/assets.gen.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_shadow/simple_shadow.dart';

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

  /// State of the audio player
  ///
  /// Default: [AudioProcessingState.idle]
  final AudioProcessingState audioProcessingState;

  /// Duration of the shrink animation applied
  /// to the button on play/pause
  ///
  /// Default: 150 ms
  final Duration shrinkAnimationDuration;

  static const _shadowBlur = 5;

  @override
  Widget build(BuildContext context) {
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
          child: _RaPlayButtonImage(
            size: size,
            audioProcessingState: audioProcessingState,
          ),
        ),
      ),
    );
  }
}

/// Image appropriate to the state of the audio player.
class _RaPlayButtonImage extends StatelessWidget {
  const _RaPlayButtonImage({
    required this.size,
    this.audioProcessingState = AudioProcessingState.idle,
  });

  /// Size of every variation of the button
  final double size;

  /// State of the audio player
  final AudioProcessingState audioProcessingState;

  /// Image while paused.
  static final _pauseIcon = const SvgGenImage('assets/icons/pause.svg').svg();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Center(
        child: switch (audioProcessingState) {
          AudioProcessingState.ready => _RaPlayButtonImagePlaying(size: size),
          AudioProcessingState.loading ||
          AudioProcessingState.buffering =>
            _RaPlayButtonImageLoading(size: size),
          // TODO: (maybe?) Handle error state:
          // TODO: AudioProcessingState.error => ...,
          _ => SimpleShadow(
              opacity: 0.38,
              sigma: RaPlayButton._shadowBlur * 2,
              offset: const Offset(0, 5),
              child: _pauseIcon,
            )
        },
      ),
    );
  }
}

/// Animated playing variant of the button.
///
/// Displayed when the stream is in [AudioProcessingState.ready] state.
class _RaPlayButtonImagePlaying extends StatelessWidget {
  const _RaPlayButtonImagePlaying({
    required this.size,
  });

  /// Size of every variation of the button.
  final double size;

  /// Tween for the animation to know between what
  /// values should it interpolate.
  static final _tween = Tween<double>(begin: 0, end: 2);

  /// Image while playing.
  static final _playIcon = const SvgGenImage('assets/icons/play.svg').svg();

  @override
  Widget build(BuildContext context) {
    return ShadowedContainer(
      shape: BoxShape.circle,
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
    );
  }
}

/// Loading variant of the [RaPlayButton].
///
/// Displayed when the stream is in [AudioProcessingState.loading]
/// or [AudioProcessingState.buffering] state.
class _RaPlayButtonImageLoading extends StatelessWidget {
  const _RaPlayButtonImageLoading({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        ShadowedContainer(
          width: size,
          height: size,
          backgroundColor: context.colors.highlightGreen,
          shape: BoxShape.circle,
        ),
        Container(
          padding: const EdgeInsets.all(5),
          width: size,
          height: size,
          child: CircularProgressIndicator(
            color: context.colors.highlightRed,
            strokeWidth: 1.7,
          ),
        ),
      ],
    );
  }
}
