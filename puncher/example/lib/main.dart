import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:motif/motif.dart';
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
  /// List of motifs
  Map<IconData, Widget> motifs = {
    Icons.star: const StarMotif(
      bounds: Size(20, 20),
      side: BorderSide.none,
      points: 5,
      innerRadiusRatio: 0.4,
      pointRounding: 0,
      valleyRounding: 0,
      rotation: 0,
      squash: 0,
    ),
    Icons.square_outlined: const TransparentMotif(),
    Icons.grid_3x3_outlined: const UPMapMotif(),
    Icons.waves_outlined: const SinosoidalMotif(),
  };

  int selectedMotif = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.dark(),
      home: Scaffold(
        // appBar: AppBar(title: const Text('Crescent Difference Example')),
        body: Stack(
          children: [
            Positioned.fill(
              child: motifs.values.elementAt(selectedMotif),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    // SizedBox(
                    //   height: 100,
                    //   width: 100,
                    //   child: CustomPaint(
                    //     painter: ExamplePainter(),
                    //   ),
                    // ),
                    SegmentedButton(
                      segments: [
                        for (int i = 0; i < motifs.length; i++)
                          ButtonSegment(
                            icon: Icon(motifs.keys.elementAt(i)),
                            value: i,
                          )
                      ],
                      onSelectionChanged: (value) {
                        setState(() {
                          selectedMotif = value.first;
                        });
                      },
                      selected: {
                        selectedMotif,
                      },
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NestedPuncher extends StatelessWidget {
  const NestedPuncher({
    super.key,
    required this.radius,
    this.overlap = 0.5,
    this.enabled = true,
    this.shape,
    this.margin = 1.0,
    this.inner = true,
    this.outer = true,
    this.debug = false,
    this.punchers = const [],
    required this.child,
  });

  final List<PuncherClip> punchers;
  final double radius;
  final double overlap;
  final bool enabled;
  final bool debug;
  final bool inner;
  final bool outer;
  final Shaper? shape;
  final double margin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var _shape = shape ?? CircleShape();
    return Container(
      // color: Colors.yellow,
      height: radius * 2,
      width: inner ? radius * 2 * overlap : radius * 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.directional(
            textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
            start: 0,
            child: Puncher(
              debug: debug,
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
                    translate: Offset((Directionality.maybeOf(context) == TextDirection.rtl ? -1 : 1) * overlap, 0),
                  )
              ],
              child: SizedBox.square(
                dimension: radius * 2,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
