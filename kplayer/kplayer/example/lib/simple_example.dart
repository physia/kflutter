import 'package:flutter/material.dart';
import 'package:kplayer/kplayer.dart';

void main() {
  Player.boot();
  runApp(const SimpleExample());
}

class SimpleExample extends StatelessWidget {
  const SimpleExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Player.asset(
      'assets/Introducing_flutter.mp3',
      autoPlay: false,
      loop: false,
    );
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
                audioPlayer.loop = true;
              },
            ),
            ElevatedButton(
              child: const Text("Position to 98%"),
              onPressed: () {
                audioPlayer.position = Duration(
                    seconds: (audioPlayer.duration.inSeconds * 0.98).round());
              },
            ),
            ElevatedButton(
              child: const Text("Volume to 0.5"),
              onPressed: () {
                audioPlayer.volume = 0.5;
              },
            ),
          ],
        ),
      ),
    );
  }
}
