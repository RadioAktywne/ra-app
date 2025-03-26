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

    final recordingDetails = {for (final rec in recordings) rec.id: rec};
    // small data redundancy, should be offset by increase in search speed

    final recordingFutures = recordings.map((recording) {
      Future<void> fetchRecordingPathAndDuration() async {
        final (recordingPath, duration) = await fetchSingle(
          _singleRecordingUrl(recording.recordingPath),
          (jsonData) => (
            jsonData['source_url'] as String,
            Duration(seconds: jsonData['media_details']['length'] as int)
          ),
        );

        recordingDetails.update(
          recording.id,
          (details) => details
            ..duration = duration
            ..recordingPath = recordingPath,
        );
      }

      return fetchRecordingPathAndDuration();
    });

    final thumbnailFutures = recordings.map((recording) {
      Future<void> fetchThumbnail() async {
        final thumbnailPath = recording.thumbnailPath.isEmpty
            ? ''
            : await fetchSingle(
                _singleRecordingUrl(recording.thumbnailPath),
                // Get image in 'medium_large' size if it exists, else full size
                (jsonData) => (jsonData['media_details']['sizes']
                        ['medium_large'] ??
                    jsonData['media_details']['sizes']
                        ['full'])['source_url'] as String,
              );

        recordingDetails.update(
          recording.id,
          (details) => details..thumbnailPath = thumbnailPath,
        );
      }

      return fetchThumbnail();
    });

    await Future.wait([
      ...recordingFutures,
      ...thumbnailFutures,
    ]); // Await all asynchronous calls at the same time

    return recordingDetails.values.toList();
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
