import 'dart:async';

import 'package:radioaktywne/network/http.dart';
import 'package:radioaktywne/resources/ra_links.dart';

class StreamTitleWorkaround {
  StreamTitleWorkaround() {
    _streamController = StreamController<String>();
    stream = _streamController.stream;
    _fetchStatusJson(); // Fetch stream title asap to avoid placeholders
  }

  static const streamName = 'Radio Aktywne';

  late StreamController<String> _streamController;
  late Stream<String> stream;

  final httpPackageUrl = Uri.https(RaRadio.baseUrl, RaRadio.status);
  var _isPlaying = false;
  var _timer = Timer.periodic(
    const Duration(seconds: 5),
    (_) {
      /* it's gonna be overwritten anyway */
    },
  );

  void _fetchStatusJson() {
    raHttpClient.getUri<Map<String, dynamic>>(httpPackageUrl).then(
      (response) {
        final dynamic maybeStreamName =
            response.data!['icestats']['source'][0]['title'];

        if (maybeStreamName is String) {
          if (maybeStreamName == 'Unknown') {
            _streamController.add(
              streamName,
            );
          } else {
            _streamController.add(maybeStreamName);
          }
        }
      },
    );
  }

  void playerStarted() {
    if (!_isPlaying) {
      _resetTimer();
    }
    _isPlaying = true;
  }

  void playerStopped() {
    if (_isPlaying) {
      _timer.cancel();
    }
    _isPlaying = false;
  }

  void _resetTimer() {
    _timer.cancel();
    _fetchStatusJson();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        _fetchStatusJson();
      },
    );
  }
}
