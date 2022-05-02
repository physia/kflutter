library kplayer_platform_interface;

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
export 'widgets.dart';

/// a Player Statuses enum
enum PlayerEvent {
  /// on load.
  load,

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

  /// on loop status changes.
  loop,

  /// unknown event. if you get this, probably something wrong
  unknown,
}

/// a Player Statuses enum
enum PlayerStatus {
  // created,
  // inited,
  // ready,
  loading,
  buffering,
  playing,
  paused,
  stopped,
  ended,
  // unknown,
}

/// a Player Media Types enum
enum PlayerMediaType {
  asset,
  network,
  file,
  bytes,
  stream,
}

// Object handle Player media resources
class PlayerMedia<T> {
  PlayerMedia(
      {required this.type,
      required this.resource,
      this.headers,
      this.initial,
      this.preload = false});

  final PlayerMediaType type;
  final T resource;
  final Map<String, String>? headers;
  final Duration? initial;
  final bool preload;

  static PlayerMedia<String> asset(String _resource,
      {Duration? initial, bool? preload}) {
    return PlayerMedia(
      type: PlayerMediaType.asset,
      resource: _resource,
      preload: preload ?? false,
      initial: initial,
    );
  }

  static PlayerMedia<String> network(String _resource,
      {Map<String, String>? headers, Duration? initial, bool? preload}) {
    return PlayerMedia(
      type: PlayerMediaType.network,
      resource: _resource,
      headers: headers,
      preload: preload ?? false,
      initial: initial,
    );
  }

  static PlayerMedia<String> file(String _resource,
      {Duration? initial, bool? preload}) {
    return PlayerMedia(
      type: PlayerMediaType.file,
      resource: _resource,
      preload: preload ?? false,
      initial: initial,
    );
  }

  static PlayerMedia<Uint8List> bytes(Uint8List _resource,
      {Duration? initial, bool? preload}) {
    return PlayerMedia(
      type: PlayerMediaType.bytes,
      resource: _resource,
      preload: preload ?? false,
      initial: initial,
    );
  }

  static PlayerMedia<Stream> stream(Stream _resource,
      {Duration? initial, bool? preload}) {
    return PlayerMedia(
      type: PlayerMediaType.stream,
      resource: _resource,
      preload: preload ?? false,
      initial: initial,
    );
  }
}

/// the player interface
///
/// the interface apis
abstract class PlayerController {
  // static config
  static bool enableLog = true;
  PlayerController({
    int? id,
    required this.media,
    this.autoPlay = false,
    this.once = false,
    bool loop = false,
  }) : _loop = loop;

  // i know hhh
  // static bool _booted = false;
  // void needBoot(Function bootCallback) {
  //   if (!PlayerController._booted) {
  //     bootCallback();
  //   }
  // }
  // list of th StreamSubscription for dispose automatically
  List<StreamSubscription> subscriptions = [];
  static create(
      {int? id,
      required PlayerMedia media,
      bool? autoPlay,
      bool? once,
      bool? loop}) {}

  factory PlayerController.assets(media,
      {int? id, required bool autoPlay, bool? once}) {
    return PlayerController.create(
        id: id, media: PlayerMedia.asset(media), autoPlay: autoPlay, once: once)
      ..init();
  }

  factory PlayerController.network(media,
      {int? id, required bool autoPlay, bool? once}) {
    return PlayerController.create(
        id: id,
        media: PlayerMedia.network(media),
        autoPlay: autoPlay,
        once: once)
      ..init();
  }
  //
  // bool _ready = false;
  bool get ready => duration != Duration.zero;
  bool _created = false;
  bool get created => _created || inited;
  bool _loading = false;
  bool get loading => _loading;
  bool _inited = false;
  bool get inited => _inited;
  bool _disposed = false;
  bool get disposed => _disposed;
  bool _ended = false;
  bool get ended => _ended;

  static void boot() {}

  final bool autoPlay;
  final bool once;
  bool _loop;
  final PlayerMedia media;

  // static functions
  // the method durationToString is used to convert duration to string and show it on the UI
  static String durationToString(Duration duration) {
    List<String> blocks = [];
    String twoDigits(int n) {
      if (n >= 10) {
        return n.toString().substring(0, 2);
      }
      return "0$n";
    }

    if (duration.inHours > 0) {
      blocks.add(twoDigits(duration.inHours));
    }

    if (duration.inMinutes > 0) {
      blocks.add(twoDigits(duration.inMinutes));
    } else {
      blocks.add("00");
    }

    if (duration.inSeconds > 0) {
      blocks.add(twoDigits(duration.inSeconds));
    } else {
      blocks.add("00");
    }

    return blocks.join(":");
  }

  static List<PlayerController> palyers = <PlayerController>[];
  // @mustCallSuper
  void init() {
    // streams.duration.listen((event) {
    //   if(event != Duration.zero && !_ready){
    //     _ready=true;
    //   }
    // });
  }
  void replay();
  void play();
  void pause();
  void stop();
  @Deprecated("use the position setter")
  void seek(Duration position);
  void toggle();
  // ignore: prefer_function_declarations_over_variables
  Function(PlayerEvent) callback = (PlayerEvent event) {
    if (enableLog) {
      debugPrint("$event");
    }
  };

  String get package;
  bool get playing;
  Duration get position;
  set position(Duration duration);
  Duration get duration;
  double get volume;
  set volume(double volume);
  double get speed;
  set speed(double speed);
  bool get loop;
  set loop(bool speed);
  PlayerStatus get status;
  set status(PlayerStatus status);

  @Deprecated('Use `streams.position` instead.')
  Stream<Duration> get positionStream => streams.position;

  final PlayerStreamControllers _streamControllers = PlayerStreamControllers();
  PlayerStreams get streams => _streamControllers.streams;

  void dispose() {
    _streamControllers.dispose();
    for (var subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
    _disposed = true;
  }

  void notify(PlayerEvent event) {
    _streamControllers.status.add(status);
    _streamControllers.playing.add(playing);
    switch (event) {
      case PlayerEvent.position:
        _streamControllers.position.add(position);
        break;
      case PlayerEvent.duration:
        _streamControllers.duration.add(duration);
        break;
      case PlayerEvent.volume:
        _streamControllers.volume.add(volume);
        break;
      case PlayerEvent.speed:
        _streamControllers.speed.add(speed);
        break;
      case PlayerEvent.loop:
        _streamControllers.loop.add(loop);
        break;
      case PlayerEvent.create:
        _created = true;
        break;
      case PlayerEvent.init:
        _inited = true;
        break;
      case PlayerEvent.dispose:
        _disposed = true;
        break;
      case PlayerEvent.end:
        _ended = true;
        if (loop) {
          replay();
        }
        if (once) {
          dispose();
        }
        break;
      default:
    }

    callback(event);
  }
}

/// All streams to for state managment
class PlayerStreams {
  final PlayerStreamControllers playerStreamControllers;
  PlayerStreams(this.playerStreamControllers);

  Stream<bool> get playing => playerStreamControllers.playing.stream;
  Stream<Duration> get position => playerStreamControllers.position.stream;
  Stream<Duration> get duration => playerStreamControllers.duration.stream;
  Stream<double> get volume => playerStreamControllers.volume.stream;
  Stream<double> get speed => playerStreamControllers.speed.stream;
  Stream<bool> get loop => playerStreamControllers.loop.stream;
  Stream<PlayerStatus> get status => playerStreamControllers.status.stream;

  void dispose() {
    playerStreamControllers.dispose();
  }
}

class PlayerStreamControllers {
  final StreamController<bool> playing = StreamController.broadcast();
  final StreamController<Duration> position = StreamController.broadcast();
  final StreamController<Duration> duration = StreamController.broadcast();
  final StreamController<double> volume = StreamController.broadcast();
  final StreamController<double> speed = StreamController.broadcast();
  final StreamController<bool> loop = StreamController.broadcast();
  final StreamController<PlayerStatus> status = StreamController.broadcast();

  get streams => PlayerStreams(this);

  void dispose() {
    playing.close();
    position.close();
    duration.close();
    volume.close();
    speed.close();
    loop.close();
    status.close();
  }
}

class PlayerValue {
  final bool playing;
  final Duration position;
  final Duration duration;
  final double volume;
  final double speed;
  final double loop;
  final PlayerStatus status;

  PlayerValue(
      {required this.playing,
      required this.position,
      required this.duration,
      required this.volume,
      required this.speed,
      required this.loop,
      required this.status});
}
