library div;

import 'package:flutter/material.dart';

/// the div widget will just be wrapper for the [Container] widget
/// but it will use the first argument as the [child]
/// and the rest of the arguments will be used as the [Container]
class Div extends Container {
  Div(
    Widget? child, {
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip clipBehavior = Clip.none,
    // if the prop [onTap] not null, it will wrap the [child] with [GestureDetector]
    // and the [onTap] will be used as the [GestureDetector.onTap]
    GestureTapCallback? onTap,
    // the gesture detector behavior
    HitTestBehavior? behavior = HitTestBehavior.opaque,
  }) : super(
          key: key,
          alignment: alignment,
          padding: padding,
          color: color,
          decoration: decoration,
          foregroundDecoration: foregroundDecoration,
          width: width,
          height: height,
          constraints: constraints,
          margin: margin,
          transform: transform,
          transformAlignment: transformAlignment,
          child: onTap == null
              ? child
              : GestureDetector(
                  behavior: behavior,
                  onTap: onTap,
                  child: child,
                ),
          clipBehavior: clipBehavior,
        );
  // the constructor [Div.col] will be used to create a [Column] wrapped in a [Container]
  Div.col(
    List<Widget>? children, {
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip clipBehavior = Clip.none,
    // if the prop [onTap] not null, it will wrap the [child] with [GestureDetector]
    // and the [onTap] will be used as the [GestureDetector.onTap]
    GestureTapCallback? onTap,
    // the gesture detector behavior
    HitTestBehavior? behavior = HitTestBehavior.opaque,
  }) : super(
          key: key,
          alignment: alignment,
          padding: padding,
          color: color,
          decoration: decoration,
          foregroundDecoration: foregroundDecoration,
          width: width,
          height: height,
          constraints: constraints,
          margin: margin,
          transform: transform,
          transformAlignment: transformAlignment,
          child: onTap != null
              ? GestureDetector(
                  behavior: behavior,
                  onTap: onTap,
                  child: Column(
                    children: children ?? [],
                  ),
                )
              : Column(
                  children: children ?? [],
                ),
          clipBehavior: clipBehavior,
        );
  // the constructor [Div.row] will be used to create a [Row] wrapped in a [Container]
  Div.row(
    List<Widget>? children, {
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip clipBehavior = Clip.none,
    // if the prop [onTap] not null, it will wrap the [child] with [GestureDetector]
    // and the [onTap] will be used as the [GestureDetector.onTap]
    GestureTapCallback? onTap,
    // the gesture detector behavior
    HitTestBehavior? behavior = HitTestBehavior.opaque,
  }) : super(
          key: key,
          alignment: alignment,
          padding: padding,
          color: color,
          decoration: decoration,
          foregroundDecoration: foregroundDecoration,
          width: width,
          height: height,
          constraints: constraints,
          margin: margin,
          transform: transform,
          transformAlignment: transformAlignment,
          child: onTap != null
              ? GestureDetector(
                  behavior: behavior,
                  onTap: onTap,
                  child: Row(
                    children: children ?? [],
                  ),
                )
              : Row(
                  children: children ?? [],
                ),
          clipBehavior: clipBehavior,
        );
}
