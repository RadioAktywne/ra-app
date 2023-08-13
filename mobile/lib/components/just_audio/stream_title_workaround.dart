import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class StreamTitleWorkaround {
  StreamTitleWorkaround() {
    _streamController = StreamController<String>();
    stream = _streamController.stream;
    _fetchStatusJson(); // Fetch stream title asap to avoid placeholders
  }

  late StreamController<String> _streamController;
  late Stream<String> stream;

  final httpPackageUrl =
      Uri.parse('https://listen.radioaktywne.pl:8443/status-json.xsl');
  bool _isPlaying = false;
  var _timer = Timer.periodic(
    const Duration(seconds: 5),
    (timer) {
    /* it's gonna be overwritten anyway */
  },
  );

  void _fetchStatusJson() {
    http.get(httpPackageUrl).then(
      (response) {
        final dynamic jsonData = jsonDecode(response.body);
        final dynamic maybeStreamName =
            jsonData['icestats']['source'][0]['title'];

        if (maybeStreamName is String) {
          _streamController.add(maybeStreamName);
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
