library kplayer_with_dart_vlc;

import 'dart:io';

import "fake_dart_vlc.dart"
    if (dart.library.ffi) 'package:dart_vlc/dart_vlc.dart' as dart_vlc;
import 'package:flutter/foundation.dart';
import 'package:kplayer_platform_interface/kplayer_platform_interface.dart';

class Player extends PlayerPlatform {
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

  PlayerStatus _status = PlayerStatus.created;
  @override
  PlayerStatus get status => _status;

  @override
  bool get playing => _status == PlayerStatus.playing;

  @override
  Duration get duration => _duration;

  @override
  Duration get position => _position;

  static List<PlayerPlatform> get players => PlayerPlatform.palyers;
  @override
  void init() {
    // needBoot((){
    //   Player.boot();
    //   print("Player.boot");
    // });
    var _vlcMedia = media.type == PlayerMediaType.asset
        ? dart_vlc.Media.asset(media.resource)
        : dart_vlc.Media.network(media.resource);
    player.open(_vlcMedia, autoStart: autoPlay);
    _status = PlayerStatus.created;
    players.add(this);

    player.positionStream.listen((dart_vlc.PositionState _state) {
      _position = _state.position ?? _position;
      _duration = _state.duration ?? _duration;
    });
    player.generalStream.listen((dart_vlc.GeneralState _state) {
      _volume = _state.volume;
      _speed = _state.rate;
    });
  }

  @override
  void play() {
    _notify();
    if (_status != PlayerStatus.playing) {
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
    play();
  }

  @override
  void pause() {
    _notify();
    _status = PlayerStatus.paused;
    player.pause();
  }

  @override
  void stop() {
    _notify();
    _status = PlayerStatus.stopped;
    player.stop();
  }

  @override
  void seek(Duration position) {
    _notify();
    player.seek(position);
  }

  @override
  void toggle() {
    _status == PlayerStatus.playing ? pause() : play();
  }

  @override
  void dispose() {
    _notify();
    player.dispose();
  }

  @override
  static void boot() {
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      dart_vlc.DartVLC.initialize();
    }
  }

  @override
  Stream<Duration> get positionStream => player.positionStream.map((event) => event.position ?? Duration.zero);
  @override
  double get speed => _speed;

  @override
  set speed(double speed) {
    _notify();
    player.setRate(speed);
  }

  @override
  double get volume => _volume;

  @override
  set volume(double volume) {
    _notify();
    player.setVolume(volume);
  }

  @override
  set position(Duration position) {
    seek(position);
  }

  void _notify() {
    callback();
  }
}
