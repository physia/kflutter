// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

library puncher;

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shaper/shaper.dart';
export './widgets/nested_puncher.dart';

/// final api
/// ```dart
/// Puncher(
///   punchers: [
///     PuncherClip(
///       shape: Shape.circle().invert(),
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

/// [PuncherClip] is a class that contains the data of a [Shape].
class PuncherClip {
  /// [invert] is a bool that indicate if the shape should be inverted.
  final bool invert;

  /// [shape] is the shape of the puncher.
  final Shaper shape;

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
    return shape.build(parentSize, size: size, transform: transform, origin: origin, alignment: alignment, offset: offset, translate: translate, margin: margin);
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

  /// [debug] is a bool that indicate if the puncher is in debug mode or not.
  final bool debug;

  /// [Puncher] constructor.
  const Puncher({
    super.key,
    required this.punchers,
    this.clipBehavior = Clip.antiAlias,
    this.enabled = true,
    this.debug = kDebugMode,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return enabled
        ? debug
            ? Stack(
                children: [
                  // draw for debug
                  Positioned.fill(
                    child: CustomPaint(
                      painter: PuncherPainter(punchers: punchers),
                    ),
                  ),
                  Opacity(
                    opacity: 0.9,
                    child: ClipPath(
                      clipBehavior: clipBehavior,
                      clipper: PuncherClipper(punchers: punchers),
                      child: child,
                    ),
                  ),
                ],
              )
            : ClipPath(
                clipBehavior: clipBehavior,
                clipper: PuncherClipper(punchers: punchers),
                child: child,
              )
        : child;
  }
}

/// [PuncherPainter] is jus custom painter drow every thing to debug
class PuncherPainter extends CustomPainter {
  final List<PuncherClip> punchers;
  const PuncherPainter({required this.punchers});

  @override
  void paint(Canvas canvas, Size size) {
    // random colors
    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.pink,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.cyan,
      Colors.indigo,
      Colors.lime,
      Colors.amber,
      Colors.brown,
      Colors.grey,
    ];

    Color randomColor() {
      return colors[Random().nextInt(colors.length)].withOpacity(1);
    }

    final paint = Paint()
      ..color = randomColor()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    /// first create a rectangle path filling the whole widget.
    var path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path, paint);

    /// loop over the shapes and use [Path.combine] every two shapes
    /// to combine them together.
    for (int i = 0; i < punchers.length; i++) {
      paint.color = randomColor();
      PuncherClip puncher = punchers[i];
      canvas.drawPath(puncher.build(size), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}




/// [PuncherClipper] is a [CustomClipper] that clips a child widget with a
/// puncher shape.
/// it takes list of [Shape]s to draw the puncher shape.
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
/// [ShapeData] is a class that contains the data of a [Shape].
class ShapeData {
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

  /// [ShapeData] constructor.
  const ShapeData({
    this.size,
    this.transform,
    this.origin = Alignment.center,
    this.alignment = Alignment.center,
    this.offset = Offset.zero,
  });
}


/// [PuncherClipper] is a [CustomClipper] that clips a child widget with a
/// puncher shape.
/// it takes list of [Shape]s to draw the puncher shape.

/// [Shape] is a class that represents a puncher shape.
/// it have a build that return a [Path] that represents the shape.
class Shape {
  /// [path] is a function that takes a [Size] and returns a [Path]
  final Path Function({required Size parentSize,required ShapeData data}) path;

  /// [data] is a [ShapeData] that contains the data of the shape.
  final ShapeData data;

  /// constructor for [Shape]
  Shape({
    required this.path,
    this.data = const ShapeData(),
  });

  /*
  /// [transform] is a function that takes a [transform] and [origin] and [offset] and returns a [Shape]
  Shape transform({
    Matrix4? transform,
    AlignmentGeometry origin = Alignment.center,
    AlignmentGeometry alignment = Alignment.center,
    Offset offset = Offset.zero,
    Size? size,
  }) {
    return Shape(
      path: ({required Size parentSize,required ShapeData data}) {
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


  /// [Shape.rect] is a factory constructor that returns a [Shape]
  factory Shape.rect({
    Radius? radius,
  }) {
    return Shape(
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

  /// [Shape.circle] is a factory constructor that returns a [Shape]
  factory Shape.circle() {
    return Shape(
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

  /// [Shape.star] is a factory constructor that returns a [Shape]
  /// it uses [StarBorder] to draw a star shape.
  /// but the same api as [PusherShape.rect] and [PusherShape.circle] is used.
  /// not the old one that are commented below.
  /// that mean also not offset
  factory Shape.star({
    BorderSide side = BorderSide.none,
    double points = 5,
    double innerRadiusRatio = 0.4,
    double pointRounding = 0,
    double valleyRounding = 0,
    double rotation = 0,
    double squash = 0,
  }) {
    return Shape(
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

  /// [Shape.polygon] is a factory constructor that returns a [Shape]
  /// it uses [StarBorder.polygon] to draw a polygon shape.
  /// but the same api as [PusherShape.rect] and [PusherShape.circle] is used.
  /// not the old one that are commented below.
  /// that mean also not offset
  factory Shape.polygon({
    BorderSide side = BorderSide.none,
    double sides = 5,
    double pointRounding = 0,
    double rotation = 0,
    double squash = 0,
  }) {
    return Shape(
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


  // /// [Shape.star] it uses [StarBorder] to draw a star shape.
  // /// it allow all the properties of [StarBorder] to be used.
  // factory Shape.star({
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
  //   return Shape(
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

  // /// [Shape.polygon] it uses [StarBorder.polygon] to draw a polygon shape.
  // /// it allow all the properties of [StarBorder.polygon] to be used.
  // factory Shape.polygon({
  //   BorderSide side = BorderSide.none,
  //   double sides = 5,
  //   double pointRounding = 0,
  //   double rotation = 0,
  //   double squash = 0,
  //   Offset? offset,
  //   Size? size,
  // }) {
  //   return Shape(
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
/// it takes list of [Shape]s to draw the puncher shape.
class PuncherClipper extends CustomClipper<Path> {
  /// [shapes] is the list of [Shape]s to draw the puncher shape.
  final List<Shape> shapes;

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
