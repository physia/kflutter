import 'dart:math';

import 'package:flutter/material.dart';
import 'package:puncher/puncher.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool inverse = false;
  /// List of shapes 
  Map<IconData, PuncherShape> shapes = {
    Icons.circle: CirclePuncherShape(),
    Icons.star: StarPuncherShape(
      points: 5,
      innerRadiusRatio: .5,
      pointRounding: .5,
    ),
   Icons.polyline:  PolygonPuncherShape(
      sides: 6,
    ),
  Icons.square:   RectPuncherShape(
      borderRadius: BorderRadius.circular(10),
    ),
  };
  
  IconData selectedShape=Icons.circle;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Crescent Difference Example')),
        body: Stack(
          children: [
            Positioned.fill(child: TransparentPattern()),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: 100,
                  //   width: 100,
                  //   child: CustomPaint(
                  //     painter: ExamplePainter(),
                  //   ),
                  // ),
                  SegmentedButton(
                    segments: [
                      for (final shape in shapes.entries)
                        ButtonSegment(
                          icon: Icon(shape.key),
                          value: shape.key,
                        )
                    ],
                    onSelectionChanged: (value) {
                      setState(() {
                        selectedShape = value.first;
                      });
                    },
                    selected: {selectedShape},
                  ),

                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final i in [0, 1, 2])
                        Builder(
                          builder: (context) {
                            Widget child = Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue,
                                    Colors.red,
                                  ],
                                ),
                              ),
                            );
                            double radius = 50;
                            double overlap = 0.5;
                            double margin = 4;
                            bool enabled = true;
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                NestedPuncher(
                                  radius: radius,
                                  overlap: overlap,
                                  enabled: enabled,
                                  shape: shapes[selectedShape],
                                  margin: margin,
                                  inner: i != 2,
                                  child: child,
                                  punchers: [
                                    PuncherClip(
                                      margin: 3,
                                      shape: shapes[selectedShape]!,
                                      translate: Offset(.35,.35),
                                      size: const Size(20, 20),
                                    ),
                                  ],
                                ),
                                // green circle at .35*radius/2
                                Positioned.directional(
                                  textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
                                  start: (radius - (20/2))*(1+1-.35)+8,
                                  top: (radius - (20/2))*(1+1-.35)+8,
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                
                              ],
                            );
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final i in [0, 1, 2])
                        NestedPuncher(
                          radius: 30,
                          inner: i != 2,
                              shape: shapes[selectedShape],
                          child: ColoredBox(color: Colors.blue),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NestedPuncher extends StatelessWidget {
  const NestedPuncher({
    super.key,
    required this.radius,
    this.overlap = 0.5,
    this.enabled = true,
    this.shape,
    this.margin = 4,
    this.inner = true,
    this.outer = true,
    this.punchers = const [],
    required this.child,
  });

  final List<PuncherClip> punchers;
  final double radius;
  final double overlap;
  final bool enabled;
  final bool inner;
  final bool outer;
  final PuncherShape? shape;
  final double margin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var _shape = shape ?? CirclePuncherShape();
    return Container(
      // color: Colors.yellow,
      height: radius * 2,
      width:inner? radius * 2 * overlap: radius * 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.directional(
            textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
            start: 0,
            child: Puncher(
              enabled: enabled,
              punchers: [
                ...punchers,
                if (outer)
                  PuncherClip(
                    invert: true,
                    shape: _shape,
                  ),
                if (inner)
                  PuncherClip(
                    shape: _shape,
                    margin: margin,
                    translate: Offset(
                        (Directionality.maybeOf(context) == TextDirection.rtl
                                ? -1
                                : 1) *
                            overlap,
                        0),
                  )
              ],
              child: SizedBox.square(
                dimension: radius * 2,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExamplePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke;

    // list of all possible alignments

    // list of all possible alignments
    final alignments = [
      Alignment.topLeft,
      Alignment.topCenter,
      Alignment.topRight,
      Alignment.centerLeft,
      Alignment.center,
      Alignment.centerRight,
      Alignment.bottomLeft,
      Alignment.bottomCenter,
      Alignment.bottomRight,
    ];
    Path path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    for (final alignment in alignments) {
      canvas.drawPath(
          CirclePuncherShape().build(
            size,
            size: const Size(60, 60),
            alignment: alignment,
            // scale
            transform: Matrix4.identity()..scale(2.0, 2.0),
          ),
          paint);
    }

    canvas.drawPath(CirclePuncherShape().path(const Size(60, 60)),
        paint..color = Colors.red);

    // draw rectangle fill canvas
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke,
    );
    // draw line center
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke,
    );
    // draw line center
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class TransparentPattern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PatternPainter(),
    );
  }
}

class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 122, 122, 122).withOpacity(0.1)
      ..style = PaintingStyle.fill;
    Size cubeSize = const Size(10, 10);

    for (int i = 0; i < size.width / cubeSize.width; i++) {
      for (int j = 0; j < size.height / cubeSize.height; j++) {
        bool isTransparent = (i + j) % 2 == 0;
        if (isTransparent) {
          canvas.drawRect(
              Rect.fromLTWH(i * cubeSize.width, j * cubeSize.height,
                  cubeSize.width, cubeSize.height),
              paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
