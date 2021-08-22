import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:kplayer_with_dart_vlc/kplayer_with_dart_vlc.dart' as dart_vlc;
import 'package:kplayer_with_just_audio/kplayer_with_just_audio.dart'
    as just_audio;
import 'package:kplayer_platform_interface/kplayer_platform_interface.dart';
export 'package:kplayer_platform_interface/kplayer_platform_interface.dart';
// typedef  = dart_vlc.Player;

class Player {
  static boot() {
    dart_vlc.Player.boot();
    just_audio.Player.boot();
  }

  static PlayerPlatform create({
    int? id,
    required PlayerMedia media,
    bool? autoPlay,
    bool? once,
    bool? loop,
  }) {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
      return dart_vlc.Player(
        id: id,
        media: media,
        autoPlay: autoPlay,
        once: once,
        loop: loop,
      );
    } else {
      return just_audio.Player(
        media: media,
        autoPlay: autoPlay,
        once: once,
        loop: loop,
      );
    }
  }

  static PlayerPlatform assets(media, {int? id, bool? autoPlay, bool? once}) {
    return Player.create(
        id: id, media: PlayerMedia.asset(media), autoPlay: autoPlay, once: once)
      ..init();
  }

  static PlayerPlatform network(media, {int? id, bool? autoPlay, bool? once}) {
    return Player.create(
        id: id,
        media: PlayerMedia.network(media),
        autoPlay: autoPlay,
        once: once)
      ..init();
  }
}
