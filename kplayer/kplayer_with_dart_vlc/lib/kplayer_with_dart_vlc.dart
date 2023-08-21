library kplayer_with_dart_vlc;


import "fake_io.dart" if (dart.library.io) 'dart:io';

import "fake_dart_vlc.dart" if (dart.library.ffi) 'package:dart_vlc/dart_vlc.dart' as dart_vlc;
import 'package:flutter/foundation.dart';
import 'package:kplayer_platform_interface/kplayer_platform_interface.dart';

class Player extends PlayerController {
  Player({
    int? id,
    required PlayerMedia media,
    bool? autoPlay,
    bool? once,
    bool? loop,
  })  : player = dart_vlc.Player(id: id ?? players.length + 50001),
        super(media: media, autoPlay: autoPlay ?? false, once: once ?? false, loop: loop ?? false) {
    players.add(this);
  }

  final dart_vlc.Player player;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 1;
  bool _loop = false;
  double _speed = 1;

  @override
  get package => "dart_vlc";

  PlayerStatus _status = PlayerStatus.loading;
  @override
  PlayerStatus get status => _status;

  @override
  set status(PlayerStatus status) {
    notify(PlayerEvent.status);
    _status = status;
  }

  @override
  bool get playing => _status == PlayerStatus.playing;

  @override
  Duration get duration => _duration;

  @override
  Duration get position => _position;

  static List<PlayerController> get players => PlayerController.players;

  @override
  void init() {
    notify(PlayerEvent.init);
    // needBoot((){
    //   Player.boot();
    //   print("Player.boot");
    // });
    dart_vlc.Media vlcMedia;
    if (media.type == PlayerMediaType.network) {
      vlcMedia = dart_vlc.Media.network(media.resource);
    } else if (media.type == PlayerMediaType.asset) {
      vlcMedia = dart_vlc.Media.asset(media.resource);
    } else if (media.type == PlayerMediaType.file) {
      vlcMedia = dart_vlc.Media.file(File(media.resource));
    } else {
      throw Exception("media type not support");
    }

    player.open(vlcMedia, autoStart: false);
    players.add(this);
    subscriptions.addAll([
      player.positionStream.listen((dart_vlc.PositionState state) {
        _position = state.position ?? _position;
        _duration = state.duration ?? _duration;
        notify(PlayerEvent.position);
      }),
      player.playbackStream.listen((state) {
        if (state.isCompleted) {
          status = PlayerStatus.ended;
          // if loop is true, then restart the video
          if (loop) {
            replay();
          }
        }
      }),
      player.generalStream.listen((dart_vlc.GeneralState state) {
        _volume = state.volume;
        _speed = state.rate;
      }),
    ]);

    if (autoPlay) {
      play();
    }
    super.init();
  }

  @override
  void play() {
    notify(PlayerEvent.play);
    if (!playing) {
      _status = PlayerStatus.playing;
      player.play();
      if (once) {
        player.playbackStream.listen((event) {
          if (event.isCompleted) {
            dispose();
          }
        });
      }
    }
  }

  @override
  void replay() {
    seek(Duration.zero);
    notify(PlayerEvent.replay);
    play();
  }

  @override
  Future<void> pause() async {
    _status = PlayerStatus.paused;
    player.pause();
    notify(PlayerEvent.pause);
  }

  @override
  void stop() {
    _status = PlayerStatus.stopped;
    player.stop();
    notify(PlayerEvent.stop);
  }

  @override
  void seek(Duration position) {
    player.seek(position);
    notify(PlayerEvent.position);
  }

  @override
  void toggle() {
    _status == PlayerStatus.playing ? pause() : play();
    notify(PlayerEvent.toggle);
  }

  @override
  void dispose() {
    notify(PlayerEvent.dispose);
    super.dispose();
    player.dispose();
  }

  //
  static void boot() {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      dart_vlc.DartVLC.initialize();
    }
  }

  @override
  Stream<Duration> get positionStream => player.positionStream.map((event) => event.position ?? Duration.zero);
  @override
  double get speed => _speed;

  @override
  set speed(double speed) {
    player.setRate(speed);
    notify(PlayerEvent.speed);
  }

  @override
  double get volume => _volume;

  @override
  set volume(double volume) {
    player.setVolume(volume);
    notify(PlayerEvent.volume);
  }

  @override
  bool get loop => _loop;

  @override
  set loop(bool loop) {
    _loop = loop;
    notify(PlayerEvent.loop);
  }

  @override
  set position(Duration position) {
    seek(position);
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
  static PlayerController asset(String media, {int? id, bool? autoPlay = true, bool? once}) {
    return Player.create(id: id, media: PlayerMedia.asset(media), autoPlay: autoPlay, once: once)..init();
  }

  /// create network instance
  /// ```dart
  /// var player = Player.network("https://example.com/file.mp3");
  /// player.play();
  /// ```
  static PlayerController network(String media, {int? id, bool? autoPlay = true, bool? once}) {
    return Player.create(id: id, media: PlayerMedia.network(media), autoPlay: autoPlay, once: once)..init();
  }

  /// create file instance
  /// ```dart
  /// var player = Player.file("/path/to/file.mp3");
  /// player.play();
  /// ```
  static PlayerController file(String media, {int? id, bool? autoPlay = true, bool? once}) {
    return Player.create(id: id, media: PlayerMedia.file(media), autoPlay: autoPlay, once: once)..init();
  }

  /// create file instance
  /// ```dart
  /// var player = Player.file("/path/to/file.mp3");
  /// player.play();
  /// ```
  static PlayerController bytes(Uint8List media, {int? id, bool? autoPlay = true, bool? once}) {
    return Player.create(id: id, media: PlayerMedia.bytes(media), autoPlay: autoPlay, once: once)..init();
  }

  /// create file instance
  /// ```dart
  /// var player = Player.file("/path/to/file.mp3");
  /// player.play();
  /// ```
  static PlayerController stream(Stream media, {int? id, bool? autoPlay = true, bool? once}) {
    return Player.create(id: id, media: PlayerMedia.stream(media), autoPlay: autoPlay, once: once)..init();
  }
}
