# kplayer

Flutter player (currently only audio)
> online preview: [Go live](https://physia.github.io/kflutter/kplayer/online_example/index.html)
<!-- ![image](https://user-images.githubusercontent.com/22839194/170221879-7eb150e1-fbe0-4f51-a28f-cbde58f51ae1.png)
![image](https://user-images.githubusercontent.com/22839194/170221947-6c4da925-207b-412c-968f-5e4655e71da6.png)
![image](https://user-images.githubusercontent.com/22839194/170222072-8c77270b-a690-4bdc-9e0e-39d1c6f197bc.png)
![image](https://user-images.githubusercontent.com/22839194/170222374-31dd203b-aeb5-4ca2-b940-42efaba417bb.png) -->
<div style="display:flex;">
<img src="https://user-images.githubusercontent.com/22839194/170221879-7eb150e1-fbe0-4f51-a28f-cbde58f51ae1.png" width='150'><img src="https://user-images.githubusercontent.com/22839194/170221947-6c4da925-207b-412c-968f-5e4655e71da6.png" width='150'><img src="https://user-images.githubusercontent.com/22839194/170222072-8c77270b-a690-4bdc-9e0e-39d1c6f197bc.png" width='150'><img src="https://user-images.githubusercontent.com/22839194/170222374-31dd203b-aeb5-4ca2-b940-42efaba417bb.png" width='277'>
</div>

## sopport
no action required, just add package and use it

### packages has wrapper
by default kplayer use ``audioplayers`` package
- recommended: audioplayers (kplayer_with_audioplayers)
- not updated: just_audio (kplayer_with_just_audio)
- deprecated: dart_vlc (kplayer_with_dart_vlc)

## Getting Started

main.dart

```dart
void main() {
  Player.boot(); //add this  line (optional)
  runApp(MyApp());
}
```

Play from assets:

```dart
var player = Player.asset("/assets/sound.mp3");
```

Play from network:

```dart
var player = Player.network("https://example.com/sound.mp3");
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
var player = Player.asset("/assets/sound.mp3");


// info
var package   = player.package;   // "current_apaptive_package_name"
var position  = player.position;  // setter an getter like seek()
var duration  = player.duration;  // getter (Duration are unmodifiable)
var status    = player.status;    // current status (playing, paused, ...)
var loop      = player.loop;      // bool
var playing   = player.playing;
var volume    = player.volume;    // get current volume
var speed     = player.speed;     // get current speed (playback rate)
...
// streams
player.streams.playing.stream;
player.streams.position.stream;
player.streams.status.stream;
player.streams.volume.stream;
player.streams.speed.stream;
player.streams.loop.stream;

// control (all async)
player.play();
player.pause();
player.toggle();
player.stop();
player.setPosition(Duration(seconds: 10));
player.setVolume(0.8);
player.setSpeed(1.5);
player.setLoop(true);

//other
player.dispose();
player.player; // the native player

// all players
PlayerController.players; // List<PlayerController>
// dispose all players
PlayerController.disposeAll();

// all other players
player.others; // List<PlayerController>

// example pause all other players
player.others.forEach((player) => player.pause());

// Widgets
PlayerBar(player: player, options: []);
PlayerBuilder(
  player: player,
  rebuild: (event, oldEvent) => event != oldEvent, // by default it will rebuild when event changed
  builder: (context, event){
  return // TODO
});
```

## mixins

you can use ```PlayerStateMixin``` on ```State``` to get full access player state and handle streams dispose automatically

```dart
class MyPage extends StatefulWidget {
  final PlayerController player;
  const MyPage({super.key, required this.player});
  @override
  _MyPageState createState() => _MyPageState();
}
class _MyPageState extends State<MyPage> with PlayerStateMixin {
  @override
  void initState() {
    usePlayer(widget.player);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return // TODO
  }

  @override
  void onPlayingChanged(bool playing) {
    print('onPlayingChanged $playing');
  }
  @override
  void onPositionChanged(Duration position) {
    print('onPositionChanged $position');
  }
  @override
  void onDurationChanged(Duration duration) {
    print('onDurationChanged $duration');
  }
  @override
  void onStatusChanged(PlayerStatus status) {
    print('onStatusChanged $status');
  }
  @override
  void onEvent(PlayerStatus status) {
    print('onStatusChanged $status');
  }
}
```
## QA

### how to add options on setting menu?
Just add widgets to player bar `options`, example:
```dart
PlayerBar(player: player, options: [
       SwitchListTile(
         secondary: const Icon(Icons.brightness_2),
         title: const Text("Dark mode"),
       );
])
```
### how to controll auto playing?
use `autoPlay` param:

```dart
var player = Player.asset("/assets/sound.mp3",autoPlay: false);
```

### use only one player
currently you need to dispose the previous player
for example:
```dart
var player = Player.asset("/assets/sound.mp3",autoPlay: false);
player.play()
// ...
player.dispose();
player = Player.network("www.example.com/file.mp3");
```
but i plan it to add somthing like `player.reuse()` to re use player by defrent source
also i will add `Player.disposeAll()` to easly dispose All players

### acces to all players
you can acces to all players by `PlayerController.players` return `List<PlayerController>`


## Source code

check the repository on github (<https://github.com/physia/kflutter/tree/main/kplayer/kplayer>)

## Check list

- [x] add `disposeAll`
- [x] add `setMedia`
- [x] replace setters with async methods
- [x] add more widget
- [ ] support playLists
- [ ] add style option and sub widget

## Support ☺️

Coffee for my mind:

<a href="https://www.buymeacoffee.com/mohamadlounnas"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=mohamadlounnas&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff"></a>

E n g o j :)

