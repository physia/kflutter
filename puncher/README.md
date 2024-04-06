<img src="https://github.com/physia/kflutter/assets/22839194/4e2b8a7e-b5d4-4f87-88c4-e1b6c1f11a06" width=800>

# Puncher
  this package allow to to punch a hole in any widget using flutter's `CustomClipper` class.
you can also use `PuncherShape` wish contains some pre-defined shapes or use your custom shape by passing a `Path` to the `PuncherShape` or extend the `PuncherShape` class and override the `path` method.

## Usage
```dart
ClipPath(
    clipper: PuncherClipper(
        shapes: [
            // draw a circle at the center of the widget
            PuncherShape.circle(
              center: const Offset(50, 50),
              radius: 50,
            ),

            // draw a rectangle at the top left corner of the widget
            PuncherShape.rect(
              size: const Size(20, 20),
            ),
            
            // draw a polygon at the center of the widget
            PuncherShape.polygon(
              size: const Size(100, 50),
              pointRounding: 0.4,
              sides: 8,
              rotation: 180 / 8,
            )
                // you can apply a transformation to the shape
                .transform(
                    offset: Offset(50, 50),
                    origin: Alignment.center,
                    transform: Matrix4.identity()
                        // rotate 60 degree
                        ..rotateZ(pi / 9)
                        ..scale(0.5.toDouble(), 0.9.toDouble()),
                )
        ],
    ),
    child: Container(
        width: 200,
        height: 200,
        color: Colors.red,
    ),
)
```

## Widgets

`NestedPuncher` take car of the canses like nested avatars, it just do margin calculation for you.
but its better to use `GroupNestedPuncher` wish is more flexible and allow you to add any widget to the group.
```dart
GroupNestedPuncher(
  radius: 50,
  overlap: 0.5,
  children: [
    CircleAvatar(
      radius: 50,
      backgroundImage: NetworkImage(
          'https://avatars.githubusercontent.com/u/19484515?v=4'),
    ),
    CircleAvatar(
      radius: 50,
      backgroundImage: NetworkImage(
          'https://avatars.githubusercontent.com/u/19484515?v=4'),
    ),
  ],
);
```
this take care of everything if you case just nested avatars.

## Other projects?

check my other projects:

1. [osrm](https://pub.dev/packages/osrm): Open Source Routing Machine (OSRM) client for Dart.
2. [indexed](https://pub.dev/packages/indexed): indexed widget, allow you to order the items inside stack, sothing like `z-index`.
3. [kplayer](https://pub.dev/packages/kplayer): audio player that support all platforms.
4. [puncher](https://pub.dev/packages/puncher): puncher is a flutter package that helps you to create a puncher widget.
5. [flutter_map_cached_tile_provider](https://pub.dev/packages/flutter_map_cached_tile_provider): cache for `flutter_map` plugin.
6. [latlng_picker](https://pub.dev/packages/latlng_picker): loaction picker for `flutter_map` plugin.
7. [motif](https://pub.dev/packages/motif): patterns for flutter.
8. [shaper](https://pub.dev/packages/shaper): shapes for flutter.


## Support/Job?

contact me: mohamadlounnas@gmail.com