import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/utility/lazy_loaded_grid_view.dart';
import 'package:radioaktywne/models/recording_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';

class RecordingsPage extends HookWidget {
  const RecordingsPage({
    super.key,
    required this.audioHandler,
  });

  final AudioHandler? audioHandler;

  static Uri _recordingsUrl(int page) => Uri.parse(
        'https://radioaktywne.pl/wp-json/wp/v2/recording?_embed=true&page=$page&per_page=8',
      );

  static Uri _recordingUrl(String id) =>
      Uri.parse('https://radioaktywne.pl/wp-json/wp/v2/media/$id');

  Future<List<RecordingInfo>> fetchPage(int page) async {
    final pageUrl = _recordingsUrl(page);
    final data = await fetchData(pageUrl, RecordingInfo.fromJson);

    final pageData = <RecordingInfo>[];
    for (final element in data) {
      final (recordingPath, duration) = await fetchSingle(
        _recordingUrl(element.recordingPath),
        (jsonData) => (
          jsonData['source_url'] as String,
          Duration(seconds: jsonData['media_details']['length'] as int)
        ),
      );

      element
        ..recordingPath = recordingPath
        ..duration = duration
        ..thumbnailPath = await fetchSingle(
          _recordingUrl(element.thumbnailPath),
          (jsonData) => jsonData['media_details']['sizes']['thumbnail']
              ['source_url'] as String,
        );
      pageData.add(element);
    }

    return pageData;
  }

  @override
  Widget build(BuildContext context) {
    return LazyLoadedGridView(
      fetchPage: fetchPage,
      itemBuilder: (recording) => LazyLoadedGridViewItem(
        title: recording.title,
        thumbnailPath: recording.thumbnailPath,
      ),
      onItemTap: (recording, index) async {
        await audioHandler?.updateMediaItem(recording.mediaItem);
        await audioHandler?.play();
      },
    );
  }
}
