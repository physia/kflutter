import 'package:flutter/material.dart';
import 'package:kplayer/kplayer.dart';

void main() {
  Player.boot();
  runApp(const SimpleExample());
}

class SimpleExample extends StatefulWidget {
  const SimpleExample({Key? key}) : super(key: key);

  @override
  State<SimpleExample> createState() => _SimpleExampleState();
}

class _SimpleExampleState extends State<SimpleExample> {
  var audioPlayer = Player.asset(
    'assets/Introducing_flutter.mp3',
    autoPlay: false,
    loop: true,
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: StreamBuilder<Duration>(
                  stream: audioPlayer.streams.position,
                  builder: (context, snapshot) {
                    return Text('Play ${audioPlayer.position}');
                  }),
              onPressed: () {
                audioPlayer.play();
                // audioPlayer.loop = true;
              },
            ),
            ElevatedButton(
              child: const Text("Set 99%"),
              onPressed: () {
                audioPlayer.position = Duration(
                    seconds: (audioPlayer.duration.inSeconds * 0.95).round());
              },
            ),
          ],
        ),
      ),
    );
  }
}
