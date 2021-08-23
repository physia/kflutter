library kplayer_with_just_audio;

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:kplayer_platform_interface/kplayer_platform_interface.dart';

class Player extends PlayerPlatform {
  Player({
    required PlayerMedia media,
    bool? autoPlay,
    bool? once,
    bool? loop,
  })  : player = just_audio.AudioPlayer(),
        super(
            media: media,
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
  PlayerStatus _status = PlayerStatus.created;
  @override
  PlayerStatus get status => _status;

  @override
  bool get playing => status==PlayerStatus.playing;

  @override
  set status(PlayerStatus status) {
    _status = status;
    notify(PlayerEvent.status);
  }

  @override
  Duration get duration => player.duration ?? Duration.zero;

  @override
  Duration get position => _position;

  static List<PlayerPlatform> get players => PlayerPlatform.palyers;

  @override
  void init() async {
    if (media.type == PlayerMediaType.asset) {
      await player.setAsset(media.resource);
    } else {
      await player.setUrl(media.resource);
    }
    // player.speedStream.listen((speed) {
    //   speed = speed;
    // });
    // player.volumeStream.listen((volume) {
    //   volume = volume;
    // });
    player.positionStream.listen((positionValue) {
      notify(PlayerEvent.position);
      _position = positionValue;
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

    _status = PlayerStatus.inited;
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
  void dispose() {
    super.dispose();
    notify(PlayerEvent.dispose);
    player.dispose();
  }

  //
  static void boot() {
    debugPrint("Kplayer: just_audio");
  }

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 1;
  double _speed = 1;

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
  set position(Duration position) {
    seek(_position = position);
    notify(PlayerEvent.position);
  }

  @override
  void seek(Duration position) {
    player.seek(_position = position);
    notify(PlayerEvent.position);
  }
}
