import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:flutter_radio_player/models/frp_player_event.dart';

class FRPPlayerControls extends StatefulWidget {

  const FRPPlayerControls({
    super.key,
    required this.flutterRadioPlayer,
    required this.addSourceFunction,
    required this.updateCurrentStatus,
  });
  final FlutterRadioPlayer flutterRadioPlayer;
  final Function addSourceFunction;
  final Function(String status) updateCurrentStatus;

  @override
  State<FRPPlayerControls> createState() => _FRPPlayerControlsState();
}

class _FRPPlayerControlsState extends State<FRPPlayerControls> {
  String latestPlaybackStatus = 'flutter_radio_stopped';
  String currentPlaying = 'N/A';
  double volume = 1;
  final nowPlayingTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.flutterRadioPlayer.frpEventStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final frpEvent =
          FRPPlayerEvents.fromJson(jsonDecode(snapshot.data!) as Map<String, dynamic>);
          if (kDebugMode) {
            print('====== EVENT START =====');
            print('Playback status: ${frpEvent.playbackStatus}');
            print('Icy details: ${frpEvent.icyMetaDetails}');
            print('Other: ${frpEvent.data}');
            print('====== EVENT END =====');
          }
          if (frpEvent.playbackStatus != null) {
            latestPlaybackStatus = frpEvent.playbackStatus!;
            widget.updateCurrentStatus(latestPlaybackStatus);
          }
          if (frpEvent.icyMetaDetails != null) {
            currentPlaying = frpEvent.icyMetaDetails!;
            nowPlayingTextController.text = frpEvent.icyMetaDetails!;
          }
          var statusIcon = const Icon(Icons.pause_circle_filled);
          switch (frpEvent.playbackStatus) {
            case 'flutter_radio_playing':
              statusIcon = const Icon(Icons.pause_circle_filled);
              break;
            case 'flutter_radio_paused':
              statusIcon = const Icon(Icons.play_circle_filled);
              break;
            case 'flutter_radio_loading':
              statusIcon = const Icon(Icons.refresh_rounded);
              break;
            case 'flutter_radio_stopped':
              statusIcon = const Icon(Icons.play_circle_filled);
              break;
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(currentPlaying),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // IconButton(
                      //   onPressed: () async {
                      //     widget.flutterRadioPlayer.playOrPause();
                      //     // if (frpEvent.playbackStatus == 'flutter_radio_paused') {
                      //     //   // widget.flutterRadioPlayer.seekToMediaSource(0, true);
                      //     //   widget.flutterRadioPlayer.play();
                      //     //   // widget.flutterRadioPlayer.playOrPause();
                      //     //
                      //     //   // Sneaky trick for resuming the broadcast live
                      //     //   // widget.addSourceFunction(); // Add source to channel list
                      //     //   // widget.flutterRadioPlayer.next(); // skip to next channel
                      //     // } else {
                      //     //   widget.flutterRadioPlayer.pause();
                      //     //   // widget.flutterRadioPlayer.next();
                      //     // }
                      //     // // widget.flutterRadioPlayer.playOrPause();
                      //     resetNowPlayingInfo();
                      //   },
                      //   icon: statusIcon,
                      // ),
                      IconButton(
                        onPressed: () async {
                          // widget.addSourceFunction();
                          // widget.flutterRadioPlayer.next();
                          widget.flutterRadioPlayer.seekToMediaSource(-1, true);
                          widget.flutterRadioPlayer.play();
                        },
                        icon: const Icon(Icons.play_circle_outlined),
                      ),
                      IconButton(
                        onPressed: () async {
                          widget.flutterRadioPlayer.pause();
                        },
                        icon: const Icon(Icons.pause_circle_outlined),
                      ),
                      // IconButton(
                      //   onPressed: () async {
                      //     widget.flutterRadioPlayer.stop();
                      //     // resetNowPlayingInfo();
                      //     widget.addSourceFunction();
                      //   },
                      //   icon: const Icon(Icons.stop_circle_outlined),
                      // ),
                      // IconButton(
                      //   onPressed: () async {
                      //     widget.addSourceFunction();
                      //     widget.flutterRadioPlayer.next();
                      //     // resetNowPlayingInfo();
                      //   },
                      //   icon: const Icon(Icons.skip_next),
                      // ),
                    ],
                  ),
                  Slider(
                    value: volume,
                    onChanged: (value) {
                      setState(() {
                        volume = value;
                        widget.flutterRadioPlayer.setVolume(volume);
                      });
                    },
                  )
                ],
              ),
            ),
          );
        } else {
          return const Text('Determining state ...');
        }
      },
    );
  }

  void resetNowPlayingInfo() {
    currentPlaying = 'Radio Aktywne';
  }
}
