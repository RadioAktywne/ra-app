import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/ra_links.dart';

MediaItem getInitialRadioMediaItem(BuildContext context) => MediaItem(
      id: Uri.https(RaRadio.baseUrl, RaRadio.radioStream).toString(),
      title: context.l10n.noStreamTitle,
      album: context.l10n.noStreamTitle,
      artUri: Uri.parse(RaApi.logoUrl),
    );

enum MediaKind {
  radio,
  recording;

  String toL10nString(BuildContext context) => switch (this) {
        radio => context.l10n.radio,
        recording => context.l10n.recording,
      };
}

enum PlayerKind {
  widget,
  page;

  PlayerKind get opposite => switch (this) {
        widget => page,
        page => widget,
      };
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });

  final Duration current;
  final Duration buffered;
  final Duration total;
}
