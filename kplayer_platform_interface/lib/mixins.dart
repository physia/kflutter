import 'dart:async';

import 'package:flutter/widgets.dart';
import 'kplayer_platform_interface.dart';

/// Mixin handel Player (init,dispose)
mixin PlayerStateMixin<T extends StatefulWidget> on State<T> {
  PlayerController? _controller;
  List<StreamSubscription?> _subscriptions = [];
  usePlayer(PlayerController? controller) {
    _subscriptions.addAll([
      controller?.streams.playing.listen(onPlayingChanged),
      controller?.streams.position.listen(onPositionChanged),
      controller?.streams.duration.listen(onDurationChanged),
      controller?.streams.status.listen(onStatusChanged),
      controller?.streams.speed.listen(onSpeedChanged),
      controller?.streams.volume.listen(onVolumeChanged),
      controller?.streams.loop.listen(onLoopChanged),
      controller?.streams.events.listen(onEvent),
    ]);
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
    _subscriptions.forEach((subscription) => subscription?.cancel());
  }

  PlayerEvent event = PlayerEvent.unknown;

  void onPlayingChanged(bool playing) {}
  void onPositionChanged(Duration position) {}
  void onDurationChanged(Duration duration) {}
  void onStatusChanged(PlayerStatus status) {}
  void onSpeedChanged(double speed) {}
  void onVolumeChanged(double volume) {}
  void onLoopChanged(bool loop) {}
  void onEvent(PlayerEvent event) {
    this.event = event;
  }

  bool shouldRebuild(PlayerEvent event, PlayerEvent oldEvent) {
    return true;
  }
}
