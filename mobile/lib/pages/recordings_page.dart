import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/utility/lazy_loaded_grid_view.dart';
import 'package:radioaktywne/models/recording_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';

class RecordingsPage extends HookWidget {
  const RecordingsPage({super.key});

  static Uri _recordingsUrl(int page) => Uri.parse(
        'https://radioaktywne.pl/wp-json/wp/v2/recording?_embed=true&page=$page&per_page=16',
      );

  static Uri _recordingUrl(String id) =>
      Uri.parse('https://radioaktywne.pl/wp-json/wp/v2/media/$id');

  @override
  Widget build(BuildContext context) {
    return LazyLoadedGridView(
      fetchPage: (page) async {
        final pageUrl = _recordingsUrl(page);
        final data = await fetchData(pageUrl, RecordingInfo.fromJson);

        final pageData = <RecordingInfo>[];
        for (final element in data) {
          element
            ..recordingPath = await fetchSingle(
              _recordingUrl(element.recordingPath),
              (jsonData) => jsonData['source_url'] as String,
            )
            ..thumbnailPath = await fetchSingle(
              _recordingUrl(element.thumbnailPath),
              (jsonData) => jsonData['media_details']['sizes']['thumbnail']
                  ['source_url'] as String,
            );
          pageData.add(element);
        }

        return pageData;
      },
      transformItem: (recording) => LazyLoadedGridViewItem(
        title: recording.title,
        thumbnailPath: recording.thumbnailPath,
      ),
      onItemTap: (recording, index) {},
    );
  }
}
