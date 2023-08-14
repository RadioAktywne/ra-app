
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radioaktywne/components/radio_player/stream_title_workaround.dart';

/// An [AudioHandler] for playing a single item.
class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  /// Initialise the audio handler.
  AudioPlayerHandler() {
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    // ... and also the current media item via mediaItem.
    mediaItem.add(_item);

    // Load the player.
    _player.setAudioSource(AudioSource.uri(Uri.parse(_item.id)));

    // Change stream title and subtitle based on IcyMetadata
    _player.icyMetadataStream.listen((event) {
      final streamName = event?.headers?.name ?? '';
      final streamTitle = event?.info?.title ?? '';
      if (kDebugMode) {
        print('stream name: $streamName');
        print('stream title: $streamTitle');
      }

      var mediaItemValue = mediaItem.value ??
          const MediaItem(
            id: 'https://listen.radioaktywne.pl:8443/raogg',
            title: 'Stream title not provided', // TODO: zmienić na 'Radio Aktywne'
            album: 'Stream name not provided', // TODO: zmienić na 'Radio Aktywne'
          );
      if (streamName.isNotEmpty) {
        mediaItemValue = mediaItemValue.copyWith(
          album: streamName,
          // album: streamName.isNotEmpty
          //     ? streamName
          //     : 'Stream name not provided',
        );
      }
      if (streamTitle.isNotEmpty) {
        mediaItemValue = mediaItemValue.copyWith(
          title: streamTitle,
          // title: streamTitle.isNotEmpty
          //     ? streamTitle
          //     : 'Stream title not provided',
        );
      }
      mediaItem.add(mediaItemValue);
    });

    /// Listening for stream title changes
    streamTitleWorkaround.stream.listen((streamTitle) {
      final previousTitle = mediaItem.value?.title;
      if (streamTitle == previousTitle) {
        return;
      }

      final mediaItemValue = mediaItem.value ??
          const MediaItem(
            id: 'https://listen.radioaktywne.pl:8443/raogg',
            title: '',
          );

      mediaItem.add(mediaItemValue.copyWith(title: streamTitle));
    });
  }

  static final _item = MediaItem(
    id: 'https://listen.radioaktywne.pl:8443/raogg',
    title: 'Radio Aktywne',
    album: 'Radio Aktywne',
    artUri: Uri.parse(
      'https://radioaktywne.pl/static/images/studio-d3cb8ada0833489ee904fff9987e2b03.jpg',
    ),
  );

  final _player = AudioPlayer();

  /// Workaround for stream title fetching
  final streamTitleWorkaround = StreamTitleWorkaround();

  /// export icyMetadata (may become handy at some point)
  // Stream<IcyMetadata?> get icyMetadata => _player.icyMetadataStream;

  // In this simple example, we handle only 4 actions: play, pause, seek and
  // stop. Any button press from the Flutter UI, notification, lock screen or
  // headset will be routed through to these 4 methods so that you can handle
  // your audio playback logic in one place.

  @override
  Future<void> play() {
    streamTitleWorkaround.playerStarted();
    return _player.play();
  }

  @override
  Future<void> pause() {
    streamTitleWorkaround.playerStopped();
    return _player.pause();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() {
    streamTitleWorkaround.playerStopped();
    return _player.stop();
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
        // if (_player.playing) MediaControl.pause else MediaControl.play,
        // MediaControl.stop,
        // MediaControl.fastForward,
        if (_player.playing) MediaControl.stop else MediaControl.play,
      ],
      // systemActions: const {
      //   MediaAction.seek,
      //   MediaAction.seekForward,
      //   MediaAction.seekBackward,
      // },
      androidCompactActionIndices: const [0],

      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
