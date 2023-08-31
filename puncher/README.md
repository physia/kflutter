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