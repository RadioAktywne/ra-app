import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class RALogger {
  const RALogger._();

  static Logger? logger;

  static void setup() {
    Logger.root.level = Level.CONFIG;
    Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
        print('${record.level.name}: ${record.time}: ${record.message}');
      }
    });
  }

  static void log(Level level, String message) {
    if (kDebugMode && logger == null) {
      setup();
    }

    logger!.log(level, message);
  }
}
