# kplayer

Flutter player (currently only audio)
> online preview: [Go live](https://physia.github.io/kflutter/kplayer/online_example/index.html)
<img src="https://user-images.githubusercontent.com/22839194/166224411-dea32c6e-ac47-45ec-ab25-1900e0c0ccb9.png" width='150'>
<img src="https://user-images.githubusercontent.com/22839194/166224480-a9a0aa1a-54bb-4481-b529-e899e593b37c.png" width='150'>
<img src="https://user-images.githubusercontent.com/22839194/166224496-55776e1f-fcbd-4ca1-a165-c7417aaa7d1b.png" width='150'>
<img src="https://user-images.githubusercontent.com/22839194/166224505-619b5f64-9d22-4cae-a12f-eab58fb06fc4.png" width='150'>
<img src="https://user-images.githubusercontent.com/22839194/166224515-7597d04a-32df-4760-ac5d-50ff8c119ba9.png" width='150'>
<img src="https://user-images.githubusercontent.com/22839194/166224524-4dd28bc3-9506-40d0-a983-79105cc7af4a.png" width='150'>

## sopport

- windows,linux -> dart_vlc
- web, ios, android, macos -> just_audio

this package is just wrapper for just_audio and dart_vlc to support all platformsthis packege is just wrapper for`just_audio` and `dart_vlc` to support all platforms

## Getting Started

for specific platform configuration visit `just_audio`and `dart_vlc`

main.dart

```dart
void main() {
  Player.boot(); //add this  line
  runApp(MyApp());
}
```

Play from assets:

```dart
var player = Player.asset("/assets/sound.mp3");
```

Play from network:

```dart
var player = Player.network("[/assets/sound.mp3](https://example.com/sound.mp3)");
```

Play from file:

```dart
var player = Player.file("C/.../sound.mp3");
```

Play from bytes: // beta

```dart
var player = Player.bytes(fileAsBytes);
```

or:

```dart
var player = Player.create(asset: PlayerMedia.asset("/assets/sound.mp3"), autoPlay: true, once: true)
      ..init()
```

you have also:

```dart
 var palyer = Player.create(asset: PlayerMedia.asset("/assets/sound.mp3"),autoPlay: true, once: true)..init();

// callback
palyer.callback = (PlayerEvent event){
   // just example
   setState((){});
};

// info
var package   = player.package;   // "just_audio" or "dart_vlc"
var position  = player.position;  // setter an getter like seek()
var duration  = player.duration;  // getter
var status    = player.status;    // 
var loop      = player.loop;      // bool
var playing   = player.playing;
...
// streams
player.streams.playing.stream;
player.streams.position.stream;
player.streams.status.stream;
player.streams.volume.stream;
player.streams.speed.stream;
player.streams.loop.stream;

// control
player.play();
player.pause();
player.toggle();
player.stop();
player.seek(newPosition);
player.volume = 0.8; // setter getter
player.speed = 1.2; // Rate
player.loop = true; // looping

//other
player.dispose();
player.player; // the package player instance for more option

// Widgets
PlayerBar(player: player, options: []);
PlayerBuilder(player: player, builder: (context, player, event){
  return // TODO
});
```

// mixins
PlayerMixin
```
## Source code
check the repository on github (<https://github.com/physia/kflutter/tree/main/kplayer/kplayer>)
## Support ☺️

you can buy me a coffee.

<a href="https://www.buymeacoffee.com/mohamadlounnas"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=mohamadlounnas&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff"></a>

E n g o j :)

next plan: sopport video...
