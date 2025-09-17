import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioaktywne/components/ra_image.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
import 'package:radioaktywne/components/ra_player/ra_player_handler.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/recording_info.dart';
import 'package:radioaktywne/pages/templates/ra_page_template.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_links.dart';
import 'package:radioaktywne/resources/resources.dart';
import 'package:radioaktywne/state/audio_handler_cubit.dart';

/// Page displaying a single recording.
class SingleRecordingPage extends StatelessWidget {
  const SingleRecordingPage({super.key, required this.rec});

  final RecordingInfo rec;

  Future<RecordingInfo> fetchRecordingDetails() async {
    if (int.tryParse(rec.fullImagePath) != null) {
      try {
        rec.fullImagePath = await fetchSingle(
          Uri.https(
            RaApi.baseUrl,
            '${RaApi.endpoints.media}/${rec.fullImagePath}',
          ),
          (jsonData) => jsonData['media_details']['sizes']['full']['source_url']
              as String,
        );
      } catch (e, stackTrace) {
        rec.fullImagePath = 'assets/defaultMedia.png';
        if (kDebugMode) {
          print('$stackTrace: $e');
        }
      }
    }
    if (int.tryParse(rec.recordingPath) != null) {
      try {
        final (recordingPath, duration) = await fetchSingle(
          Uri.https(
              RaApi.baseUrl, '${RaApi.endpoints.media}/${rec.recordingPath}'),
          (jsonData) => (
            jsonData['source_url'] as String,
            Duration(seconds: jsonData['media_details']['length'] as int)
          ),
        );
        rec.recordingPath = recordingPath;
        rec.duration = duration;
      } catch (e, stackTrace) {
        // TODO: just skip faulty audition?
        if (kDebugMode) {
          print('$stackTrace: $e');
        }
      }
    }
    return Future.value(rec);
  }

  Future<void> _playButtonAction(
    RaPlayerHandler audioHandler,
    MediaKind mediaKind,
    RecordingInfo recording,
    bool isCurrent,
    bool isPlaying,
  ) async {
    switch (mediaKind) {
      case MediaKind.recording:
        if (isCurrent) {
          if (isPlaying) {
            await audioHandler.pause();
          } else {
            await audioHandler.play();
          }
        } else {
          await audioHandler.playMediaItem(
            recording.mediaItem,
            mediaKind: MediaKind.recording,
          );
        }

      case MediaKind.radio:
        await audioHandler.playMediaItem(
          recording.mediaItem,
          mediaKind: MediaKind.recording,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RaPageTemplate(
      onFetch: fetchRecordingDetails,
      defaultData: RecordingInfo.empty(),
      hasData: (recording) => recording.isNotEmpty,
      itemBuilder: (recording) => RaPageTemplateItem(
        imagePath: recording.fullImagePath,
        title: recording.title,
        content: recording.description,
      ),
      imageBuilder: (context, recording) => Stack(
        children: [
          Container(
            alignment: Alignment.center,
            foregroundDecoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.transparent,
                  Colors.black,
                ],
                radius: 1.6,
              ),
            ),
            child: RaImage(imageUrl: recording.fullImagePath),
          ),
          BlocBuilder<AudioHandlerCubit, RaPlayerHandler>(
            builder: (context, audioHandler) => ValueListenableBuilder(
              valueListenable: audioHandler.mediaKind,
              builder: (context, mediaKind, _) {
                return StreamBuilder<AudioProcessingState>(
                  stream: audioHandler.playbackState
                      .map((state) => state.processingState)
                      .distinct(),
                  builder: (context, snapshot) {
                    final audioProcessingState =
                        snapshot.data ?? AudioProcessingState.idle;
                    return StreamBuilder(
                      stream: audioHandler.mediaItem.stream,
                      builder: (context, snapshot) {
                        final currentMediaItem =
                            snapshot.data ?? radioMediaItem;
                        return StreamBuilder<bool>(
                          stream: audioHandler.playing,
                          builder: (context, snapshot) {
                            final isPlaying = snapshot.data ?? false;
                            final isCurrent =
                                currentMediaItem == recording.mediaItem;
                            return Center(
                              child: RaPlayButton(
                                audioProcessingState: switch (mediaKind) {
                                  MediaKind.radio => AudioProcessingState.idle,
                                  MediaKind.recording => isCurrent
                                      ? audioProcessingState
                                      : AudioProcessingState.idle,
                                },
                                onPressed: () => _playButtonAction(
                                  audioHandler,
                                  mediaKind,
                                  recording,
                                  isCurrent,
                                  isPlaying,
                                ),
                                playing: isPlaying && isCurrent,
                                size: 100,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              color: context.colors.backgroundDarkSecondary,
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 3,
              ),
              child: Text(
                recording.duration.formattedMinsAndSecs(),
                style: context.textStyles.textSmallWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
