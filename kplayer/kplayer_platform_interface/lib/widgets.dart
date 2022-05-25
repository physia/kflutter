import 'package:flutter/material.dart';

import 'kplayer_platform_interface.dart';

/*
 * PlayerBar is a widget that contains the player controls.
 *
 */
class PlayerBar extends StatefulWidget {
  final PlayerController player;
  final List<Widget>? options;
  const PlayerBar({Key? key, required this.player, this.options})
      : super(key: key);

  @override
  State<PlayerBar> createState() => _PlayerBarState();
}

class _PlayerBarState extends State<PlayerBar> with TickerProviderStateMixin {
  Duration? _nextPosition;
  bool _showVolumeBox = false;
  bool _showSettingsBox = false;
  OverlayEntry? volumeBoxOverlayEntry;
  OverlayEntry? settingsBoxOverlayEntry;
  GlobalKey volumeButtonKey = GlobalKey();
  GlobalKey settingsButtonKey = GlobalKey();
  // Animation controller for Overlays
  // it responsible for showing/hiding the Overlays with one animation
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = _animationController.drive(
      CurveTween(
        curve: Curves.easeInOutSine,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void showVolumeBox() {
    volumeBoxOverlayEntry?.remove();
    var viewPortSize = MediaQuery.of(context).size;

    RenderBox box =
        volumeButtonKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    volumeBoxOverlayEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          debugPrint(_animation.value.toString());
          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      hideVolumeBox();
                    });
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.1 * _animation.value),
                  ),
                ),
              ),
              Positioned(
                bottom: (viewPortSize.height - position.dy) * _animation.value,
                left: position.dx,
                width: box.size.width,
                height:
                    (200 - box.size.width) * _animation.value + box.size.width,
                child: Transform.scale(
                  scale: _animation.value,
                  child: Opacity(
                    opacity: _animation.value,
                    child: Material(
                      color: Theme.of(context).cardColor,
                      elevation: 10,
                      borderRadius: BorderRadius.circular(100),
                      child: Column(
                        children: <Widget>[
                          // IconButton(
                          //   icon: Icon(Icons.volume_up),
                          //   onPressed: () {
                          //     setState(() {
                          //       widget.player.volume += 0.1;
                          //     });
                          //   },
                          // ),
                          Expanded(
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: PlayerVolume(
                                player: widget.player,
                              ),
                            ),
                          ),
                          // IconButton(
                          //   icon: Icon(Icons.volume_down),
                          //   onPressed: () {
                          //     setState(() {
                          //       widget.player.volume -= 0.1;
                          //     });
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
    Overlay.of(context)!.insert(volumeBoxOverlayEntry!);
    _animationController.forward();
    _showVolumeBox = true;
  }

  void hideVolumeBox() async {
    await _animationController.reverse();
    volumeBoxOverlayEntry?.remove();
    volumeBoxOverlayEntry = null;
    _showVolumeBox = false;
  }

  void showSettingsBox() {
    settingsBoxOverlayEntry?.remove();

    var viewPortSize = MediaQuery.of(context).size;
    RenderBox box =
        settingsButtonKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    // create shader mask with gradient, animate it and show it

    settingsBoxOverlayEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        hideSettingsBox();
                      });
                    },
                    child: Container(
                      color: Colors.black
                          .withOpacity(0.1 * _animationController.value),
                    ),
                  ),
                ),
                Positioned(
                  bottom:
                      (viewPortSize.height - position.dy) * _animation.value,
                  right: position.dx + box.size.width - viewPortSize.width,
                  child: Transform.scale(
                    scale: _animation.value,
                    // the origin of the transform is the button right corner
                    origin: Offset(150, 0),
                    child: Opacity(
                      opacity: _animation.value,
                      child: Material(
                        color: Theme.of(context).cardColor,
                        elevation: 10,
                        borderRadius: BorderRadius.circular(8),
                        child: LimitedBox(
                          maxHeight: 300,
                          maxWidth: 250,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                StreamBuilder<bool>(
                                    stream: widget.player.streams.loop,
                                    builder: (context, snapshot) {
                                      return SwitchListTile(
                                        secondary: const Icon(Icons.repeat),
                                        title: const Text('Loop'),
                                        value: widget.player.loop,
                                        onChanged: (c) {
                                          widget.player.loop = c;
                                        },
                                      );
                                    }),
                                if (widget.options != null) ...?widget.options
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
    Overlay.of(context)!.insert(settingsBoxOverlayEntry!);
    _animationController.forward();

    _showSettingsBox = true;
  }

  void hideSettingsBox() async {
    await _animationController.reverse();
    settingsBoxOverlayEntry?.remove();
    settingsBoxOverlayEntry = null;
    _showSettingsBox = false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: widget.player.toggle,
          icon: StreamBuilder<bool>(
            stream: widget.player.streams.playing,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.hasError) {
                return const CircularProgressIndicator();
              }
              return snapshot.data!
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow);
            },
          ),
        ),
        // iconButton for showing/hiding the player volume
        StatefulBuilder(
          key: volumeButtonKey,
          builder: (BuildContext context, setState) {
            return IconButton(
              onPressed: () {
                if (_showVolumeBox) {
                  hideVolumeBox();
                } else {
                  showVolumeBox();
                }
              },

              /// icon depends on the current volume
              /// if volume is 0, the icon is volume_off
              /// if volume is between 0 and 0.5, the icon is volume_down
              /// if volume is between 0.5 and 1, the icon is volume_up
              icon: StreamBuilder<double>(
                stream: widget.player.streams.volume,
                builder: (context, snapshot) {
                  return Icon(
                    widget.player.volume == 0
                        ? Icons.volume_off
                        : widget.player.volume < 0.5
                            ? Icons.volume_down
                            : Icons.volume_up,
                  );
                },
              ),
            );
          },
        ),

        // a way to show position
        Expanded(
          child: StatefulBuilder(builder: (context, _setState) {
            return StreamBuilder<Duration>(
                stream: widget.player.streams.position
                    .distinct((a, b) => _nextPosition != null),
                builder: (context, snapshot) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        _nextPosition != null
                            ? _nextPosition!.toReadableString()
                            : widget.player.position.toReadableString(),
                      ),
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: widget.player.duration.inMilliseconds.toDouble(),
                          value: _nextPosition?.inMilliseconds.toDouble() ??
                              widget.player.position.inMilliseconds.toDouble(),
                          onChangeStart: (double value) {
                            _nextPosition =
                                Duration(milliseconds: value.toInt());
                          },
                          onChangeEnd: (double value) {
                            widget.player.position = _nextPosition!;
                            _nextPosition = null;
                          },
                          onChanged: (double value) {
                            _setState(() {
                              _nextPosition =
                                  Duration(milliseconds: value.toInt());
                            });
                          },
                        ),
                      ),
                      Text(
                        widget.player.duration.toReadableString(),
                      ),
                      // Positioned(
                      //   bottom: 10,
                      //   left: 0,
                      //   right: 0,
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 24),
                      //     child: Opacity(
                      //       opacity: 0.7,
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(
                      //             PlayerController.durationToString(
                      //                 _nextPosition != null
                      //                     ? _nextPosition!
                      //                     : widget.player.position),
                      //           ),
                      //           Text(
                      //             PlayerController.durationToString(
                      //                 widget.player.duration),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  );
                });
          }),
        ),
        // IconButton(
        //   onPressed: () => widget.player.loop = !widget.player.loop,
        //   icon: StreamBuilder<bool>(
        //       stream: widget.player.streams.loop,
        //       builder: (context, snapshot) {
        //         return widget.player.loop
        //             ? const Icon(Icons.repeat)
        //             : const Icon(Icons.repeat_one);
        //       }),
        // ),
        StatefulBuilder(
          builder: (BuildContext context, setState) {
            return IconButton(
              key: settingsButtonKey,
              onPressed: () {
                if (_showSettingsBox) {
                  hideSettingsBox();
                } else {
                  showSettingsBox();
                }
              },
              icon: const Icon(Icons.settings),
            );
          },
        ),
      ],
    );
  }
}

/// the [PlayerVolume] widget is used to control the volume of the player.
/// it contains a vertical slider to control the volume.
class PlayerVolume extends StatefulWidget {
  final PlayerController player;
  const PlayerVolume({Key? key, required this.player}) : super(key: key);

  @override
  State<PlayerVolume> createState() => _PlayerVolumeState();
}

class _PlayerVolumeState extends State<PlayerVolume> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: widget.player.streams.volume,
      builder: (context, snapshot) {
        return Slider(
          min: 0,
          max: 1,
          label: (widget.player.volume * 100.0).toStringAsFixed(0) + '%',
          value: snapshot.data ?? widget.player.volume,
          onChanged: (double value) {
            widget.player.volume = value;
          },
        );
      },
    );
  }
}

/// the [PlayerBuilder] is a widget that can be used to build a player
///
/// it will automatically rebuild when the player state changes
/// also provides functions to control the player
class PlayerBuilder extends StatefulWidget {
  // rebuild is a function that will be called when the player state changes
  // return bool to indicate if the widget should be rebuilt
  // it take [PlayerEvent] as parameter
  final bool Function([PlayerEvent event, PlayerEvent oldEvent])? rebuild;
  final PlayerController player;
  final Widget? child;
  final Widget Function(BuildContext context, PlayerEvent event, Widget? child)
      builder;
  const PlayerBuilder(
      {Key? key,
      this.child,
      required this.player,
      required this.builder,
      this.rebuild})
      : super(key: key);

  @override
  State<PlayerBuilder> createState() => _PlayerBuilderState();
}

class _PlayerBuilderState extends State<PlayerBuilder> {
  // the current event
  PlayerEvent _event = PlayerEvent.unknown;
  @override
  void initState() {
    widget.player.callback = (event) {
      if (_rebuild(event, _event)) {
        setState(() {
          _event = event;
        });
      } else {
        _event = event;
      }
    };
    super.initState();
  }

  bool _rebuild(PlayerEvent event, PlayerEvent oldEvent) {
    if (widget.rebuild != null) {
      return widget.rebuild!(event, oldEvent);
    }
    return event != oldEvent;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _event, widget.child);
  }
}
