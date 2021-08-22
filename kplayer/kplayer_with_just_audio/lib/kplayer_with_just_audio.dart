library kplayer_with_just_audio;

import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:kplayer_platform_interface/kplayer_platform_interface.dart';

class Player extends PlayerPlatform {
  Player({
    required PlayerMedia media,
    bool? autoPlay,
    bool? once,
    bool? loop,
  })  : player = just_audio.AudioPlayer(),
        super(media: media, autoPlay: autoPlay ?? false, once: once ?? false, loop: loop ?? false) {
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
  bool get playing => _status == PlayerStatus.playing;

  @override
  Duration get duration => player.duration ?? Duration.zero;

  @override
  Duration get position => player.position;

  static List<PlayerPlatform> get players => PlayerPlatform.palyers;
  @override
  void init() async {
    if (media.type == PlayerMediaType.asset) {
      await player.setAsset(media.resource);
    } else {
      await player.setUrl(media.resource);
    }
    // player.speedStream.listen((speed) {
    //   _speed=speed;
    // });
    // player.volumeStream.listen((volume) {
    //   _volume=volume;
    // });
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
  _notify(){
    callback();
  }

  @override
  void play() {
    _notify();
    if (!player.playing) {
      player.play();
      _status = PlayerStatus.playing;
    }
  }

  @override
  void replay() {
    // seek(Duration.zero);
    init();
    play();
  }

  @override
  void pause() {
    _notify();
    player.pause();
    _status = PlayerStatus.paused;
  }

  @override
  void stop() {
    _notify();
    player.stop();
    _status = PlayerStatus.stopped;
  }

  @override
  void seek(Duration position) {
    _notify();
    player.seek(position);
  }

  @override
  void toggle() {
    player.playing ? pause() : play();
  }

  @override
  void dispose() {
    player.dispose();
  }

  @override
  static void boot() {
    print("Kplayer: just_audio");
  }

  // double _speed = 1.0;

  double get speed => player.speed;

  set speed(double speed) {
    _notify();
    // _speed = speed;
    player.setSpeed(speed);
  }

  // double _volume = 1.0;

  double get volume => player.speed;

  set volume(double volume) {
    _notify();
    // _volume = volume;
    player.setVolume(volume);
  }

  @override
  set position(Duration position) {
    seek(position);
  }
}
