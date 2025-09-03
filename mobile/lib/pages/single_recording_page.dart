import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';
import 'package:radioaktywne/components/utility/custom_padding_html_widget.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/recording_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_links.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:radioaktywne/state/audio_handler_cubit.dart';

/// Page displaying a single recording.
class SingleRecordingPage extends StatefulWidget {
  const SingleRecordingPage({super.key, required this.recording});
  final RecordingInfo recording;

  @override
  _SingleRecordingPageState createState() => _SingleRecordingPageState();
}

class _SingleRecordingPageState extends State<SingleRecordingPage> {
  var _fullImagePath = '';

  /// Space between things on the page.
  static const _emptySpace = SizedBox(height: 9);

  /// Space from the top of the page.
  static const _spaceFromTop = SizedBox(height: 26);

  @override
  void initState() {
    super.initState();
    _updateImageForRecording();
  }

  Future<void> _updateImageForRecording() async {
    if (widget.recording.fullImagePath.isNotEmpty) {
      final fullImagePath = await fetchSingle(
        Uri.https(RaApi.baseUrl,
            '${RaApi.endpoints.media}/${widget.recording.fullImagePath}'),
        (jsonData) =>
            jsonData['media_details']['sizes']['full']['source_url'] as String,
      );
      setState(() {
        _fullImagePath = fullImagePath;
      });
    } else {
      setState(() {
        _fullImagePath = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = context.read<AudioHandlerCubit>().state;

    return Container(
      color: context.colors.backgroundLight,
      child: Padding(
        padding: RaPageConstraints.outerTextPagePadding,
        child: ListView(
          children: [
            _spaceFromTop,
            StreamBuilder<PlaybackState>(
              stream: audioHandler.playbackState,
              builder: (context, playbackStateSnapshot) {
                final playbackState =
                    playbackStateSnapshot.data ?? PlaybackState();
                return StreamBuilder<MediaItem?>(
                  stream: audioHandler.mediaItem,
                  builder: (context, mediaItemSnapshot) {
                    final mediaItem = mediaItemSnapshot.data;
                    return ValueListenableBuilder<MediaKind>(
                      valueListenable: audioHandler.mediaKind,
                      builder: (context, mediaKind, _) {
                        final isPlayingCurrentRecording = mediaItem != null &&
                            mediaItem.id == widget.recording.mediaItem.id &&
                            playbackState.playing &&
                            mediaKind == MediaKind.recording;

                        final showPlayButton = !isPlayingCurrentRecording;

                        final buttonPlaying =
                            isPlayingCurrentRecording && playbackState.playing;
                        final buttonProcessingState = isPlayingCurrentRecording
                            ? playbackState.processingState
                            : AudioProcessingState.idle;

                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(
                              _fullImagePath,
                              loadingBuilder: (context, child,
                                      loadingProgress) =>
                                  loadingProgress == null
                                      ? child
                                      : Container(
                                          color: context
                                              .colors.backgroundDarkSecondary,
                                          child: const RaProgressIndicator(),
                                        ),
                              errorBuilder: (_, __, ___) => Center(
                                child: Image.asset('assets/defaultMedia.png'),
                              ),
                            ),
                            if (showPlayButton)
                              RaPlayButton(
                                size: 60,
                                onPressed: () => audioHandler.playMediaItem(
                                  widget.recording.mediaItem,
                                  mediaKind: MediaKind.recording,
                                ),
                                playing: buttonPlaying,
                                audioProcessingState: buttonProcessingState,
                              ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            _emptySpace,
            Container(
              color: context.colors.backgroundDark,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CustomPaddingHtmlWidget(
                    style: context.textStyles.textMedium.copyWith(
                      color: context.colors.backgroundLight,
                    ),
                    htmlContent: widget.recording.title,
                  ),
                ),
              ),
            ),
            _emptySpace,
            CustomPaddingHtmlWidget(
              style: context.textStyles.textSmallGreen.copyWith(
                color: context.colors.backgroundDark,
              ),
              htmlContent: widget.recording.description,
            ),
            SizedBox(height: context.playerPaddingValue),
          ],
        ),
      ),
    );
  }
}
