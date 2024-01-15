import 'dart:math';

import 'package:flutter/material.dart';
import 'package:puncher/puncher.dart';

/// [NestedPuncher] is widget take car for common use like nested avatars ans so on
/// you can achieve the same result by using [Puncher] widget but this widget is
/// for easy use and common use cases, also take care of the overlap between the shapes
/// the most common use case is to use [CirclePuncherShape] with [CircleAvatar]
/// ```dart
/// NestedPuncher(
///   radius: 50,
///   overlap: 0.5,
///   child: CircleAvatar(
///     radius: 50,
///     backgroundImage: NetworkImage(
///         'https://avatars.githubusercontent.com/u/19484515?v=4'),
///   ),
/// );
/// ```
/// Warning: [NestedPuncher] is highly experimental and may change in future
/// versions, keep in mind that this widget is not optimized for performance
/// and may cause performance issues if used in a large list, but it's ok to
/// use it in a small list or a single widget, or inside a [ListView] with a
/// [builder] or somthing like that.
/// later we will improve the performance of this widget, and make the api more
/// stable.
class NestedPuncher extends StatelessWidget {
  const NestedPuncher({
    super.key,
    required this.radius,
    this.overlap = 0.6,
    this.enabled = true,
    this.shape,
    this.margin = 2,
    this.inner = true,
    this.outer = true,
    this.punchers = const [],
    required this.child,
  });
  /// [punchers] is the list of punchers to be used
  final List<PuncherClip> punchers;
  /// [radius] is the radius of the outer circle or the shape
  final double radius;
  /// [overlap] is the overlap between the outer and inner shape value between 0 and 1
  final double overlap;
  /// [enabled] is the enable state of the puncher for easy control
  final bool enabled;
  /// [inner] is the enable state of the inner shape
  final bool inner;
  /// [outer] is the enable state of the outer shape
  final bool outer;
  /// [shape] is the shape of the puncher
  /// for example [CirclePuncherShape] or [RectanglePuncherShape] ...
  final PuncherShape? shape;
  /// [margin] is the margin between the outer and inner shape
  final double margin;
  /// [child] is the child widget to be punched
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var _shape = shape ?? CirclePuncherShape();
    return Container(
      // color: Colors.yellow,
      height: radius,
      width:inner? radius * overlap: radius,
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
                dimension: radius,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// [GroupNestedPuncher] is widget take car for common use like nested avatars ans so on
/// it use a list of [NestedPuncher] to achieve the same result by using [Puncher] widget
/// ```dart
/// GroupNestedPuncher(
///   radius: 50,
///   overlap: 0.5,
///   children: [
///     CircleAvatar(
///       radius: 50,
///       backgroundImage: NetworkImage(
///           'https://avatars.githubusercontent.com/u/19484515?v=4'),
///     ),
///     CircleAvatar(
///       radius: 50,
///       backgroundImage: NetworkImage(
///           'https://avatars.githubusercontent.com/u/19484515?v=4'),
///     ),
///   ],
/// );
/// ```
/// Warning: [GroupNestedPuncher] is highly experimental and may change in future
class GroupNestedPuncher extends StatelessWidget {
  const GroupNestedPuncher({
    super.key,
    required this.radius,
    this.overlap = 0.6,
    this.enabled = true,
    this.shape,
    this.margin = 2,
    this.inner = true,
    this.outer = true,
    this.punchers = const [],
    this.axis = Axis.horizontal,
    required this.children,
  });
  /// [punchers] is the list of punchers to be used
  final List<PuncherClip> punchers;
  /// [radius] is the radius of the outer circle or the shape
  final double radius;
  /// [overlap] is the overlap between the outer and inner shape value between 0 and 1
  final double overlap;
  /// [enabled] is the enable state of the puncher for easy control
  final bool enabled;
  /// [inner] is the enable state of the inner shape
  final bool inner;
  /// [outer] is the enable state of the outer shape
  final bool outer;
  /// [shape] is the shape of the puncher
  /// for example [CirclePuncherShape] or [RectanglePuncherShape] ...
  final PuncherShape? shape;
  /// [margin] is the margin between the outer and inner shape
  final double margin;
  /// [children] is the list of child widget to be punched
  final List<Widget> children;
  /// [axis] is the axis of the list of children
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    var _shape = shape ?? CirclePuncherShape();
    return Flex(
      direction: axis,
      children: [
        for (var i = 0; i < children.length; i++)
            NestedPuncher(
              enabled: enabled,
              punchers: punchers,
              shape: _shape,
              margin: i == children.length - 1 ? 0 : margin,
              overlap: i == children.length - 1 ? 1 : overlap,
              radius: radius,
              child: children[i],
            ),
      ],
    );
  }
}