import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/extensions.dart';

class RaProgressBar extends StatelessWidget {
  const RaProgressBar({
    super.key,
    required this.totalLength,
  });

  final Duration totalLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: context.colors.backgroundDark,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: ProgressBar(
          barHeight: 6,
          progress: Duration.zero,
          buffered: Duration.zero,
          baseBarColor: context.colors.backgroundLight,
          progressBarColor: context.colors.highlightGreen,
          thumbColor: context.colors.highlightRed,
          thumbGlowColor: Colors.transparent,
          thumbRadius: 7,
          timeLabelLocation: TimeLabelLocation.none,
          total: totalLength,
          onSeek: (duration) {
            print('User selected a new time: $duration');
          },
        ),
      ),
    );
  }
}
