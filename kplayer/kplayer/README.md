# kplayer

Flutter player (currently only audio)

<img src="https://raw.githubusercontent.com/physia/kflutter/main/kplayer/kplayer/image/README/1629644624563.png">
<img src="https://raw.githubusercontent.com/physia/kflutter/main/kplayer/kplayer/image/README/1629683134134.png">

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
Player.asset("/assets/sound.mp3").play();
```

Play from network:

```dart
Player.network("https://example.com/sound.mp3").play();
```

or:

```dart
Player.create(asset: PlayerMedia.asset("/assets/sound.mp3"), autoPlay: true, once: true).init();
```

you have also:

```dart
 var palyer = Player.create(asset: PlayerMedia.asset("/assets/sound.mp3"),autoPlay: true, once: true).init();

// callback
palyer.callback = (PlayerEvent event){};

// info
var package = player.package; // "just_audio" or "dart_vlc"
var position= player.position; // setter an getter like seek()
var duration = player.duration; // getter
var status= player.status; // 
var playing= player.playing;
...
// streams
player.streams.playing.stream;
player.streams.position.stream;
player.streams.status.stream;
player.streams.volume.stream;
player.streams.speed.stream;

// control
player.play();
player.pause();
player.toggle();
player.stop();
player.seek(newPosition);
player.volume = 0.8; // setter getter
player.speed = 1.2; // Rate

//other
player.dispose();
player.player; // the package player instance

```

## Support ☺️

you can buy me a coffee.

<a href="https://www.buymeacoffee.com/mohamadlounnas"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=mohamadlounnas&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff"></a>

engoj :)

next plan: sopport video...
