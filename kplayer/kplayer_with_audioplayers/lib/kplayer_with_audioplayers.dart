library kplayer_with_audioplayers;

import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:kplayer_platform_interface/kplayer_platform_interface.dart';
export 'package:kplayer_platform_interface/kplayer_platform_interface.dart';

class Player extends PlayerController {
  Player({
    int? id,
    required PlayerMedia media,
    bool? autoPlay,
    bool? once,
    bool? loop,
  })  : player = audioplayers.AudioPlayer(),
        super(
            media: media,
            autoPlay: autoPlay ?? true,
            once: once ?? false,
            loop: loop ?? false) {
    players.add(this);
  }

  final audioplayers.AudioPlayer player;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 1;
  bool _loop = false;
  double _speed = 1;

  @override
  get package => "audioplayers";

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
    audioplayers.Source apMedia;
    if (media.type == PlayerMediaType.network) {
      apMedia = audioplayers.UrlSource(media.resource);
    } else if (media.type == PlayerMediaType.asset) {
      apMedia = audioplayers.AssetSource(media.resource);
    } else if (media.type == PlayerMediaType.file) {
      apMedia = audioplayers.DeviceFileSource(media.resource);
    } else if (media.type == PlayerMediaType.bytes) {
      apMedia = audioplayers.BytesSource(media.resource);
    } else {
      throw Exception("media type ${media.type} not support");
    }
    // reset the prefix of assets
    player.audioCache.prefix = "";
    player.audioCache.clearAll();
    player.setSource(apMedia);
    players.add(this);

    subscriptions.addAll([
      player.onPositionChanged.listen((Duration position) async {
        _position = position;
        notify(PlayerEvent.position);
        // if (position == duration) {
        //   notify(PlayerEvent.end);
        // }
      }),
      player.onPlayerStateChanged
          .listen((audioplayers.PlayerState status) async {
        if (status == audioplayers.PlayerState.playing) {
          _status = PlayerStatus.playing;
        } else if (status == audioplayers.PlayerState.paused) {
          _status = PlayerStatus.paused;
        } else if (status == audioplayers.PlayerState.stopped) {
          _status = PlayerStatus.stopped;
        } else if (status == audioplayers.PlayerState.completed) {
          _status = PlayerStatus.ended;
        }
        notify(PlayerEvent.status);
      }),
      player.onDurationChanged.listen((Duration duration) {
        _duration = duration;
        notify(PlayerEvent.duration);
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
      player.resume();
    }
  }

  @override
  Future<void> replay() async {
    await seek(Duration.zero);
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
  Future<void> seek(Duration position) async {
    player.seek(position);
    _position = position;
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
    //
  }

  @override
  double get speed => _speed;

  @override
  set speed(double speed) {
    player.setPlaybackRate(speed);
    _speed = speed;
    notify(PlayerEvent.speed);
  }

  @override
  double get volume => _volume;

  @override
  set volume(double volume) {
    player.setVolume(volume);
    _volume = volume;
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
}
