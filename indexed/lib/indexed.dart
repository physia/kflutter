library indexed;

import 'package:flutter/material.dart';

abstract class IndexedInterface {
  int get index;
}

class Indexed extends StatelessWidget implements IndexedInterface {
  @override
  final int index;
  final Widget child;
  const Indexed({
    super.key,
    this.index = 0,
    required this.child,
  });

  factory Indexed.fromWidget(Widget child, [index = 1]) {
    return Indexed(
      index: index,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) => child;
}

class Indexer extends Stack {
  final bool reversed;

  Indexer({
    super.key,
    super.alignment,
    super.textDirection,
    this.reversed = false,
    super.fit,
    super.clipBehavior,
    List<Widget> children = const <Widget>[],
  }) : super(
          children: children
            ..sort((Widget a, Widget b) {
              int reverser = reversed ? -1 : 1;
              int aIndex = 1;
              int bIndex = 1;
              if (a is IndexedInterface) {
                aIndex = (a as IndexedInterface).index;
              }
              if (b is IndexedInterface) {
                bIndex = (b as IndexedInterface).index;
              }
              return aIndex - bIndex * reverser;
            }),
        );

  /// use shadow list to sort items
  Indexer.shadow({
    super.key,
    super.alignment,
    super.textDirection,
    this.reversed = false,
    super.fit,
    super.clipBehavior,
    List<Widget> children = const <Widget>[],
    List<int> shadow = const <int>[],
  })  : assert(shadow.length == children.length),
        super(
          children: children
            ..sort((Widget a, Widget b) {
              int reverser = reversed ? -1 : 1;
              return shadow[children.indexOf(a)] -
                  shadow[children.indexOf(b)] * reverser;
            }),
        );
}
