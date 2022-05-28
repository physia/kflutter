library kplayer_with_just_audio;

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:kplayer_platform_interface/kplayer_platform_interface.dart';

class JustAudioBytesSource extends just_audio.StreamAudioSource {
  final Uint8List _buffer;

  JustAudioBytesSource(this._buffer) : super(tag: 'MyAudioSource');

  @override
  Future<just_audio.StreamAudioResponse> request([int? start, int? end]) async {
    // Returning the stream audio response with the parameters
    return just_audio.StreamAudioResponse(
      sourceLength: _buffer.length,
      contentLength: (start ?? 0) - (end ?? _buffer.length),
      offset: start ?? 0,
      stream: Stream.fromIterable([_buffer.sublist(start ?? 0, end)]),
      contentType: 'audio/wav',
    );
  }
}

class JustAudioStreamSource extends just_audio.StreamAudioSource {
  final Stream<List<int>> _stream;
  final int _length;

  JustAudioStreamSource(this._stream, this._length)
      : super(tag: 'MyAudioSource');

  @override
  Future<just_audio.StreamAudioResponse> request([int? start, int? end]) async {
    return just_audio.StreamAudioResponse(
      sourceLength: _length,
      contentLength: (start ?? 0) - (end ?? _length),
      offset: start ?? 0,
      stream: _stream,
      contentType: 'audio/wav',
    );
  }
}

class Player extends PlayerController {
  Player({
    int? id,
    required super.media,
    bool? autoPlay,
    bool? once,
    bool? loop,
  })  : player = just_audio.AudioPlayer(),
        super(
            autoPlay: autoPlay ?? false,
            once: once ?? false,
            loop: loop ?? false) {
    players.add(this);
  }

  final just_audio.AudioPlayer player;
  @override
  get package => "just_audio";

  @override
  Stream<Duration> get positionStream => player.positionStream;
  PlayerStatus _status = PlayerStatus.loading;
  @override
  PlayerStatus get status => _status;

  @override
  bool get playing => status == PlayerStatus.playing;

  @override
  set status(PlayerStatus status) {
    _status = status;
    notify(PlayerEvent.status);
  }

  @override
  Duration get duration => player.duration ?? Duration.zero;

  @override
  Duration get position => _position;

  static List<PlayerController> get players => PlayerController.palyers;

  @override
  void init() async {
    super.init();
    if (media.type == PlayerMediaType.asset) {
      await player.setAsset(
        media.resource,
        initialPosition: media.initial,
        preload: media.preload,
      );
    } else if (media.type == PlayerMediaType.network) {
      await player.setUrl(
        media.resource,
        headers: media.headers,
        initialPosition: media.initial,
        preload: media.preload,
      );
    } else if (media.type == PlayerMediaType.file) {
      await player.setFilePath(
        media.resource,
        initialPosition: media.initial,
        preload: media.preload,
      );
      // } else if (media.type == PlayerMediaType.stream) {
      //   await player.setAudioSource(JustAudioStreamSource(media.resource, 900));
      // } else if (media.type == PlayerMediaType.bytes) {
      //   await player.setAudioSource(JustAudioBytesSource(media.resource));
    } else {
      throw Exception("Unsupported media type");
    }
    // player.speedStream.listen((speed) {
    //   speed = speed;
    // });
    // player.volumeStream.listen((volume) {
    //   volume = volume;
    // });
    player.positionStream.listen((positionValue) {
      _position = positionValue;
      notify(PlayerEvent.position);
    });
    player.playerStateStream.listen((pstate) {
      switch (pstate.processingState) {
        // case just_audio.ProcessingState.ready:
        //   status = PlayerStatus.playing;
        //   break;
        // case just_audio.ProcessingState.loading:
        //   status = PlayerStatus.loading;
        //   break;
        // case just_audio.ProcessingState.buffering:
        //   status = PlayerStatus.buffering;
        //   break;
        case just_audio.ProcessingState.completed:
          status = PlayerStatus.ended;
          break;
        default:
        // status = PlayerStatus.unknown;
      }
    });
    players.add(this);
    if (autoPlay) {
      play();
    }
    if (once) {
      player.playerStateStream.listen((event) {
        if (event.processingState == just_audio.ProcessingState.completed) {
          dispose();
        }
      });
    }
    notify(PlayerEvent.init);
  }

  @override
  void play() {
    if (status == PlayerStatus.ended) {
      seek(Duration.zero);
    }
    if (!playing) {
      player.play();
      status = PlayerStatus.playing;
      notify(PlayerEvent.play);
    }
  }

  @override
  void replay() {
    seek(Duration.zero);
    play();
    notify(PlayerEvent.replay);
  }

  @override
  void pause() {
    player.pause();
    status = PlayerStatus.paused;
  }

  @override
  void stop() {
    player.stop();
    notify(PlayerEvent.stop);
  }

  @override
  void toggle() {
    playing ? pause() : play();
    notify(PlayerEvent.toggle);
  }

  @override
  void dispose() async {
    await player.dispose();
    notify(PlayerEvent.dispose);
    super.dispose();
  }

  //
  static void boot() {
    debugPrint("Kplayer: just_audio");
  }

  Duration _position = Duration.zero;
  // Duration _duration = Duration.zero;
  double _volume = 1;
  double _speed = 1;
  bool _loop = false;

  @override
  double get speed => _speed;

  @override
  set speed(double speed) {
    player.setSpeed(_speed = speed);
    notify(PlayerEvent.speed);
  }

  @override
  double get volume => _volume;

  @override
  set volume(double volume) {
    player.setVolume(_volume = volume);
    notify(PlayerEvent.volume);
  }

  @override
  bool get loop => _loop;

  @override
  set loop(bool loop) {
    _loop = loop;
    player
        .setLoopMode(loop ? just_audio.LoopMode.all : just_audio.LoopMode.off);
    notify(PlayerEvent.volume);
  }

  @override
  set position(Duration position) {
    seek(_position = position);
    notify(PlayerEvent.position);
  }

  @override
  void seek(Duration position) {
    player.seek(_position = position);
    notify(PlayerEvent.position);
  }

  /// create instance adapted on platform
  /// ```dart
  /// var media = PlayerMedia.asset(assets/file.mp3);
  /// Player.create(id: 1, media: media, autoPlay: false, once: false)
  ///   ..init();
  /// player.play();
  /// ```
  static PlayerController create({
    int? id,
    required PlayerMedia media,
    bool? autoPlay,
    bool? once,
    bool? loop,
  }) {
    return Player(
      id: id,
      media: media,
      autoPlay: autoPlay,
      once: once,
      loop: loop,
    );
  }

  /// create assets instance
  /// ```dart
  /// var player = Player.asset("assets/file.mp3");
  /// player.play();
  /// ```
  static PlayerController asset(String media,
      {int? id, bool? autoPlay = true, bool? once}) {
    return Player.create(
        id: id, media: PlayerMedia.asset(media), autoPlay: autoPlay, once: once)
      ..init();
  }

  /// create network instance
  /// ```dart
  /// var player = Player.network("https://example.com/file.mp3");
  /// player.play();
  /// ```
  static PlayerController network(String media,
      {int? id, bool? autoPlay = true, bool? once}) {
    return Player.create(
        id: id,
        media: PlayerMedia.network(media),
        autoPlay: autoPlay,
        once: once)
      ..init();
  }

  /// create file instance
  /// ```dart
  /// var player = Player.file("/path/to/file.mp3");
  /// player.play();
  /// ```
  static PlayerController file(String media,
      {int? id, bool? autoPlay = true, bool? once}) {
    return Player.create(
        id: id, media: PlayerMedia.file(media), autoPlay: autoPlay, once: once)
      ..init();
  }

  /// create file instance
  /// ```dart
  /// var player = Player.file("/path/to/file.mp3");
  /// player.play();
  /// ```
  static PlayerController bytes(Uint8List media,
      {int? id, bool? autoPlay = true, bool? once}) {
    return Player.create(
        id: id, media: PlayerMedia.bytes(media), autoPlay: autoPlay, once: once)
      ..init();
  }

  /// create file instance
  /// ```dart
  /// var player = Player.file("/path/to/file.mp3");
  /// player.play();
  /// ```
  static PlayerController stream(Stream media,
      {int? id, bool? autoPlay = true, bool? once}) {
    return Player.create(
        id: id,
        media: PlayerMedia.stream(media),
        autoPlay: autoPlay,
        once: once)
      ..init();
  }
}
