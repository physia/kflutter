library kplayer_with_dart_vlc;

import 'dart:io';

import "fake_dart_vlc.dart"
    if (dart.library.ffi) 'package:dart_vlc/dart_vlc.dart' as dart_vlc;

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
        super(
            media: media,
            autoPlay: autoPlay ?? false,
            once: once ?? false,
            loop: loop ?? false) {
    players.add(this);
  }

  final dart_vlc.Player player;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 1;
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

  static List<PlayerController> get players => PlayerController.palyers;
  @override
  void init() {
    notify(PlayerEvent.init);
    // needBoot((){
    //   Player.boot();
    //   print("Player.boot");
    // });
    var _vlcMedia = media.type == PlayerMediaType.asset
        ? dart_vlc.Media.asset(media.resource)
        : dart_vlc.Media.network(media.resource);
    player.open(_vlcMedia, autoStart: autoPlay);
    players.add(this);

    player.positionStream.listen((dart_vlc.PositionState _state) {
      _position = _state.position ?? _position;
      _duration = _state.duration ?? _duration;
      notify(PlayerEvent.position);
    });
    player.playbackStream.listen((state) {
      if (state.isCompleted) {
        status = PlayerStatus.ended;
      }
    });
    player.generalStream.listen((dart_vlc.GeneralState _state) {
      _volume = _state.volume;
      _speed = _state.rate;
    });
    
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
  void pause() {
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
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      dart_vlc.DartVLC.initialize();
    }
  }

  @override
  Stream<Duration> get positionStream =>
      player.positionStream.map((event) => event.position ?? Duration.zero);
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
  set position(Duration position) {
    seek(position);
    notify(PlayerEvent.position);
  }

}
