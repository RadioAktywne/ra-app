import 'package:flutter/material.dart';
import 'package:radioaktywne/components/ra_player/ra_player_handler.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';
import 'package:radioaktywne/extensions/extensions.dart';

class RaDropdownIcon extends StatelessWidget {
  const RaDropdownIcon({
    super.key,
    required this.audioHandler,
    this.animationDuration = const Duration(milliseconds: 400),
    this.size = 45,
  });

  final RaPlayerHandler audioHandler;
  final Duration animationDuration;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      duration: const Duration(milliseconds: 400),
      turns: switch (audioHandler.playerKind.value) {
        PlayerKind.widget => 0,
        PlayerKind.page => 0.5,
      },
      child: Icon(
        Icons.keyboard_arrow_up,
        color: context.colors.highlightGreen,
        size: size,
      ),
    );
  }
}
