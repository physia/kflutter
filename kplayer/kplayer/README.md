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
### windows
because of this issue: <https://github.com/bluefireteam/audioplayers/issues/1119>
if want to use kplayer_with_audioplayers, use this on pubspec.yaml:

```yaml
dependency_overrides:
  audioplayers_windows:
    git:
      url: https://github.com/kflutter/audioplayers
      path: packages/audioplayers_windows
      ref: 263b4cc648d39a79455c221897a2c699f9d1c4c0
```
thanks to [maintel](https://github.com/maintel)

### macos

on macos if you using just_audio you may need to do some changes
> I was able to build the project example when macos/Podfile replace platform :osx, '10.11' to platform :osx, '10.15'. Furthermore, adding to macos/Runner/DebugProfile.entitlements and macos/Runner/Release.entitlements:
> ```xml
> <key>com.apple.security.network.client</key>
> <true/>
> ```
thanks to [Andresit0](https://github.com/Andresit0) 

### specify platform
now u can specify the packages u want to use in every platform dynamically
```dart
// by default:
Map<PlatformEnv, PlayerAdaptivePackage?> platforms = {
  PlatformEnv.web: PlayerAdaptivePackage(
    factory: just_audio.Player.new,
    name: 'just_audio',
  ),
  PlatformEnv.ios: PlayerAdaptivePackage(
    factory: just_audio.Player.new,
    name: 'just_audio',
  ),
  PlatformEnv.android: PlayerAdaptivePackage(
    factory: just_audio.Player.new,
    name: 'just_audio',
  ),
  PlatformEnv.windows: PlayerAdaptivePackage(
    factory: audioplayers.Player.new,
    name: 'audioplayers',
  ),
  PlatformEnv.linux: PlayerAdaptivePackage(
    factory: audioplayers.Player.new,
    name: 'audioplayers',
  ),
  PlatformEnv.macos: PlayerAdaptivePackage(
    factory: just_audio.Player.new,
    name: 'just_audio',
  ),
  PlatformEnv.fuchsia: null, // [Hope to add fuchsia support],
};
```
### change or add ur own implementation
learn more [here](https://pub.dev/packages/kplayer_platform_interface)
```dart
Player.platforms[PlatformEnv.<platform>] = PlayerAdaptivePackage(
    factory: <custom_package>.Player.new,
    name: 'custom_package',
);
```

### packages has wrapper

- just_audio (kplayer_with_just_audio)
- audioplayers (kplayer_with_audioplayers)
- dart_vlc (kplayer_with_dart_vlc)

## Getting Started

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
player.player; // the package player instance for more option `dart_vlc`, `audioplayers` , `just_audio`

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

## Source code

check the repository on github (<https://github.com/physia/kflutter/tree/main/kplayer/kplayer>)

## Support ☺️

Coffee for my mind:

<a href="https://www.buymeacoffee.com/mohamadlounnas"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=mohamadlounnas&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff"></a>

E n g o j :)

## Check list

- soon...
