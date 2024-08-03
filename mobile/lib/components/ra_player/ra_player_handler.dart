import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';
import 'package:radioaktywne/components/ra_player/stream_title_workaround.dart';

/// An [AudioHandler] for playing a single item.
class RaPlayerHandler extends BaseAudioHandler with SeekHandler {
  /// Initialise the audio handler.
  RaPlayerHandler({
    required MediaItem mediaItem,
  })  : _mediaItem = mediaItem,
        _player = AudioPlayer(),
        streamTitleWorkaround = StreamTitleWorkaround() {
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    // ... and also the current media item via mediaItem.
    this.mediaItem.add(_mediaItem);

    // Change stream title and subtitle based on IcyMetadata
    _player.icyMetadataStream.listen((event) {
      final streamName = event?.headers?.name ?? '';
      final streamTitle = event?.info?.title ?? '';
      if (kDebugMode) {
        print('stream name: $streamName');
        print('stream title: $streamTitle');
      }

      var mediaItemValue = this.mediaItem.value ?? _mediaItem;
      if (streamName.isNotEmpty) {
        mediaItemValue = mediaItemValue.copyWith(
          album: streamName,
        );
      }
      if (streamTitle.isNotEmpty) {
        mediaItemValue = mediaItemValue.copyWith(
          title: streamTitle,
        );
      }
      this.mediaItem.add(mediaItemValue);
    });

    _player.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position == Duration.zero && oldState.current > position
            ? oldState.current
            : position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _player.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _player.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? oldState.total,
      );
    });

    /// Listening for stream title changes
    streamTitleWorkaround.stream.listen((streamTitle) {
      final previousTitle = this.mediaItem.value?.title;
      if (streamTitle == previousTitle) {
        return;
      }

      final mediaItemValue = this.mediaItem.value ?? _mediaItem;
      this.mediaItem.add(mediaItemValue.copyWith(title: streamTitle));
    });
  }

  MediaItem _mediaItem;

  MediaKind get mediaKind =>
      _mediaItem.extras?[RaPlayerConstants.mediaKind] as MediaKind? ??
      MediaKind.radio;

  Duration get duration =>
      _mediaItem.extras?[RaPlayerConstants.seek] as Duration? ?? Duration.zero;

  final AudioPlayer _player;

  /// Workaround for stream title fetching
  final StreamTitleWorkaround streamTitleWorkaround;

  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );

  /// export icyMetadata (may become handy at some point)
  // Stream<IcyMetadata?> get icyMetadata => _player.icyMetadataStream;

  // We handle 4 actions: play, pause, seek and stop. Any button press from the
  // Flutter UI, notification, lock screen or headset will be routed through to
  // these 4 methods so that we can handle audio playback logic in one place.

  void _updateRecordingPosition() {
    if (mediaKind == MediaKind.recording) {
      _mediaItem.extras
          ?.update(RaPlayerConstants.seek, (_) => _player.position);
    }
  }

  Future<void> _startAction() async {
    switch (mediaKind) {
      case MediaKind.radio:
        streamTitleWorkaround.playerStarted();
      case MediaKind.recording:
        final currentPosition = duration;
        await _player.seek(
          currentPosition >= (_mediaItem.duration ?? Duration.zero)
              ? Duration.zero
              : currentPosition,
        );
        streamTitleWorkaround.playerStopped();
    }
  }

  @override
  Future<void> play() async {
    // Forces player to start playing live when 'play' is pressed. Otherwise,
    // when user would press 'play' for the first time, he would hear the
    // stream starting from the moment he launched the app, not when he pressed
    // 'play'.
    await _player.setAudioSource(AudioSource.uri(Uri.parse(_mediaItem.id)));
    await _startAction();
    return _player.play();
  }

  @override
  Future<void> pause() async {
    streamTitleWorkaround.playerStopped();
    _updateRecordingPosition();
    return _player.pause();
  }

  @override
  Future<void> stop() async {
    streamTitleWorkaround.playerStopped();
    _updateRecordingPosition();
    return _player.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    return _player.seek(position);
  }

  @override
  Future<void> updateMediaItem(MediaItem mediaItem) async {
    this.mediaItem.add(mediaItem);
    _mediaItem = mediaItem;
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    await updateMediaItem(mediaItem);
    await play();
  }

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        // MediaControl.rewind,
        if (mediaKind == MediaKind.recording)
          if (_player.playing) MediaControl.pause else MediaControl.play,
        // MediaControl.stop,
        // MediaControl.fastForward,
        if (_player.playing) MediaControl.stop else MediaControl.play,
      ],
      systemActions: {
        if (mediaKind == MediaKind.recording) MediaAction.seek,
      },
      androidCompactActionIndices: const [0],
      processingState: switch (_player.processingState) {
        ProcessingState.idle => AudioProcessingState.idle,
        ProcessingState.loading => AudioProcessingState.loading,
        ProcessingState.buffering => AudioProcessingState.buffering,
        ProcessingState.ready => AudioProcessingState.ready,
        ProcessingState.completed => AudioProcessingState.completed,
      },
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
