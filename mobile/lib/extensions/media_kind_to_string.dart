import 'package:flutter/material.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';
import 'package:radioaktywne/extensions/extensions.dart';

extension MediaKindToString on BuildContext {
  String mediaKindToString(MediaKind kind) {
    return switch (kind) {
      MediaKind.radio => l10n.radio,
      MediaKind.recording => l10n.recording,
    };
  }
}
