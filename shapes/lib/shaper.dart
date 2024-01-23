library shapes;

import 'dart:math';

import 'package:flutter/material.dart';

/// [Shaper] is a class that represents a  shape.
/// it have a build that return a [Path] that represents the shape.
/// it also have a [invert] method that return a new [Shaper] that
/// invert the shape (by adding a rectangle that fill the whole widget and then
/// subtract the shape from it).
class Shaper {
  /// [build] is a function that takes:
  /// - [parentSize] is the size of the parent widget.
  /// - [size] is the size of the shape (if null use the parent size).
  /// - [transform] is the transform of the shape.
  /// - [origin] is the origin of the shape.
  /// - [alignment] is the alignment of the shape.
  /// - [offset] is the offset of the shape.
  /// and returns a [Path] that represents the shape.
  Path build(
    Size parentSize, {
    Size? size,
    Matrix4? transform,
    AlignmentGeometry? origin = Alignment.center,
    AlignmentGeometry alignment = Alignment.center,
    Offset? offset,
    Offset? translate,
    double? margin,
  }) {
    // assert that translate is >= -1 and <= 1
    assert(translate == null || (translate.dx >= -1 && translate.dx <= 1), 'translate.dx must be >= -1 and <= 1');
    final Matrix4 result = Matrix4.identity();
    var opath = path(size ?? parentSize);
    var bounds = opath.getBounds();
    if (size != null) {
      result.scale(size.width / bounds.width, size.height / bounds.height);
      bounds = Rect.fromLTWH(
        bounds.left,
        bounds.top,
        size.width,
        size.height,
      );
    }

    // if bounds.topLeft is not zero then we need to translate the shape
    // to the origin
    if (bounds.topLeft != Offset.zero) {
      opath = opath.shift(-bounds.topLeft);
    }

    // in alingment its bit different than origin
    // because we need to translate the shape to the center or corner
    // depending on the alignment
    // we have all needed data in the bounds
    // also we have the parentSize
    // so we can calculate the offset
    final Alignment resolvedAlignment = alignment.resolve(null);
    final Offset resolvedAlignmentOffset = resolvedAlignment.alongSize(parentSize);
    final Offset resolvedBoundsOffset = resolvedAlignment.alongSize(bounds.size);

    result.translate(
      resolvedAlignmentOffset.dx - resolvedBoundsOffset.dx,
      resolvedAlignmentOffset.dy - resolvedBoundsOffset.dy,
    );

    if (translate != null) {
      result.translate(translate.dx * parentSize.width, translate.dy * parentSize.height);
    }

    // if transform is provided use it and apply origin to it
    if (transform != null) {
      Offset? porigin;
      if (origin != null) {
        porigin = origin.resolve(null).alongOffset(
              Offset(
                bounds.width,
                bounds.height,
              ),
            );
        result.translate(porigin.dx, porigin.dy);
      }
      result.multiply(transform);
      if (origin != null) {
        result.translate(-porigin!.dx, -porigin.dy);
      }
    }

    // if margin is provided use it to apply scale transform
    // if (margin != null) {
    //   // var vw = (bounds.width + margin*2) / bounds.width;
    //   // var vh = (bounds.height + margin*2) / bounds.height;
    //   result.scale(1.0, 1.0);
    //   // re align the shape
    //   result.translate(
    //     -margin,
    //     -0.0,
    //   );
    // }

    if (margin != null) {
      var offset = Offset(margin * bounds.width / 2, margin * bounds.height / 2);
      // scale
      opath = opath.transform(Matrix4.diagonal3Values(margin, margin, 2).storage);
      opath = opath.shift(-offset + Offset(bounds.width / 2, bounds.height / 2));
    }

    // offset is the last thing to apply
    if (offset != null) {
      result.translate(offset.dx, offset.dy);
    }

    return opath.transform(result.storage);
  }

  /// [path] is a function that takes a [Size] and returns a [Path]
  final Path Function(Size parentSize) path;
  Shaper({
    required this.path,
  });

  /// [invert] is a function that returns a new [Shaper] that invert the shape.
  Shaper invert() {
    return Shaper(
      path: (size) {
        return Path.combine(
          PathOperation.difference,
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
          path(size),
        );
      },
    );
  }

  /// static shapes
  static Shaper circle({
    double startAngle = 0,
    double endAngle = 2 * pi,
  }) {
    return CircleShape(
      startAngle: startAngle,
      endAngle: endAngle,
    );
  }

  static Shaper rect({
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
  }) {
    return RectShape(
      borderRadius: borderRadius,
    );
  }

  static Shaper star({
    BorderSide side = BorderSide.none,
    double points = 5,
    double innerRadiusRatio = 0.4,
    double pointRounding = 0,
    double valleyRounding = 0,
    double rotation = 0,
    double squash = 0,
  }) {
    return StarShape(
      side: side,
      points: points,
      innerRadiusRatio: innerRadiusRatio,
      pointRounding: pointRounding,
      valleyRounding: valleyRounding,
      rotation: rotation,
      squash: squash,
    );
  }

  static Shaper polygon({
    BorderSide side = BorderSide.none,
    double sides = 5,
    double pointRounding = 0,
    double rotation = 0,
    double squash = 0,
  }) {
    return PolygonShape(
      side: side,
      sides: sides,
      pointRounding: pointRounding,
      rotation: rotation,
      squash: squash,
    );
  }
}

/// [CircleShape] is a class that represents a circle  shape.
/// it have a build that return a [Path] that represents the shape.
/// it also have a [invert] method that return a new [CircleShape] that
/// invert the shape (by adding a rectangle that fill the whole widget and then
/// subtract the shape from it).
class CircleShape extends Shaper {
  /// [startAngle] is the start angle of the circle.
  final double startAngle;

  /// [endAngle] is the end angle of the circle.
  final double endAngle;

  /// [CircleShape] constructor.
  CircleShape({
    this.startAngle = 0,
    this.endAngle = 2 * pi,
  }) : super(
          path: (size) {
            var usedSize = size;
            // if no offset is provided use the center of the widget.
            var usedOffset = Offset(
              (size.width - usedSize.width) / 2,
              (size.height - usedSize.height) / 2,
            );
            var path = Path()
              ..addArc(
                Rect.fromLTWH(
                  usedOffset.dx,
                  usedOffset.dy,
                  usedSize.width,
                  usedSize.height,
                ),
                startAngle,
                endAngle,
              );
            path.close();

            return path;
          },
        );

  /// [invert] is a function that returns a new [CircleShape] that invert the shape.
  @override
  CircleShape invert() {
    return CircleShape();
  }
}

/// [RectShape] is a class that represents a rectangle  shape.
/// it have a build that return a [Path] that represents the shape.
/// it also have a [invert] method that return a new [RectShape] that
/// invert the shape (by adding a rectangle that fill the whole widget and then
/// subtract the shape from it).
/// it also have [borderRadius] property [BorderRadiusGeometry] to control the radius of the rectangle (every corner)
/// use  to control the .
class RectShape extends Shaper {
  /// [borderRadius] is the radius of the rectangle (every corner).
  final BorderRadiusGeometry borderRadius;

  /// [RectShape] constructor.
  RectShape({
    this.borderRadius = BorderRadius.zero,
  }) : super(
          path: (size) {
            var usedSize = size;
            // if no offset is provided use the center of the widget.
            var usedOffset = Offset(
              (size.width - usedSize.width) / 2,
              (size.height - usedSize.height) / 2,
            );
            BorderRadius rr = borderRadius.resolve(TextDirection.rtl);
            var path = Path()
              ..addRRect(
                RRect.fromRectAndCorners(
                  Rect.fromLTWH(
                    usedOffset.dx,
                    usedOffset.dy,
                    usedSize.width,
                    usedSize.height,
                  ),
                  topLeft: rr.topLeft,
                  topRight: rr.topRight,
                  bottomLeft: rr.bottomLeft,
                  bottomRight: rr.bottomRight,
                ),
              );
            path.close();

            return path;
          },
        );
}

/// [StarShape] is a class that represents a star  shape.
/// it have a build that return a [Path] that represents the shape.
/// it also have a [invert] method that return a new [StarShape] that
/// it contains all the properties of [StarBorder] to control the shape.
class StarShape extends Shaper {
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

  /// [StarShape] constructor.
  StarShape({
    this.side = BorderSide.none,
    this.points = 5,
    this.innerRadiusRatio = 0.4,
    this.pointRounding = 0,
    this.valleyRounding = 0,
    this.rotation = 0,
    this.squash = 0,
  }) : super(
          path: (size) {
            var usedSize = size;
            // if no offset is provided use the center of the widget.
            var usedOffset = Offset(
              10 + (size.width - usedSize.width) / 2,
              10 + (size.height - usedSize.height) / 2,
            );
            return StarBorder(
              side: side,
              points: points,
              innerRadiusRatio: innerRadiusRatio,
              pointRounding: pointRounding,
              valleyRounding: valleyRounding,
              rotation: rotation,
              squash: squash,
            ).getOuterPath(
              Rect.fromLTWH(
                usedOffset.dx,
                usedOffset.dy,
                usedSize.width,
                usedSize.height,
              ),
            );
          },
        );
}

/// [PolygonShape] is a class that represents a polygon  shape.
class PolygonShape extends Shaper {
  /// [side] is the side of the polygon.
  final BorderSide side;

  /// [sides] is the number of sides of the polygon.
  final double sides;

  /// [pointRounding] is the point rounding of the polygon.
  final double pointRounding;

  /// [rotation] is the rotation of the polygon.
  final double rotation;

  /// [squash] is the squash of the polygon.
  final double squash;

  /// [PolygonShape] constructor.
  PolygonShape({
    this.side = BorderSide.none,
    this.sides = 5,
    this.pointRounding = 0,
    this.rotation = 0,
    this.squash = 0,
  }) : super(
          path: (size) {
            var usedSize = size;
            // if no offset is provided use the center of the widget.
            var usedOffset = Offset(
              (size.width - usedSize.width) / 2,
              (size.height - usedSize.height) / 2,
            );
            return StarBorder.polygon(
              side: side,
              sides: sides,
              pointRounding: pointRounding,
              rotation: rotation,
              squash: squash,
            ).getOuterPath(
              Rect.fromLTWH(
                usedOffset.dx,
                usedOffset.dy,
                usedSize.width,
                usedSize.height,
              ),
            );
          },
        );
}
