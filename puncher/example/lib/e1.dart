
import 'package:flutter/material.dart';
import 'package:puncher/puncher.dart';
import 'package:shaper/shaper.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool inverse = false;
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
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: CustomPaint(
                      painter: ExamplePainter(),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final i in [1,2,3])
                      Puncher(
                        punchers: [
                          // PuncherClip(
                          //   // invert: true,
                          //   shape: CirclePuncherShape(),
                          //   size: const Size(20, 20),
                          // ),
                          // PuncherClip(
                          //   // invert: true,
                          //   shape: RectPuncherShape(
                          //     borderRadius: BorderRadius.circular(20),
                          //   ),
                          //   translate: const Offset(.5, 0),
                          //   // rotate
                          //   transform: Matrix4.identity()..rotateZ(pi / 2),
                          // ),
                          PuncherClip(
                            // invert: true,
                            shape: StarShape(
                              
                            ),
                            // translate: const Offset(0, 0.5),
                            // rotate
                            // transform: Matrix4.identity()..rotateZ(pi / 2),

                            // scale
                            // transform: Matrix4.identity()..scale(2.0, 2.0),
                          ),
                          PuncherClip(
                            // invert: true,
                            shape: PolygonShape(
                              sides: 8,
                            ),
                          )
                        ],
                        child: SizedBox.square(
                          dimension: 100,
                          child: Material(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.blue,
                          ),
                        ),
                      ),
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
          CircleShape().build(
            size,
            size: Size(60, 60),
            alignment: alignment,
            // scale
            transform: Matrix4.identity()..scale(2.0, 2.0),
          ),
          paint);
    }

    canvas.drawPath(
        CircleShape().path(Size(60, 60)), paint..color = Colors.red);

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
