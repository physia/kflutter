library shapes;

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// [Shape] is a base class for all shapes.
abstract class Shape {
  /// [offset] is the offset to apply to the shape.
  Offset offset;

  /// [transform] is the transformation matrix to apply to the shape.
  Matrix4 transform;

  /// [path] is the path of the shape.
  Path path;

  /// [paint] is the paint to use to draw the shape.
  Paint paint;

  /// [Shape] is a base class for all shapes.
  Shape({
    this.offset = Offset.zero,
    Matrix4? transform,
    Path? path,
    Paint? paint,
  })  : transform = transform ?? Matrix4.identity(),
        path = path ?? Path(),
        paint = paint ?? Paint();

  /// [build] is a method that returns a [Path] for the shape.
  Path build(Size size, {Offset offset = Offset.zero, Matrix4? transform});

  /// [draw] is a method that draws the shape on the [Canvas].
  void draw(Canvas canvas, Size size, {Offset offset = Offset.zero, Matrix4? transform}) {
    canvas.drawPath(build(size, offset: offset, transform: transform), Paint());
  }
}

/// [CircleShape] is a shape that draws a circle.
/// param [radius] is the radius of the circle.
/// param [center] is the center of the circle.
/// param [transform] is the transformation matrix to apply to the shape.
/// param [offset] is the offset to apply to the shape.
/// param [paint] is the paint to use to draw the shape.
/// param [angle] is the angle of the circle. (it can be half circle for example)
class CircleShape extends Shape {
  /// [radius] is the radius of the circle.
  double radius;

  /// [center] is the center of the circle.
  Offset center;

  /// [angle] is the angle of the circle. (it can be half circle for example)
  double angle;

  /// [startAngle] is the start angle of the circle.
  double startAngle; 

  /// [CircleShape] is a shape that draws a circle.
  /// param [radius] is the radius of the circle.
  /// param [center] is the center of the circle.
  /// param [transform] is the transformation matrix to apply to the shape.
  /// param [offset] is the offset to apply to the shape.
  /// param [paint] is the paint to use to draw the shape.
  /// param [angle] is the angle of the circle. (it can be half circle for example)
  CircleShape({
    required this.radius,
    required this.center,
    this.angle = 2 * pi,
    super.transform,
    super.paint,
    this.startAngle = 0,
  }) : super(
          offset: center - Offset(radius, radius),
        );

  /// [build] is a method that returns a [Path] for the shape.
  @override
  Path build(Size size, {Offset offset = Offset.zero, Matrix4? transform}) {
    final path = Path();
    path.addArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      startAngle,
      angle,
    );
    // apply transformation if exists
    if (transform != null) {
      path.transform(transform.storage);
    }
    return path;
  }


  /// override == operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CircleShape &&
        other.radius == radius &&
        other.center == center &&
        other.angle == angle &&
        other.startAngle == startAngle &&
        other.offset == offset &&
        other.transform == transform &&
        other.path == path &&
        other.paint == paint;
  }

  /// override hashcode
  @override
  int get hashCode {
    return radius.hashCode ^
        center.hashCode ^
        angle.hashCode ^
        startAngle.hashCode ^
        offset.hashCode ^
        transform.hashCode ^
        path.hashCode ^
        paint.hashCode;
  }
}


/// [RectangleShape] is a shape that draws a rectangle.
/// param [rect] is the rectangle to draw.
/// param [transform] is the transformation matrix to apply to the shape.
/// param [offset] is the offset to apply to the shape.
/// param [paint] is the paint to use to draw the shape.
/// param [borderRadius] is the border radius of the rectangle.
class RectangleShape extends Shape {
  /// [rect] is the rectangle to draw.
  Rect rect;

  /// [borderRadius] is the border radius of the rectangle.
  BorderRadius borderRadius;

  /// [RectangleShape] is a shape that draws a rectangle.
  /// param [rect] is the rectangle to draw.
  /// param [transform] is the transformation matrix to apply to the shape.
  /// param [offset] is the offset to apply to the shape.
  /// param [paint] is the paint to use to draw the shape.
  /// param [borderRadius] is the border radius of the rectangle.
  RectangleShape({
    required this.rect,
    this.borderRadius = BorderRadius.zero,
    super.transform,
    super.paint,
  }) : super(
          offset: rect.topLeft,
        );

  /// [build] is a method that returns a [Path] for the shape.
  @override
  Path build(Size size, {Offset offset = Offset.zero, Matrix4? transform}) {
    final path = Path();
    path.addRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      ),
    );
    // apply transformation if exists
    if (transform != null) {
      path.transform(transform.storage);
    }
    return path;
  }

  /// override == operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RectangleShape &&
        other.rect == rect &&
        other.borderRadius == borderRadius &&
        other.offset == offset &&
        other.transform == transform &&
        other.path == path &&
        other.paint == paint;
  }

  /// override hashcode
  @override
  int get hashCode {
    return rect.hashCode ^
        borderRadius.hashCode ^
        offset.hashCode ^
        transform.hashCode ^
        path.hashCode ^
        paint.hashCode;
  }
}


/// [TriangleShape] is a shape that draws a triangle.
/// param [borderRadius] is the border radius of the triangle.
/// param [factor] is the factor to apply to the triangle. (double, double, double) for each side. by default it's (1, 1, 1)
/// param [center] is the center of the triangle.
/// param [transform] is the transformation matrix to apply to the shape.
/// param [offset] is the offset to apply to the shape.
/// param [paint] is the paint to use to draw the shape.
class TriangleShape extends Shape {
  /// [borderRadius] is the border radius of the triangle.
  BorderRadius borderRadius;

  /// [factor] is the factor to apply to the triangle. (double, double, double) for each side. by default it's (1, 1, 1)
  (double,double,double) factor;

  /// [center] is the center of the triangle.
  Offset center;

  /// [TriangleShape] is a shape that draws a triangle.
  /// param [borderRadius] is the border radius of the triangle.
  /// param [factor] is the factor to apply to the triangle. (double, double, double) for each side. by default it's (1, 1, 1)
  /// param [center] is the center of the triangle.
  /// param [transform] is the transformation matrix to apply to the shape.
  /// param [offset] is the offset to apply to the shape.
  /// param [paint] is the paint to use to draw the shape.
  TriangleShape({
    this.borderRadius = BorderRadius.zero,
    this.factor = (1,1,1),
    required this.center,
    super.transform,
    super.paint,
  }) : super(
          offset: center,
        );

  /// [build] is a method that returns a [Path] for the shape.
  @override
  Path build(Size size, {Offset offset = Offset.zero, Matrix4? transform}) {
    final path = Path();
    final radius = min(size.width, size.height) / 2;
    final centerOffset = Offset(size.width / 2, size.height / 2);
    

    // in normal case where radius = 0
    // path.moveTo(centerOffset.dx, centerOffset.dy - radius * factor.$1);
    // path.lineTo(centerOffset.dx - radius * factor.$2, centerOffset.dy + radius * factor.$2);
    // path.lineTo(centerOffset.dx + radius * factor.$2, centerOffset.dy + radius * factor.$3);
    // path.close();
    // but if the radius is for example 10, we need to add the radius to the path
    var borderRadius = 10.0;
    // we need to draw arc for each corner
    // draw first rouded corner
    path.arcTo(
      Rect.fromCircle(
        center: centerOffset + Offset(0, -radius * factor.$1),
        radius: borderRadius,
      ),
      pi,
      pi / 2,
      false,
    );
    // draw second rouded corner
    path.arcTo(
      Rect.fromCircle(
        center: centerOffset + Offset(-radius * factor.$2, radius * factor.$2),
        radius: borderRadius,
      ),
      pi * 1.5,
      pi / 2,
      false,
    );
    // draw third rouded corner
    path.arcTo(
      Rect.fromCircle(
        center: centerOffset + Offset(radius * factor.$2, radius * factor.$3),
        radius: borderRadius,
      ),
      pi * 2,
      pi / 2,
      false,
    );
    // draw last rouded corner
    path.arcTo(
      Rect.fromCircle(
        center: centerOffset + Offset(0, -radius * factor.$1),
        radius: borderRadius,
      ),
      pi * 2.5,
      pi / 2,
      false,
    );

    
    

    // apply transformation if exists
    if (transform != null) {
      path.transform(transform.storage);
    }
    return path;
  }

  /// override
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TriangleShape &&
        other.borderRadius == borderRadius &&
        other.factor == factor &&
        other.center == center &&
        other.offset == offset &&
        other.transform == transform &&
        other.path == path &&
        other.paint == paint;
  }

  /// override
  @override
  int get hashCode {
    return borderRadius.hashCode ^
        factor.hashCode ^
        center.hashCode ^
        offset.hashCode ^
        transform.hashCode ^
        path.hashCode ^
        paint.hashCode;
  }

}