import 'package:flutter/material.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:flutter_radio_player/models/frp_source_modal.dart';

import 'frp_controls.dart';

FRPSource defaultSources = FRPSource(
  mediaSources: <MediaSources>[
    MediaSources(
      url: 'https://listen.radioaktywne.pl:8443/raogg',
      description: 'Radio Aktywne',
      isPrimary: true,
      title: 'Radio Aktywne',
      isAac: false,
    ),
  ],
);

class FRPlayer extends StatefulWidget {
  FRPlayer({
    super.key,
    required this.flutterRadioPlayer,
    required this.useIcyData,
  });
  final FlutterRadioPlayer flutterRadioPlayer;
  final FRPSource frpSource = defaultSources;
  final bool useIcyData;

  @override
  State<FRPlayer> createState() => _FRPlayerState();
}

class _FRPlayerState extends State<FRPlayer> {
  int currentIndex = 0;
  String frpStatus = 'flutter_radio_stopped';

  @override
  void initState() {
    super.initState();

    // final defaultSources = FRPSource(
    //   mediaSources: <MediaSources>[
    //     MediaSources(
    //       url: 'https://listen.radioaktywne.pl:8443/raogg',
    //       description: 'Radio Aktywne',
    //       isPrimary: true,
    //       title: 'Radio Aktywne',
    //       isAac: false,
    //     ),
    //   ],
    // );

    widget.flutterRadioPlayer.initPlayer();
    widget.flutterRadioPlayer.addMediaSources(defaultSources);
    widget.flutterRadioPlayer.pause();
    widget.flutterRadioPlayer.useIcyData(widget.useIcyData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FRPPlayerControls(
          flutterRadioPlayer: widget.flutterRadioPlayer,
          addSourceFunction: () => widget.flutterRadioPlayer.addMediaSources(defaultSources),
          updateCurrentStatus: (status) => frpStatus = status,
        ),
      ],
    );
  }
}
