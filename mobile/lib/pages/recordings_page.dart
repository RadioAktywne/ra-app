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

/// Allow browsing the RA recordings.
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
    for (final element in recordings) {
      final (recordingPath, duration) = await fetchSingle(
        _singleRecordingUrl(element.recordingPath),
        (jsonData) => (
          jsonData['source_url'] as String,
          Duration(seconds: jsonData['media_details']['length'] as int)
        ),
      );

      pageData.add(
        element
          ..recordingPath = recordingPath
          ..duration = duration
          ..thumbnailPath = await fetchSingle(
            _singleRecordingUrl(element.thumbnailPath),
            (jsonData) => jsonData['media_details']['sizes']['thumbnail']
                ['source_url'] as String,
          ),
      );
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
