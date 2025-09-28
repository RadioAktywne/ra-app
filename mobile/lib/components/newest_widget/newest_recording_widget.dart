import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:radioaktywne/components/newest_widget/newest_widget_template.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/recording_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_links.dart';
import 'package:radioaktywne/router/ra_routes.dart';

class NewestRecordingWidget extends StatelessWidget {
  const NewestRecordingWidget({super.key, this.shadowColor});

  final Color? shadowColor;

  Future<Iterable<RecordingInfo>> fetchNewestRecordings() async {
    final futures = <Future<RecordingInfo>>[];
    final recordings = await fetchNewest(
      RaApi.baseUrl,
      RaApi.endpoints.recording,
      RecordingInfo.fromJson,
    );

    for (final recording in recordings) {
      futures.add(
        Future(
          () async {
            try {
              recording.thumbnailPath = await fetchSingle(
                Uri.https(RaApi.baseUrl,
                    '${RaApi.endpoints.media}/${recording.thumbnailPath}'),
                // Get image in 'medium_large' size if it exists, else full size
                (jsonData) => (jsonData['media_details']['sizes']
                        ['medium_large'] ??
                    jsonData['media_details']['sizes']
                        ['full'])['source_url'] as String,
              );
            } catch (e, stackTrace) {
              if (kDebugMode) {
                print('HANDLED: $e: $stackTrace');
              }
            }
            return recording;
          },
        ),
      );
    }

    return Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) {
    return NewestWidgetTemplate(
      title: context.l10n.newestRecordings,
      fetchData: fetchNewestRecordings,
      itemBuilder: (context, recording) => NewestWidgetTemplateItem(
        thumbnailPath: recording.thumbnailPath,
        title: recording.title,
        onClick: () => context.go(
          RaRoutes.recordingId(recording.id),
          extra: recording,
        ),
      ),
      shadowColor: shadowColor,
    );
  }
}
