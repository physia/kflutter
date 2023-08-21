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
  bool _loop = false;

  @override
  get package => "audioplayers";

  PlayerStatus _status = PlayerStatus.loading;
  @override
  PlayerStatus get status => _status;

  @override
  Future<void> setStatus(PlayerStatus status) async {
    _status = status;
    await notify(PlayerEvent.status);
  }

  @override
  @Deprecated("use setStatus instead")
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
  Future<void> init() async {
    await notify(PlayerEvent.init);
    // reset the prefix of assets
    player.audioCache.prefix = "";
    // needBoot((){
    //   Player.boot();
    //   print("Player.boot");
    // });
    await setMedia(media);

    // await player.audioCache.clearAll();

    subscriptions.addAll([
      player.onPositionChanged.listen((Duration position) async {
        _position = position;
        await notify(PlayerEvent.position);
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
        await notify(PlayerEvent.status);
      }),
      player.onDurationChanged.listen((Duration duration) async {
        _duration = duration;
        await notify(PlayerEvent.duration);
      }),
    ]);

    if (autoPlay) {
      await play();
    }
    await super.init();
  }

  @override
  Future<void> play() async {
    await notify(PlayerEvent.play);
    if (!playing) {
      _status = PlayerStatus.playing;
      await player.resume();
    }
  }

  @override
  Future<void> replay() async {
    await setPosition(Duration.zero);
    await notify(PlayerEvent.replay);
    await play();
  }

  @override
  Future<void> pause() async {
    _status = PlayerStatus.paused;
    await player.pause();
    await notify(PlayerEvent.pause);
  }

  @override
  Future<void> stop() async {
    _status = PlayerStatus.stopped;
    await player.stop();
    await notify(PlayerEvent.stop);
  }

  @override
  @Deprecated("use setPosition instead")
  Future<void> seek(Duration position) async {
    await setPosition(position);
  }

  @override
  Future<void> toggle() async {
    _status == PlayerStatus.playing ? await pause() : await play();
    await notify(PlayerEvent.toggle);
  }

  @override
  Future<void> dispose() async {
    await notify(PlayerEvent.dispose);
    await player.dispose();
    super.dispose();
  }

  //
  static Future<void> boot() async {}

  @override
  double get speed => player.playbackRate;

  @override
  Future<void> setSpeed(double speed) async {
    await player.setPlaybackRate(speed);
    await notify(PlayerEvent.speed);
  }

  // deprecated
  @override
  @Deprecated("use setSpeed instead")
  set speed(double speed) {
    setSpeed(speed);
  }

  @override
  double get volume => player.volume;

  @override
  Future<void> setVolume(double volume) async {
    await player.setVolume(volume);
    await notify(PlayerEvent.volume);
  }

  @override
  @Deprecated("use setVolume instead")
  set volume(double volume) {
    setVolume(volume);
  }

  @override
  bool get loop => _loop;

  @override
  Future<void> setLoop(bool loop) async {
    _loop = loop;
    await notify(PlayerEvent.loop);
  }

  @override
  @Deprecated("use setLoop instead")
  set loop(bool loop) {
    setLoop(loop);
  }

  @override
  Future<void> setPosition(Duration position) async {
    await player.seek(position);
    _position = position;
    await notify(PlayerEvent.position);
  }

  @override
  @Deprecated(
      "use setLoop instead, No longer supported and will be removed in the next major version")
  set position(Duration position) {
    setPosition(position);
  }

  @override
  Future<void> setMedia(PlayerMedia media) async {
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
    await player.setSource(apMedia);
  }
}
