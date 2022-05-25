import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kplayer_with_dart_vlc/kplayer_with_dart_vlc.dart' as dart_vlc;
import 'package:kplayer_with_just_audio/kplayer_with_just_audio.dart'
    as just_audio;
import 'package:kplayer_with_audioplayers/kplayer_with_audioplayers.dart'
    as audioplayers;
// import 'package:kplayer_with_audioplayers/kplayer_with_audioplayers.dart'
//     as audioplayers;

import 'package:kplayer_platform_interface/kplayer_platform_interface.dart';
export 'package:kplayer_platform_interface/kplayer_platform_interface.dart';

// typedef  = dart_vlc.Player;
/// [PlatformEnv] enum is used to determine which platform the app is
/// running on.
enum PlatformEnv {
  /// The app is running on the web.
  web,

  /// The app is running on the iOS.
  ios,

  /// The app is running on the Android.
  android,

  /// The app is running on the Windows.
  windows,

  /// The app is running on the Linux.
  linux,

  /// The app is running on the MacOS.
  macos,

  /// The app is running on the Fuchsia.
  fuchsia,

  /// unknown (not supported).
  unknown;

  static PlatformEnv get environment {
    if (kIsWeb) {
      return PlatformEnv.web;
    } else if (Platform.isAndroid) {
      return PlatformEnv.android;
    } else if (Platform.isIOS) {
      return PlatformEnv.ios;
    } else if (Platform.isWindows) {
      return PlatformEnv.windows;
    } else if (Platform.isLinux) {
      return PlatformEnv.linux;
    } else if (Platform.isMacOS) {
      return PlatformEnv.macos;
    } else if (Platform.isFuchsia) {
      return PlatformEnv.fuchsia;
    } else {
      return PlatformEnv.unknown;
    }
  }
}

/// Object handle create and boot the [PlayerController]
class Player {
  /// this need to use in windows,linux
  /// put this in main
  /// dynamically loaded native library
  /// https://api.dart.dev/stable/2.13.4/dart-ffi/DynamicLibrary-class.html
  /// ```dart
  /// void main() {
  ///   Player.boot();
  ///   runApp(const MyApp());
  /// }
  /// ```
  static boot() {
    if (!Player.booted) {
      dart_vlc.Player.boot();
      just_audio.Player.boot();
      // audioplayers.Player.boot();
      Player._booted = true;
    }
  }

  static bool _booted = false;
  static bool get booted => _booted;

  /// add property to Player for return Map<PlatformEnv,PlayerContoller> named as platforms
  static Map<PlatformEnv, PlayerConstructor?> platforms = {
    PlatformEnv.ios: just_audio.Player.new,
    PlatformEnv.android: just_audio.Player.new,
    PlatformEnv.windows: audioplayers.Player.new,
    PlatformEnv.linux: audioplayers.Player.new,
    PlatformEnv.macos: audioplayers.Player.new,
    PlatformEnv.fuchsia: null, // [Hope to add fuchsia support],
  };

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
    // select player depending on platform
    final PlayerConstructor? playerConstructor =
        platforms[PlatformEnv.environment];
    if (playerConstructor == null) {
      throw UnsupportedError(
        '[KPlayer] Platform ${Platform.environment.runtimeType} is not supported.',
      );
    }
    return playerConstructor(
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
  static PlayerController asset(String media,
      {int? id, bool? autoPlay = true, bool? once}) {
    return Player.create(
        id: id, media: PlayerMedia.asset(media), autoPlay: autoPlay, once: once)
      ..init();
  }

  /// create network instance
  /// ```dart
  /// var player = Player.network("https://example.com/file.mp3");
  /// player.play();
  /// ```
  static PlayerController network(String media,
      {int? id, bool? autoPlay = true, bool? once}) {
    return Player.create(
        id: id,
        media: PlayerMedia.network(media),
        autoPlay: autoPlay,
        once: once)
      ..init();
  }

  /// create file instance
  /// ```dart
  /// var player = Player.file("/path/to/file.mp3");
  /// player.play();
  /// ```
  static PlayerController file(String media,
      {int? id, bool? autoPlay = true, bool? once}) {
    return Player.create(
        id: id, media: PlayerMedia.file(media), autoPlay: autoPlay, once: once)
      ..init();
  }

  /// create file instance
  /// ```dart
  /// var player = Player.file("/path/to/file.mp3");
  /// player.play();
  /// ```
  static PlayerController bytes(Uint8List media,
      {int? id, bool? autoPlay = true, bool? once}) {
    return Player.create(
        id: id, media: PlayerMedia.bytes(media), autoPlay: autoPlay, once: once)
      ..init();
  }

  /// create file instance
  /// ```dart
  /// var player = Player.file("/path/to/file.mp3");
  /// player.play();
  /// ```
  static PlayerController stream(Stream media,
      {int? id, bool? autoPlay = true, bool? once}) {
    return Player.create(
        id: id,
        media: PlayerMedia.stream(media),
        autoPlay: autoPlay,
        once: once)
      ..init();
  }
}

/// Mixin handel Player (init,dispose)
mixin PlayerStateMixin<T extends StatefulWidget> on State<T> {
  PlayerController? _controller;
  usePlayer(PlayerController? controller) {
    controller?.streams.playing.listen(onPlayingChanged);
    controller?.streams.position.listen(onPositionChanged);
    controller?.streams.duration.listen(onDurationChanged);
    controller?.streams.status.listen(onStatusChanged);
    controller?.streams.speed.listen(onSpeedChanged);
    controller?.streams.volume.listen(onVolumeChanged);
    controller?.streams.loop.listen(onLoopChanged);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   if (_controller != null) {
  //     usePlayer(_controller);
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void onPlayingChanged(bool playing) {}
  void onPositionChanged(Duration position) {}
  void onDurationChanged(Duration duration) {}
  void onStatusChanged(PlayerStatus status) {}
  void onSpeedChanged(double speed) {}
  void onVolumeChanged(double volume) {}
  void onLoopChanged(bool loop) {}
}
