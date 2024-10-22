import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
import 'package:radioaktywne/components/ra_player/ra_player_handler.dart';
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
  const SingleRecordingPage({
    super.key,
    required this.recording,
  });
  final RecordingInfo recording;

  @override
  _SingleRecordingPageState createState() => _SingleRecordingPageState();
}

class _SingleRecordingPageState extends State<SingleRecordingPage> {
  /// Space between things on the page.
  static const SizedBox _emptySpace = SizedBox(height: 9);

  /// Space from the top of the page.
  static const SizedBox _spaceFromTop = SizedBox(height: 26);

  Uri _singleRecordingUrl(String id) =>
      Uri.https(RaApi.baseUrl, '${RaApi.endpoints.media}/$id');

  Future<void> updateImageForRecording() async {
    if (widget.recording.fullImagePath.isNotEmpty) {
      final fullImagePath = await fetchSingle(
        _singleRecordingUrl(widget.recording.fullImagePath),
        (jsonData) => jsonData['media_details']['sizes']['full']['source_url'] as String,
      );
      setState(() {
        widget.recording.fullImagePath = fullImagePath;
      });
    } else {
      setState(() {
        widget.recording.fullImagePath = '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    updateImageForRecording();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioHandlerCubit, RaPlayerHandler>(
      builder: (context, audioHandler) {
        return Container(
          color: context.colors.backgroundLight,
          child: Padding(
            padding: RaPageConstraints.outerTextPagePadding,
            child: ListView(
              children: [
                _spaceFromTop,
                // Use Stack to overlay the RaPlayButton on the image
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      widget.recording.fullImagePath,
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : Container(
                                  color: context.colors.backgroundDarkSecondary,
                                  child: const RaProgressIndicator(),
                                ),
                      errorBuilder: (_, __, ___) => Center(
                        child: Image.asset('assets/defaultMedia.png'),
                      ),
                    ),
                    // RaPlayButton in the center of the image
                    RaPlayButton(
                      size: 60, // Adjust the size as needed
                      onPressed: () async => audioHandler.playMediaItem(
                        widget.recording.mediaItem,
                        mediaKind: MediaKind.recording,
                      ),
                      playing: audioHandler.playbackState.value.playing,
                      audioProcessingState: audioHandler.playbackState.value.processingState,
                    ),
                  ],
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
      },
    );
  }
}
