# kplayer_example

```dart
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kplayer/kplayer.dart';

void main() {
  Player.boot();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var player = Player.network(
      "https://physia.github.io/kflutter/kplayer/online_example/assets/assets/Introducing_flutter.mp3",
      autoPlay: false);
  @override
  void initState() {
    super.initState();
  }

  bool _changingPosition = false;
  bool loading = false;
  Duration _position = Duration.zero;
  double get position {
    if (player.duration.inSeconds == 0) {
      return 0;
    }
    if (_changingPosition) {
      return _position.inSeconds * 100 / player.duration.inSeconds;
    } else {
      return player.position.inSeconds * 100 / player.duration.inSeconds;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      color: Colors.teal,
      theme: const CupertinoThemeData(
        primaryColor: Colors.teal,
        primaryContrastingColor: Colors.teal,
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: StreamBuilder(
              stream: player.positionStream,
              builder: (context, snapshot) {
                return Text(player.status.toString());
              }),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: StreamBuilder(
                      stream: player.positionStream,
                      builder: (context, snapshot) {
                        return CircularProgressIndicator(
                          strokeWidth: 1,
                          color: Colors.teal,
                          value: loading
                              ? null
                              : player.position.inSeconds /
                                  max(player.duration.inSeconds, 0.01),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: FloatingActionButton(
                      disabledElevation: 0,
                      elevation: 0,
                      focusElevation: 0,
                      hoverElevation: 0,
                      highlightElevation: 0,
                      backgroundColor: Colors.teal.withOpacity(0.1),
                      onPressed: () {
                        setState(() {
                          player.toggle();
                        });
                      },
                      child: DefaultTextStyle(
                        style: const TextStyle(color: Colors.black87),
                        child: StreamBuilder(
                          stream: player.positionStream,
                          builder: (context, snapshot) {
                            return player.playing
                                ? const Icon(
                                    Icons.pause,
                                    color: Colors.teal,
                                    size: 80,
                                  )
                                : const Icon(
                                    Icons.play_arrow,
                                    color: Colors.teal,
                                    size: 80,
                                  );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                width: double.infinity,
                child: StreamBuilder(
                    stream: player.positionStream,
                    builder: (context, AsyncSnapshot<Duration> snapshot) {
                      loading = false;
                      return CupertinoSlider(
                        value: position,
                        min: 0,
                        max: 100,
                        onChangeStart: (double value) {
                          _changingPosition = true;
                        },
                        onChangeEnd: (double value) {
                          _changingPosition = false;
                        },
                        onChanged: (double value) {
                          setState(() {
                            loading = true;
                            _position = Duration(
                                seconds:
                                    ((value / 100) * player.duration.inSeconds)
                                        .toInt());
                            player.position = _position;
                          });
                        },
                      );
                    }),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                width: double.infinity,
                child: Row(
                  children: [
                    const Icon(Icons.volume_up),
                    Expanded(
                      child: StreamBuilder(
                        stream: player.positionStream,
                        builder: (context, AsyncSnapshot<Duration> snapshot) {
                          return CupertinoSlider(
                            value: player.volume * 100,
                            min: 0,
                            max: 100,
                            // label: player.volume.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                player.volume = value / 100;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                width: double.infinity,
                child: Row(
                  children: [
                    const Icon(Icons.speed),
                    Expanded(
                      child: StreamBuilder(
                        stream: player.positionStream,
                        builder: (context, AsyncSnapshot<Duration> snapshot) {
                          return CupertinoSlider(
                            value: player.speed * 10,
                            min: 0,
                            max: 10,
                            divisions: 10,
                            onChanged: (double value) {
                              setState(() {
                                player.speed = value / 10;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: DefaultTextStyle(
                  style: TextStyle(color: Colors.black38, fontSize: 12),
                  child: Column(
                    children: [
                      Text("Duration: " + player.duration.toString()),
                      Text("Position: " + player.position.toString()),
                      Text("Volume: " + player.volume.toString()),
                      Text("Speed: " + player.speed.toString()),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

```
