import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_animations/simple_animations.dart';

class PlayButton extends HookWidget {
  const PlayButton({
    super.key,
    required this.size,
    required this.onPressed,
    this.shrinkAnimationDuration = const Duration(milliseconds: 100),
  });

  final double size;
  final Duration shrinkAnimationDuration;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final playing = useState(false);
    final sizeSlider = useState(size);

    return GestureDetector(
      onTap: () async {
        onPressed();
        sizeSlider.value = 0.0;
        await Future<int>.delayed(shrinkAnimationDuration);
        playing.value = !playing.value;
        sizeSlider.value = size;
      },
      child: ColoredBox(
        color: const Color(0x00000000),
        child: AnimatedContainer(
          curve: Curves.easeIn,
          duration: shrinkAnimationDuration,
          width: sizeSlider.value,
          height: sizeSlider.value,
          child: _PlayButtonImage(
            playing: playing.value,
          ),
          // child: _PlayButtonImage(
          //   size: sizeSlider.value,
          //   playing: playing.value,
          // ),
        ),
      ),
    );
  }
}

class _PlayButtonImage extends HookWidget {
  _PlayButtonImage({
    this.playing = false,
  });
  final bool playing;

  final tween = Tween<double>(begin: 0, end: 2);

  final playIcon = SvgPicture.asset(
    'assets/ra_playbutton/play_icon.svg',
    allowDrawingOutsideViewBox: true,
  );
  final stopIcon = SvgPicture.asset(
    'assets/ra_playbutton/stop_icon.svg',
    allowDrawingOutsideViewBox: true,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: playing
          ? LoopAnimationBuilder(
              builder: (context, value, child) {
                return Transform.rotate(
                  angle: pi * value,
                  child: playIcon,
                );
              },
              duration: const Duration(seconds: 6),
              tween: tween,
            )
          : stopIcon,
    );
  }
}
