import 'package:flutter/material.dart';
import 'package:radioaktywne/components/ra_dropdown_icon.dart';
import 'package:radioaktywne/components/ra_player/ra_player_handler.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';
import 'package:radioaktywne/components/utility/ra_splash.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
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
      color: context.colors.backgroundDark,
      child: Column(
        children: [
          // top: type     bottom arrow
          Padding(
            padding: RaPageConstraints.outerWidgetPagePadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.mediaKindToString(mediaKind),
                  style: context.textStyles.textPlayer,
                ),
                RaSplash(
                  child: const Placeholder(),
                  // const RaDropdownIcon(state: RaDropdownIconState.opened),
                  onPressed: () =>
                      audioHandler.playerKind.value = PlayerKind.widget,
                )
              ],
            ),
          ),
          // image
          // audioHandler.
        ],
      ),
    );
  }
}
