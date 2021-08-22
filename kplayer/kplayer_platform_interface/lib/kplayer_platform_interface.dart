library kplayer_platform_interface;

import 'package:flutter/cupertino.dart';

/// a Player Statuses enum
enum PlayerEvent {
  /// on created.
  create,

  /// on initialized.
  init,

  /// on started.
  start,

  /// on restarted.
  restart,

  /// on playing.
  play,

  /// on paused.
  pause,

  /// on stopped.
  stop,

  /// on ended.
  end,

  /// unknown event. if you get this, probably something wrong
  unknown,
}

/// a Player Statuses enum
enum PlayerStatus {
  created,
  inited,
  playing,
  paused,
  stopped,
  ended,
  unknown,
}

/// a Player Media Types enum
enum PlayerMediaType {
  asset,
  network,
  file,
}

// Object handle Player media resources
class PlayerMedia {
  PlayerMedia(this.type, this.resource);

  final PlayerMediaType type;
  final String resource;

  factory PlayerMedia.asset(String _resource) {
    return PlayerMedia(PlayerMediaType.asset, _resource);
  }
  factory PlayerMedia.network(String _resource) {
    return PlayerMedia(PlayerMediaType.network, _resource);
  }
  factory PlayerMedia.file(String _resource) {
    return PlayerMedia(PlayerMediaType.file, _resource);
  }
}

/// the player interface
///
/// the interface apis
abstract class PlayerPlatform {
  PlayerPlatform(
      {int? id,
      required this.media,
      this.autoPlay = false,
      this.once = false,
      this.loop = false,});
  
  // i know hhh
  // static bool _booted = false;
  // void needBoot(Function bootCallback) {
  //   if (!PlayerPlatform._booted) {
  //     bootCallback();
  //   }
  // }

  static create(
      {int? id,
      required PlayerMedia media,
      bool? autoPlay,
      bool? once,
      bool? loop}) {}

  factory PlayerPlatform.assets(media,
      {int? id, required bool autoPlay, bool? once}) {
    return PlayerPlatform.create(
        id: id, media: PlayerMedia.asset(media), autoPlay: autoPlay, once: once)
      ..init();
  }

  factory PlayerPlatform.network(media,
      {int? id, required bool autoPlay, bool? once}) {
    return PlayerPlatform.create(
        id: id,
        media: PlayerMedia.network(media),
        autoPlay: autoPlay,
        once: once)
      ..init();
  }

  @required
  static void boot() {}

  final bool autoPlay;
  final bool once;
  final bool loop;
  final PlayerMedia media;
  

  static List<PlayerPlatform> palyers = <PlayerPlatform>[];
  void init();
  void replay();
  void play();
  void pause();
  void stop();
  @Deprecated("use position setter")
  void seek(Duration position);
  void toggle();
  void dispose();
  VoidCallback callback = (){};

  get package;
  bool get playing;
  Duration get position;
  Duration get duration;
  double get volume;
  double get speed;
  PlayerStatus get status;
  Stream<Duration> get positionStream;

  set volume(double volume);
  set speed(double rate);
  set position(Duration position);
}
