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
    print('Page `RecordingsPage` loaded');
    return LazyLoadedGridView(
      fetchPage: (page) async {
        print('fetchPage called from recordings_page.dart');
        final pageUrl = _recordingsUrl(page);
        print('before fetchData, pageUrl=$pageUrl');
        final pageData = await fetchData(pageUrl, RecordingInfo.fromJson);
        print('after fetchData, data=$pageData');

        // for (final data in pageData) {
        //   data.recordingPath = '';
        // }

        print('pageData=$pageData');

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
