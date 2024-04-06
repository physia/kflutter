import 'package:flutter/material.dart';
import 'package:kplayer/kplayer.dart';

void main() {
  Player.boot();
  PlayerController.enableLog = false;
  runApp( ReuseExample());
}

class ReuseExample extends StatelessWidget {
   ReuseExample({Key? key}) : super(key: key);
  PlayerController? _currentPlayer;


  void play() {
    try {
      _currentPlayer?.dispose();
      _currentPlayer = Player.asset('assets/Introducing_flutter.mp3');
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: FilledButton(
          onPressed: () {
            play();
          },
          child: const Text('Play Video'),
      ),
      ),
    );
  }
}
