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
    Key? key,
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
    Key? key,
    AlignmentDirectional alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    this.reversed = false,
    StackFit fit = StackFit.loose,
    @Deprecated(
      'Use clipBehavior instead. See the migration guide in flutter.dev/go/clip-behavior. '
      'This feature was deprecated after v1.22.0-12.0.pre.',
    )
        Overflow overflow = Overflow.clip,
    Clip clipBehavior = Clip.hardEdge,
    List<Widget> children = const <Widget>[],
  }) : super(
          key: key,
          alignment: alignment,
          textDirection: textDirection,
          fit: fit,
          overflow: overflow,
          clipBehavior: clipBehavior,
          children: children
            ..sort((Widget a, Widget b) {
              int _reverser = reversed ? -1 : 1;
              int _aIndex = 1;
              int _bIndex = 1;
              if (a is IndexedInterface) {
                _aIndex = (a as IndexedInterface).index;
              }
              if (b is IndexedInterface) {
                _bIndex = (b as IndexedInterface).index;
              }
              return _aIndex - _bIndex * _reverser;
            }),
        );

  /// use shadow list to sort items
  Indexer.shadow({
    Key? key,
    AlignmentDirectional alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    this.reversed = false,
    StackFit fit = StackFit.loose,
    @Deprecated(
      'Use clipBehavior instead. See the migration guide in flutter.dev/go/clip-behavior. '
      'This feature was deprecated after v1.22.0-12.0.pre.',
    )
        Overflow overflow = Overflow.clip,
    Clip clipBehavior = Clip.hardEdge,
    List<Widget> children = const <Widget>[],
    List<int> shadow = const<int>[],
  }) :
  assert(shadow.length == children.length),
   super(
          key: key,
          alignment: alignment,
          textDirection: textDirection,
          fit: fit,
          overflow: overflow,
          clipBehavior: clipBehavior,
          children: children
            ..sort((Widget a, Widget b) {
              int _reverser = reversed ? -1 : 1;              
              return shadow[children.indexOf(a)] - shadow[children.indexOf(b)] * _reverser;
            }),
        );
}
