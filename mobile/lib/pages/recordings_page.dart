import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/ra_player/ra_player_handler.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';
import 'package:radioaktywne/components/utility/lazy_loaded_grid_view.dart';
import 'package:radioaktywne/models/recording_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_links.dart';
import 'package:radioaktywne/state/audio_handler_cubit.dart';

/// Allows browsing the RA recordings.
class RecordingsPage extends HookWidget {
  const RecordingsPage({
    super.key,
    this.perPage = 8,
  });

  final int perPage;

  Uri _allRecordingsUrl(int page) => Uri.https(
        RaApi.baseUrl,
        RaApi.endpoints.recording,
        {
          'embed': true.toString(),
          'page': page.toString(),
          'per_page': perPage.toString(),
        },
      );

  Uri _singleRecordingUrl(String id) =>
      Uri.https(RaApi.baseUrl, '${RaApi.endpoints.media}/$id');

  Future<List<RecordingInfo>> fetchPage(int page) async {
    final pageUrl = _allRecordingsUrl(page);
    final recordings = await fetchData(pageUrl, RecordingInfo.fromJson);

    final pageData = <RecordingInfo>[];

    final recordingDetails = {
      for (final RecordingInfo recording in recordings)
        recording.title: RecordingDetails(),
    };
    // using title as key isn't ideal to put it mildly, but out of all the
    // fields in RecordingInfo I reckon this one is the least likely to be empty

    final recordingFutures = recordings.map((element) {
      Future<void> fetchRecordingPathAndDuration() async {
        final (recordingPath, duration) = await fetchSingle(
          _singleRecordingUrl(element.recordingPath),
          (jsonData) => (
            jsonData['source_url'] as String,
            Duration(seconds: jsonData['media_details']['length'] as int)
          ),
        );
        recordingDetails[element.title]?.recordingPath = recordingPath;
        recordingDetails[element.title]?.duration = duration;
      }

      return fetchRecordingPathAndDuration();
    });

    final thumbnailFutures = recordings.map((element) {
      Future<void> fetchThumbnail() async {
        final thumbnailPath = element.thumbnailPath.isEmpty
            ? ''
            : await fetchSingle(
                _singleRecordingUrl(element.thumbnailPath),
                (jsonData) => jsonData['media_details']['sizes']['thumbnail']
                    ['source_url'] as String,
              );
        recordingDetails[element.title]?.thumbnailPath = thumbnailPath;
      }

      return fetchThumbnail();
    });

    await Future.wait([
      ...recordingFutures,
      ...thumbnailFutures,
    ]); // Await for all asynchronous calls made all at once

    for (final element in recordings) {
      pageData.add(
        element
          ..recordingPath = recordingDetails[element.title]!.recordingPath!
          ..duration = recordingDetails[element.title]!.duration!
          ..thumbnailPath = recordingDetails[element.title]!.thumbnailPath!,
      ); // TODO: this looks bad with all these exclamation marks, could use a refactor at some point
    }

    return pageData;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioHandlerCubit, RaPlayerHandler>(
      builder: (context, audioHandler) {
        return LazyLoadedGridView(
          fetchPage: fetchPage,
          itemBuilder: (recording) => LazyLoadedGridViewItem(
            title: recording.title,
            thumbnailPath: recording.thumbnailPath,
          ),
          // TODO: navigate to the tapped recording's page
          onItemTap: (recording, index) async => audioHandler.playMediaItem(
            recording.mediaItem,
            mediaKind: MediaKind.recording,
          ),
        );
      },
    );
  }
}

class RecordingDetails {
  String? recordingPath;
  Duration? duration;
  String? thumbnailPath;
}
