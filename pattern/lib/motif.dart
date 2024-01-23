library motif;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shaper/shaper.dart';

class Motif<T> extends StatelessWidget {
  const Motif({
    super.key,
    required this.bounds,
    required this.drawer,
  });

  final Function(Canvas canvas, Rect rect, Size size, T? previous) drawer;
  final Size bounds;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MotifPainter<T>(
        bounds: bounds,
        drawer: drawer,
      ),
    );
  }
}

class TransparentMotif extends StatelessWidget {
  const TransparentMotif({
    super.key,
    this.bounds = const Size(10, 10),
    this.paint,
  });

  final Size bounds;
  final Paint? paint;

  @override
  Widget build(BuildContext context) {
    final opaint = paint ?? Paint()
      ..color = const Color.fromARGB(255, 122, 122, 122).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    return Motif(
      bounds: bounds,
      drawer: (canvas, rect, _, __) {
        bool isTransparent = (rect.top / rect.height + rect.left / rect.width) % 2 == 0;
        if (isTransparent) {
          canvas.drawRect(Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height), opaint);
        }
      },
    );
  }
}

// UPMapMotif
class UPMapMotif extends StatelessWidget {
  const UPMapMotif({
    super.key,
    this.bounds = const Size(30, 30),
  });

  final Size bounds;

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Colors.redAccent,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.deepOrange,
      Colors.teal,
      Colors.indigo,
      Colors.cyan,
    ];
    Color nextColor(Color color) {
      int index = colors.indexWhere((e) => e.value == color.value);
      if (index == -1) {
        return colors.first;
      }
      return colors[(index + 1) % colors.length];
    }

    final opaint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.fill;

    return Motif(
      bounds: bounds,
      drawer: (canvas, rect, _, __) {
        // draw rect with next color and add numbeer in the center
        opaint.color = nextColor(opaint.color);
        canvas.drawRect(Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height), opaint);
        if (bounds.width < 20) {
          return;
        }
        TextPainter(
          text: TextSpan(
            text: '${rect.top ~/ rect.height + rect.left ~/ rect.width}',
            style: TextStyle(
              color: opaint.color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              fontSize: 10,
            ),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        )
          ..layout(minWidth: rect.width, maxWidth: rect.width)
          ..paint(canvas, Offset(rect.left, rect.top));
      },
    );
  }
}

// SinosoidalMotif
class SinosoidalMotif extends StatelessWidget {
  const SinosoidalMotif({
    super.key,
    this.bounds = const Size(10, 10),
    this.color = Colors.grey,
  });

  final Size bounds;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final opaint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    return Motif(
        bounds: bounds,
        drawer: (canvas, rect, _, __) {
          var i = rect.top ~/ rect.height;
          var j = rect.left ~/ rect.width;

          // draw line
          canvas.drawLine(
            Offset(rect.left, rect.top),
            Offset(rect.left + cos(i) * rect.width, rect.top + sin(j) * rect.height),
            opaint,
          );
        });
  }
}

// star Motif
class StarMotif extends StatelessWidget {
  const StarMotif({
    super.key,
    this.bounds = const Size(30, 30),
    this.points = 8,
    this.innerRadiusRatio = 0.8,
    this.pointRounding = 0.1,
    this.valleyRounding = 0.1,
    this.rotation = 0,
    this.squash = 0.3,
    this.side = BorderSide.none,
  });

  final Size bounds;

  /// [side] is the side of the star.
  final BorderSide side;

  /// [points] is the number of points of the star.
  final double points;

  /// [innerRadiusRatio] is the inner radius ratio of the star.
  final double innerRadiusRatio;

  /// [pointRounding] is the point rounding of the star.
  final double pointRounding;

  /// [valleyRounding] is the valley rounding of the star.
  final double valleyRounding;

  /// [rotation] is the rotation of the star.
  final double rotation;

  /// [squash] is the squash of the star.
  final double squash;
  @override
  Widget build(BuildContext context) {
    final opaint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke;

    return Motif(
        bounds: bounds,
        drawer: (canvas, rect, _, __) {
          var i = rect.top ~/ rect.height - 1;
          var j = rect.left ~/ rect.width - 1;

          // change color depending on i and j
          opaint.color = Color.fromARGB(
            (tan(rect.top * rect.left - 1).abs() * 205).toInt(),
            (tan(rect.top * rect.left - 1).abs() * 205).toInt(),
            (tan(rect.top * rect.left - 1).abs() * 205).toInt(),
            (tan(rect.top * rect.left - 1).abs() * 205).toInt(),
          );
          // fiil when luminance is less than 0.5
          if (opaint.color.computeLuminance() < 0.6) {
            opaint.style = PaintingStyle.fill;
          } else {
            opaint.style = PaintingStyle.stroke;
          }

          // use StarBorder to draw star
          var path = StarShape(
            points: points,
            innerRadiusRatio: innerRadiusRatio,
            pointRounding: pointRounding,
            valleyRounding: valleyRounding,
            rotation: rotation,
            squash: squash,
            side: side,
          ).build(
            bounds,
            offset: Offset(rect.left, rect.top),
            // rotation by sin
            // transform: Matrix4.rotationX((tan(i*i*j).toDouble() ))
            // if odd translate by sizw/2
            transform: Matrix4.translationValues(
              i % 2 == 0 ? 0 : bounds.width / 2,
              j % 2 == 0 ? 0 : bounds.height / 2,
              0,
            ),
          );
          canvas.drawPath(path, opaint);
        });
  }
}

class MotifPainter<T> extends CustomPainter {
  MotifPainter({
    required this.bounds,
    required this.drawer,
  });

  final Function(Canvas canvas, Rect rect, Size size, T? previous) drawer;
  final Size bounds;

  @override
  void paint(Canvas canvas, Size size) {
    T? previous;
    for (int i = -10; i <= (size.width / bounds.width) + 20; i++) {
      for (int j = -10; j <= (size.height / bounds.height) + 20; j++) {
        previous = drawer(canvas, Rect.fromLTWH(i * bounds.width, j * bounds.height, bounds.width, bounds.height), size, previous);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
