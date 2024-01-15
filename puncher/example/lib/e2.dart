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
    Icons.polyline: PolygonPuncherShape(
      sides: 6,
    ),
    Icons.square: RectPuncherShape(
      borderRadius: BorderRadius.circular(10),
    ),
  };

  IconData selectedShape = Icons.circle;

  double radius = 50;
  double overlap = 0.5;
  double margin = 4;
  bool enabled = true;
  bool inner = true;
  bool outer = true;
  bool inverseEnabled = false;

  var decorations = [
    BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.cyan,
          Colors.blue,
        ],
      ),
    ),
    BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.yellow,
          Colors.orange,
        ],
      ),
    ),
    BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.green,
          Colors.blue,
        ],
      ),
    ),
    BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.purple,
          Colors.pink,
        ],
      ),
    ),
    BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.deepOrange,
          Colors.orange,
        ],
      ),
    ),
  ];

  late BoxDecoration decoration = decorations.first;

  // borderRaidus for the rectangle shape
  BorderRadius borderRadius = BorderRadius.circular(10);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Crescent Difference Example')),
        body: Stack(
          children: [
            Positioned.fill(child: TransparentPattern()),
            Positioned.fill(
              child: SingleChildScrollView(
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
                      selected: {
                        selectedShape
                      },
                    ),
                
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final i in [
                          0,
                          1,
                          2,
                          3,
                        ])
                          Builder(
                            builder: (context) {
                              Widget child = Container(
                                decoration:decoration,
                              );
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  NestedPuncher(
                                    radius: radius,
                                    overlap: overlap,
                                    enabled: enabled,
                                    // shape: shapes[selectedShape],
                                    shape: selectedShape == Icons.square ? RectPuncherShape(borderRadius: borderRadius) : shapes[selectedShape],
                                    margin: margin,
                                    // inner: ,
                                    inner: i != 3 && inner,
                                    outer: outer,
                                    child: child,
                                    punchers: [
                                      // PuncherClip(
                                      //   margin: 3,
                                      //   shape: shapes[selectedShape]!,
                                      //   translate: Offset(.35,.35),
                                      //   alignment: Alignment.bottomLeft,
                                      //   size: const Size(20, 20),
                                      // ),
                                    ],
                                  ),
                                  // green circle at .35*radius/2
                                  // Positioned.directional(
                                  //   textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
                                  //   start: (radius - (20/2))*(1+1-.35)+8,
                                  //   top: (radius - (20/2))*(1+1-.35)+8,
                                  //   child: Container(
                                  //     height: 20,
                                  //     width: 20,
                                  //     decoration: const BoxDecoration(
                                  //       color: Colors.green,
                                  //       shape: BoxShape.circle,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    // borderRadius for rectangle shape
                    if (selectedShape == Icons.square)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('borderRadius'),
                          Slider(
                            value: borderRadius.topLeft.x,
                            min: 0,
                            max: 50,
                            onChanged: (value) {
                              setState(() {
                                borderRadius = BorderRadius.circular(value);
                              });
                            },
                          ),
                        ],
                      ),
                    
                    // decorations select (list of circular buttons)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final decoration in decorations)
                          Builder(
                            builder: (context) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    this.decoration = decoration;
                                  });
                                },
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  margin: const EdgeInsets.all(4),
                                  padding: const EdgeInsets.all(4),
                                  decoration: decoration.copyWith(
                                    shape: BoxShape.circle,
                                    border: decoration == this.decoration
                                        ? Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          )
                                        : null,
                                        boxShadow: decoration == this.decoration?[
                                          BoxShadow(
                                            color: Colors.black.withOpacity(.2),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          )
                                        ]:null,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('radius'),
                        Slider(
                          value: radius,
                          min: 10,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              radius = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('overlap'),
                        Slider(
                          value: overlap,
                          min: 0,
                          max: 1,
                          onChanged: (value) {
                            setState(() {
                              overlap = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('margin'),
                        Slider(
                          value: margin,
                          min: 0,
                          max: 50,
                          onChanged: (value) {
                            setState(() {
                              margin = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('enabled'),
                        Switch(
                          value: enabled,
                          onChanged: (value) {
                            setState(() {
                              enabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('inner'),
                        Switch(
                          value: inner,
                          onChanged: (value) {
                            setState(() {
                              inner = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('outer'),
                        Switch(
                          value: outer,
                          onChanged: (value) {
                            setState(() {
                              outer = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('inverse'),
                        Switch(
                          value: inverse,
                          onChanged: (value) {
                            setState(() {
                              inverse = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('shape'),
                        DropdownButton(
                          value: selectedShape,
                          onChanged: (value) {
                            setState(() {
                              selectedShape = value as IconData;
                            });
                          },
                          items: [
                            for (final shape in shapes.entries)
                              DropdownMenuItem(
                                child: Icon(shape.key),
                                value: shape.key,
                              )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
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
      width: inner ? radius * 2 * overlap : radius * 2,
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
                    translate: Offset((Directionality.maybeOf(context) == TextDirection.rtl ? -1 : 1) * overlap, 0),
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

    canvas.drawPath(CirclePuncherShape().path(const Size(60, 60)), paint..color = Colors.red);

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
          canvas.drawRect(Rect.fromLTWH(i * cubeSize.width, j * cubeSize.height, cubeSize.width, cubeSize.height), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
