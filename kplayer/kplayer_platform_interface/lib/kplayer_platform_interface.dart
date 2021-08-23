library kplayer_platform_interface;

import 'dart:async';
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
  /// on replay.
  replay,
  /// on paused.
  pause,
  /// on toggle.
  toggle,
  /// on stopped.
  stop,
  /// on volume changed.
  volume,
  /// on speed changed.
  speed,
  /// on status changed.
  status,
  /// on position changed.
  position,
  /// on position changed, just in case idk
  duration,
  /// on dispose.
  dispose,
  /// on ended.
  end,
  /// unknown event. if you get this, probably something wrong
  unknown,
}

/// a Player Statuses enum
enum PlayerStatus {
  created,
  inited,
  ready,
  loading,
  buffering,
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
  PlayerPlatform({
    int? id,
    required this.media,
    this.autoPlay = false,
    this.once = false,
    this.loop = false,
  });

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
  @Deprecated("use the position setter")
  void seek(Duration position);
  void toggle();
  Function(PlayerEvent) callback = (PlayerEvent event){
    print("$event");
  };

  get package;
  bool get playing;
  Duration get position;
   set position(Duration duration);
  Duration get duration;
  double get volume;
   set volume(double volume);
  double get speed;
   set speed(double speed);
  PlayerStatus get status;
  set status(PlayerStatus status);

  @Deprecated('Use `streams.position` instead.')
  Stream<Duration> get positionStream;
  PlayerStreams streams = PlayerStreams();

  void dispose(){
    streams.dispose();
  }

  void notify(PlayerEvent event) {
    streams.status.add(status);
    streams.playing.add(playing);
    switch (event) {
      case PlayerEvent.position:
        streams.position.add(position);
        break;
      case PlayerEvent.duration:
        streams.duration.add(duration);
        break;
      case PlayerEvent.volume:
        streams.volume.add(volume);
        break;
      case PlayerEvent.speed:
        streams.speed.add(speed);
        break;
      default:
    }
    callback(event);
  }

}
/// All streams to for state managment
class PlayerStreams {

  StreamController<bool> playing = StreamController.broadcast();
  StreamController<Duration> position = StreamController.broadcast();
  StreamController<Duration> duration = StreamController.broadcast();
  StreamController<double> volume = StreamController.broadcast();
  StreamController<double> speed = StreamController.broadcast();
  StreamController<PlayerStatus> status = StreamController.broadcast();

  void dispose() {
    playing.close();
    position.close();
    duration.close();
    volume.close();
    speed.close();
    status.close();
  }

}

class PlayerValue {
  final bool playing;
  final Duration position;
  final Duration duration;
  final double volume;
  final double speed;
  final PlayerStatus status;

  PlayerValue(
      {required this.playing,
      required this.position,
      required this.duration,
      required this.volume,
      required this.speed,
      required this.status});
}
