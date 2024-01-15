// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

library puncher;

import 'dart:math';

import 'package:flutter/material.dart';
export './widgets/nested_puncher.dart';

/// final api
/// ```dart
/// Puncher(
///   punchers: [
///     PuncherClip(
///       shape: PuncherShape.circle().invert(),
///       alignment: Alignment.center,
///       offset: Offset(50, 0),
///       origin: Offset(20, 0),
///       size: Size(100, 100),
///       transform: Matrix4.rotationZ(20),
///     ),
///   ],
///   child: ColoredBox(
///     color: Colors.blue,
///     child: Text('punch hole'),
///   ),
/// )
/// ```

/// [PuncherClip] is a class that contains the data of a [PuncherShape].
class PuncherClip {
  /// [invert] is a bool that indicate if the shape should be inverted.
  final bool invert;

  /// [shape] is the shape of the puncher.
  final PuncherShape shape;

  /// [offset] is the offset of the shape.
  final Offset offset;

  /// [size] is the size of the shape.
  final Size? size;

  /// [transform] is the transform of the shape.
  final Matrix4? transform;

  /// [origin] is the origin of the shape.
  final AlignmentGeometry origin;

  /// [alignment] is the alignment of the shape.
  final AlignmentGeometry alignment;

  /// [margin] is the margin of the shape.
  /// it used to apply a scale transform to the shape.
  /// for example if the margin is 10 and the shape is 100x100
  /// the shap will scalled to be 120x120.
  final double? margin;

  /// [translate] is the translate of the shape.
  /// it is a value between -1 and 1.
  final Offset? translate;

  /// [PuncherClip] constructor.
  const PuncherClip({
    required this.shape,
    this.margin,
    this.size,
    this.transform,
    this.origin = Alignment.center,
    this.alignment = Alignment.center,
    this.offset = Offset.zero,
    this.invert = false,
    this.translate,
  });

  /// [PuncherClip.invert] constructor.
  const PuncherClip.invert({
    required this.shape,
    this.size,
    this.margin,
    this.transform,
    this.translate,
    this.origin = Alignment.center,
    this.alignment = Alignment.center,
    this.offset = Offset.zero,
  }) : invert = true;

  /// [build] is a function that takes:
  /// - [parentSize] is the size of the parent widget.
  /// and returns a [PuncherClipper] that represents the shape.
  /// it use the [PuncherClip] data to build the [PuncherClipper].
  /// it also use the [parentSize] to calculate the size of the shape.
  /// if the [size] is null.
  /// it also use the [parentSize] to calculate the transform of the shape.
  /// if the [transform] is null.
  Path build(Size parentSize) {
    return shape.build(
      parentSize,
      size: size,
      transform: transform,
      origin: origin,
      alignment: alignment,
      offset: offset,
      translate: translate,
      margin: margin
    );
  }
}

/// [Puncher] is a widget that clips a child widget with a puncher shape.
/// it takes list of [PuncherClipper]s to draw the puncher shape.
class Puncher extends StatelessWidget {
  /// [punchers] is the list of [PuncherClipper]s to draw the puncher shape.
  final List<PuncherClip> punchers;

  /// [child] is the child widget to be clipped.
  final Widget child;

  /// [clipBehavior] is the clip behavior of the widget.	
  final Clip clipBehavior;

  /// [enabled] is a bool that indicate if the puncher is enabled or not.
  final bool enabled;

  /// [Puncher] constructor.
  const Puncher({
    super.key,
    required this.punchers,
    this.clipBehavior = Clip.antiAlias,
    this.enabled = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return
    enabled? Stack(
      children: [
        
        ClipPath(
          clipBehavior: clipBehavior,
          clipper: PuncherClipper(punchers: punchers),
          child: child,
        ),
        // draw for debug
        Positioned.fill(
          child: CustomPaint(
            painter: 
          PuncherPainter(
            punchers: punchers
          ),
          ),
        )
      ],
    ):child;
  }
}
/// [PuncherPainter] is jus custom painter drow every thing to debug
class PuncherPainter extends CustomPainter {
  final List<PuncherClip> punchers;
  const PuncherPainter({
    required this.punchers
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke;
      
    
    /// first create a rectangle path filling the whole widget.
    var path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    /// loop over the shapes and use [Path.combine] every two shapes
    /// to combine them together.
    for (int i = 0; i < punchers.length; i++) {
      PuncherClip puncher = punchers[i];
      canvas.drawPath(
          puncher.build(size),
          paint);
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
/// [PuncherShape] is a class that represents a puncher shape.
/// it have a build that return a [Path] that represents the shape.
/// it also have a [invert] method that return a new [PuncherShape] that
/// invert the shape (by adding a rectangle that fill the whole widget and then
/// subtract the shape from it).
class PuncherShape {
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
    assert(translate == null || (translate.dx >= -1 && translate.dx <= 1),
        'translate.dx must be >= -1 and <= 1');
    final Matrix4 result = Matrix4.identity();
    final opath = path(size ?? parentSize);
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

    // in alingment its bit different than origin
    // because we need to translate the shape to the center or corner
    // depending on the alignment
    // we have all needed data in the bounds
    // also we have the parentSize
    // so we can calculate the offset
    final Alignment resolvedAlignment = alignment.resolve(null);
    final Offset resolvedAlignmentOffset =
        resolvedAlignment.alongSize(parentSize);
    final Offset resolvedBoundsOffset =
        resolvedAlignment.alongSize(bounds.size);

    result.translate(
      resolvedAlignmentOffset.dx - resolvedBoundsOffset.dx,
      resolvedAlignmentOffset.dy - resolvedBoundsOffset.dy,
    );

    if (translate != null) {
      result.translate(
          translate.dx * parentSize.width, translate.dy * parentSize.height);
    }

    
    // if transform is provided use it and apply origin to it
    if (transform != null) {
      Offset? _origin;
      if (origin != null) {
        _origin = origin.resolve(null).alongOffset(
              Offset(
                bounds.width,
                bounds.height,
              ),
            );
        result.translate(_origin.dx, _origin.dy);
      }
      result.multiply(transform);
      if (origin != null) {
        result.translate(-_origin!.dx, -_origin.dy);
      }
    }

    // if margin is provided use it to apply scale transform
    if (margin != null) {
      // var vw = (bounds.width + margin*2) / bounds.width;
      // var vh = (bounds.height + margin*2) / bounds.height;
      result.scale(
        1.0,
        1.0
      );
      // re align the shape
      result.translate(
        -margin,
        -0.0,
      );
    }

    // if (margin != null) {
    //   var vw = (bounds.width + margin*2) / bounds.width;
    //   var vh = (bounds.height + margin*2) / bounds.height;
      
    //   result.scale(
    //     vw,
    //     vw
    //   );
    //    var _origin = origin!.resolve(null).alongOffset(
    //           Offset(
    //             margin,
    //             margin,
    //           ),
    //         );
    //   // re align the shape
    //     result.translate(-_origin!.dx, -_origin.dy);
    // }


    // offset is the last thing to apply
    if (offset != null) {
      result.translate(offset.dx, offset.dy);
    }


    return opath.transform(result.storage);
  }

  /// [path] is a function that takes a [Size] and returns a [Path]
  final Path Function(Size parentSize) path;
  PuncherShape({
    required this.path,
  });

  /// [invert] is a function that returns a new [PuncherShape] that invert the shape.
  PuncherShape invert() {
    return PuncherShape(
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
  static PuncherShape circle({
    double startAngle = 0,
    double endAngle = 2 * pi,
  }) {
    return CirclePuncherShape(
      startAngle: startAngle,
      endAngle: endAngle,
    );
  }

  static PuncherShape rect({
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
  }) {
    return RectPuncherShape(
      borderRadius: borderRadius,
    );
  }

  static PuncherShape star({
    BorderSide side = BorderSide.none,
    double points = 5,
    double innerRadiusRatio = 0.4,
    double pointRounding = 0,
    double valleyRounding = 0,
    double rotation = 0,
    double squash = 0,
  }) {
    return StarPuncherShape(
      side: side,
      points: points,
      innerRadiusRatio: innerRadiusRatio,
      pointRounding: pointRounding,
      valleyRounding: valleyRounding,
      rotation: rotation,
      squash: squash,
    );
  }

  static PuncherShape polygon({
    BorderSide side = BorderSide.none,
    double sides = 5,
    double pointRounding = 0,
    double rotation = 0,
    double squash = 0,
  }) {
    return PolygonPuncherShape(
      side: side,
      sides: sides,
      pointRounding: pointRounding,
      rotation: rotation,
      squash: squash,
    );
  }

}

/// [CirclePuncherShape] is a class that represents a circle puncher shape.
/// it have a build that return a [Path] that represents the shape.
/// it also have a [invert] method that return a new [CirclePuncherShape] that
/// invert the shape (by adding a rectangle that fill the whole widget and then
/// subtract the shape from it).
class CirclePuncherShape extends PuncherShape {
  /// [startAngle] is the start angle of the circle.
  final double startAngle;

  /// [endAngle] is the end angle of the circle.
  final double endAngle;

  /// [CirclePuncherShape] constructor.
  CirclePuncherShape({
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

  /// [invert] is a function that returns a new [CirclePuncherShape] that invert the shape.
  @override
  CirclePuncherShape invert() {
    return CirclePuncherShape();
  }
}

/// [RectPuncherShape] is a class that represents a rectangle puncher shape.
/// it have a build that return a [Path] that represents the shape.
/// it also have a [invert] method that return a new [RectPuncherShape] that
/// invert the shape (by adding a rectangle that fill the whole widget and then
/// subtract the shape from it).
/// it also have [borderRadius] property [BorderRadiusGeometry] to control the radius of the rectangle (every corner)
/// use  to control the .
class RectPuncherShape extends PuncherShape {
  /// [borderRadius] is the radius of the rectangle (every corner).
  final BorderRadiusGeometry borderRadius;

  /// [RectPuncherShape] constructor.
  RectPuncherShape({
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

/// [StarPuncherShape] is a class that represents a star puncher shape.
/// it have a build that return a [Path] that represents the shape.
/// it also have a [invert] method that return a new [StarPuncherShape] that
/// it contains all the properties of [StarBorder] to control the shape.
class StarPuncherShape extends PuncherShape {
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

  /// [StarPuncherShape] constructor.
  StarPuncherShape({
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
              10+(size.width - usedSize.width) / 2,
              10+(size.height - usedSize.height) / 2,
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

/// [PolygonPuncherShape] is a class that represents a polygon puncher shape.
class PolygonPuncherShape extends PuncherShape {
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

  /// [PolygonPuncherShape] constructor.
  PolygonPuncherShape({
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



/// [PuncherClipper] is a [CustomClipper] that clips a child widget with a
/// puncher shape.
/// it takes list of [PuncherShape]s to draw the puncher shape.
class PuncherClipper extends CustomClipper<Path> {
  /// [punchers] is the list of [PuncherClip]s to draw the puncher shape.
  final List<PuncherClip> punchers;

  /// [PuncherClipper] constructor.
  PuncherClipper({
    required this.punchers,
  });

  @override
  Path getClip(Size size) {
    /// first create a rectangle path filling the whole widget.
    var path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    /// loop over the shapes and use [Path.combine] every two shapes
    /// to combine them together.
    for (int i = 0; i < punchers.length; i++) {
      PuncherClip puncher = punchers[i];
      Path p = puncher.build(size);
      if (puncher.invert) {
        p = Path.combine(
          PathOperation.difference,
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
          p,
        );
      }

      path = Path.combine(
        PathOperation.difference,
        path,
        p,
      );
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}












/*
/// [PuncherShapeData] is a class that contains the data of a [PuncherShape].
class PuncherShapeData {
  /// [offset] is the offset of the shape.
  final Offset offset;

  /// [size] is the size of the shape.
  final Size? size;

  /// [transform] is the transform of the shape.
  final Matrix4? transform;

  /// [origin] is the origin of the shape.
  final AlignmentGeometry origin;

  /// [alignment] is the alignment of the shape.
  final AlignmentGeometry alignment;

  /// [PuncherShapeData] constructor.
  const PuncherShapeData({
    this.size,
    this.transform,
    this.origin = Alignment.center,
    this.alignment = Alignment.center,
    this.offset = Offset.zero,
  });
}


/// [PuncherClipper] is a [CustomClipper] that clips a child widget with a
/// puncher shape.
/// it takes list of [PuncherShape]s to draw the puncher shape.

/// [PuncherShape] is a class that represents a puncher shape.
/// it have a build that return a [Path] that represents the shape.
class PuncherShape {
  /// [path] is a function that takes a [Size] and returns a [Path]
  final Path Function({required Size parentSize,required PuncherShapeData data}) path;

  /// [data] is a [PuncherShapeData] that contains the data of the shape.
  final PuncherShapeData data;

  /// constructor for [PuncherShape]
  PuncherShape({
    required this.path,
    this.data = const PuncherShapeData(),
  });

  /*
  /// [transform] is a function that takes a [transform] and [origin] and [offset] and returns a [PuncherShape]
  PuncherShape transform({
    Matrix4? transform,
    AlignmentGeometry origin = Alignment.center,
    AlignmentGeometry alignment = Alignment.center,
    Offset offset = Offset.zero,
    Size? size,
  }) {
    return PuncherShape(
      path: ({required Size parentSize,required PuncherShapeData data}) {
        final Matrix4 result = Matrix4.identity();
        var userdSize = size ?? size ?? constraints.biggest;
        
        // apply the size
        if (size != null) {
          result.scale(size.width / userdSize.width, size.height / userdSize.height);
          userdSize = size;
        }
        final Alignment resolvedAlignment = origin.resolve(null);
        final Offset resolvedAlignmentOffset =
            resolvedAlignment.alongSize(userdSize);
        final Offset resolvedOriginOffset =
            -origin.resolve(null).alongSize(userdSize);

        result.translate(offset.dx, offset.dy);
        result.translate(
            resolvedAlignmentOffset.dx, resolvedAlignmentOffset.dy);
        if (transform != null) {
          result.multiply(transform);
        }
        result.translate(resolvedOriginOffset.dx, resolvedOriginOffset.dy);
        
        return path(userdSize).transform(result.storage);
      },
    );
  }


  /// [PuncherShape.rect] is a factory constructor that returns a [PuncherShape]
  factory PuncherShape.rect({
    Radius? radius,
  }) {
    return PuncherShape(
      path: (_size) {
        var usedSize = _size;
        // if no offset is provided use the center of the widget.
        var usedOffset = Offset(
          (_size.width - usedSize.width) / 2,
          (_size.height - usedSize.height) / 2,
        );
        var path = Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(
                usedOffset.dx,
                usedOffset.dy,
                usedSize.width,
                usedSize.height,
              ),
              radius ?? Radius.zero,
            ),
          );

        return path;
      },
    );
  }

  /// [PuncherShape.circle] is a factory constructor that returns a [PuncherShape]
  factory PuncherShape.circle() {
    return PuncherShape(
      path: (_size) {
        var usedSize = _size;
        // if no offset is provided use the center of the widget.
        var usedOffset = Offset(
          (_size.width - usedSize.width) / 2,
          (_size.height - usedSize.height) / 2,
        );
        var path = Path()
          ..addOval(
            Rect.fromLTWH(
              usedOffset.dx,
              usedOffset.dy,
              usedSize.width,
              usedSize.height,
            ),
          );

        return path;
      },
    );
  }

  /// [PuncherShape.star] is a factory constructor that returns a [PuncherShape]
  /// it uses [StarBorder] to draw a star shape.
  /// but the same api as [PusherShape.rect] and [PusherShape.circle] is used.
  /// not the old one that are commented below.
  /// that mean also not offset
  factory PuncherShape.star({
    BorderSide side = BorderSide.none,
    double points = 5,
    double innerRadiusRatio = 0.4,
    double pointRounding = 0,
    double valleyRounding = 0,
    double rotation = 0,
    double squash = 0,
  }) {
    return PuncherShape(
      path: (_size) {
        var usedSize = _size;
        // if no offset is provided use the center of the widget.
        var usedOffset = Offset(
          (_size.width - usedSize.width) / 2,
          (_size.height - usedSize.height) / 2,
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

  /// [PuncherShape.polygon] is a factory constructor that returns a [PuncherShape]
  /// it uses [StarBorder.polygon] to draw a polygon shape.
  /// but the same api as [PusherShape.rect] and [PusherShape.circle] is used.
  /// not the old one that are commented below.
  /// that mean also not offset
  factory PuncherShape.polygon({
    BorderSide side = BorderSide.none,
    double sides = 5,
    double pointRounding = 0,
    double rotation = 0,
    double squash = 0,
  }) {
    return PuncherShape(
      path: (_size) {
        var usedSize = _size;
        // if no offset is provided use the center of the widget.
        var usedOffset = Offset(
          (_size.width - usedSize.width) / 2,
          (_size.height - usedSize.height) / 2,
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


  // /// [PuncherShape.star] it uses [StarBorder] to draw a star shape.
  // /// it allow all the properties of [StarBorder] to be used.
  // factory PuncherShape.star({
  //   BorderSide side = BorderSide.none,
  //   double points = 5,
  //   double innerRadiusRatio = 0.4,
  //   double pointRounding = 0,
  //   double valleyRounding = 0,
  //   double rotation = 0,
  //   double squash = 0,
  //   Offset? offset,

  //   /// [offsetBuilder] is a function that takes a [Size] and returns an [Offset]
  //   Offset Function(Size size)? offsetBuilder,
  //   Size? size,

  //   /// [sizeBuilder] is a function that takes a [Size] and returns a [Size]
  //   Size Function(Size size)? sizeBuilder,
  // }) {
  //   return PuncherShape(
  //     path: (_size) {
  //       var usedSize = size ?? sizeBuilder?.call(_size) ?? _size;
  //       var usedOffset = offset ??
  //           offsetBuilder?.call(_size) ??
  //           Offset(
  //             (_size.width - usedSize.width) / 2,
  //             (_size.height - usedSize.height) / 2,
  //           );
  //       return StarBorder(
  //         side: side,
  //         points: points,
  //         innerRadiusRatio: innerRadiusRatio,
  //         pointRounding: pointRounding,
  //         valleyRounding: valleyRounding,
  //         rotation: rotation,
  //         squash: squash,
  //       ).getOuterPath(
  //         Rect.fromLTWH(
  //           usedOffset.dx,
  //           usedOffset.dy,
  //           usedSize.width,
  //           usedSize.height,
  //         ),
  //       );
  //     },
  //   );
  // }

  // /// [PuncherShape.polygon] it uses [StarBorder.polygon] to draw a polygon shape.
  // /// it allow all the properties of [StarBorder.polygon] to be used.
  // factory PuncherShape.polygon({
  //   BorderSide side = BorderSide.none,
  //   double sides = 5,
  //   double pointRounding = 0,
  //   double rotation = 0,
  //   double squash = 0,
  //   Offset? offset,
  //   Size? size,
  // }) {
  //   return PuncherShape(
  //     path: (_size) {
  //       var usedSize = size ?? _size;
  //       // if no offset is provided use the center of the widget.
  //       var usedOffset = offset ??
  //           Offset(
  //             (_size.width - usedSize.width) / 2,
  //             (_size.height - usedSize.height) / 2,
  //           );
  //       return StarBorder.polygon(
  //         side: side,
  //         sides: sides,
  //         pointRounding: pointRounding,
  //         rotation: rotation,
  //         squash: squash,
  //       ).getOuterPath(
  //         Rect.fromLTWH(
  //           usedOffset.dx,
  //           usedOffset.dy,
  //           usedSize.width,
  //           usedSize.height,
  //         ),
  //       );
  //     },
  //   );
  // }*/
}

/// [PuncherClipper] is a [CustomClipper] that clips a child widget with a
/// puncher shape.
/// it takes list of [PuncherShape]s to draw the puncher shape.
class PuncherClipper extends CustomClipper<Path> {
  /// [shapes] is the list of [PuncherShape]s to draw the puncher shape.
  final List<PuncherShape> shapes;

  // [inverse] is a bool that indicate if the shapes should be inverted.
  final bool inverse;

  /// [PuncherClipper] constructor.
  PuncherClipper({
    required this.shapes,
    this.inverse = false,
  });

  /// [PuncherClipper.inverse] constructor.
  PuncherClipper.inverse({
    required this.shapes,
  }) : inverse = true;

  @override
  Path getClip(Size size) {
    /// first create a rectangle path filling the whole widget.
    var path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    /// loop over the shapes and use [Path.combine] every two shapes
    /// to combine them together.
    for (int i = 0; i < shapes.length; i++) {
      path = Path.combine(
        PathOperation.difference,
        path,
        shapes[i].build(size),
      );
    }

    if (inverse) {
      path = Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        path,
      );
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
*/