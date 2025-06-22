import 'package:flutter/material.dart';
import 'package:radioaktywne/components/ra_dropdown_icon.dart';
import 'package:radioaktywne/components/ra_player/ra_player_handler.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';
import 'package:radioaktywne/components/utility/ra_splash.dart';
import 'package:radioaktywne/extensions/extensions.dart';
// import 'package:radioaktywne/extensions/media_kind_to_string.dart';

class RaPlayerPage extends StatelessWidget {
  const RaPlayerPage({
    super.key,
    required this.audioHandler,
    required this.mediaKind,
  });

  final RaPlayerHandler audioHandler;
  final MediaKind mediaKind;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.backgroundDarkSecondary,
      child: Column(
        children: [
          // top: type     bottom arrow
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(context.mediaKindToString(mediaKind)),
              RaSplash(
                child: const RaDropdownIcon(state: RaDropdownIconState.opened),
                onPressed: () =>
                    audioHandler.playerKind.value = PlayerKind.widget,
              )
            ],
          ),
          // const Placeholder(),
        ],
      ),
    );
  }
}
