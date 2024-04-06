
import 'package:flutter/material.dart';
import 'package:motif/motif.dart';
import 'package:puncher/puncher.dart';
import 'package:puncher/widgets/nested_puncher.dart';
import 'package:shaper/shaper.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool inverse = false;

  /// List of shapes
  Map<IconData, Shaper> shapes = {
    Icons.circle: CircleShape(),
    Icons.star: StarShape(
      points: 5,
      innerRadiusRatio: .5,
      pointRounding: .5,
    ),
    Icons.polyline: PolygonShape(
      sides: 6,
    ),
    Icons.square: RectShape(
      borderRadius: BorderRadius.circular(10),
    ),
  };

  IconData selectedShape = Icons.circle;

  double radius = 50;
  double overlap = 0.5;
  double margin = 1;
  bool enabled = true;
  bool inner = true;
  bool outer = true;
  bool inverseEnabled = false;

  var decorations = [
    const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.cyan,
          Colors.blue,
        ],
      ),
    ),
    const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.yellow,
          Colors.orange,
        ],
      ),
    ),
    const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.green,
          Colors.blue,
        ],
      ),
    ),
    const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.purple,
          Colors.pink,
        ],
      ),
    ),
    const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.deepOrange,
          Colors.orange,
        ],
      ),
    ),
  ];

  late BoxDecoration decoration = decorations.first;

  // borderRaidus for the rectangle shape
  BorderRadius borderRadius = BorderRadius.circular(10);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.dark(),
      home: Scaffold(
        // appBar: AppBar(title: const Text('Crescent Difference Example')),
        body: Stack(
          children: [
            Positioned.fill(child: TransparentMotif()),
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Puncher(
                        punchers: [
                              // const edge = 6.0;
    // const holeSize = 12.0;
    // final holes = Path();
    // for (var y = edge; y < size.height; y += edge + holeSize) {
    //   holes.addOval(Rect.fromLTWH(edge, y, holeSize, holeSize));
    //   holes.addOval(Rect.fromLTWH(size.width - edge - holeSize, y, holeSize, holeSize));
    // }
    // return Path.combine(PathOperation.difference, Path()..addRect(Offset.zero & size), holes);  
                          PuncherClip(
                            shape: CircleShape(),
                            margin: 1,
                            translate: Offset(0, 0),
                          ),
                          
                          PuncherClip(
                            shape: PolygonShape(
                              sides: 8,
                            ),
                            margin: margin,
                            size: Size(100, 100),
                            translate: Offset(
                              (Directionality.maybeOf(context) == TextDirection.rtl ? -1 : 1) * overlap-0.3,
                              0,
                            ),
                          ),
                          PuncherClip.invert(
                            shape: StarShape(
                              points: 5,
                              innerRadiusRatio: .5,
                              pointRounding: .5,
                            ),
                            margin: margin,
                          ),
                        ],
                        child: Image.network("https://images.theconversation.com/files/553010/original/file-20231010-25-rr34z3.jpg?ixlib=rb-1.1.0&rect=0%2C0%2C5760%2C3837&q=20&auto=format&w=320&fit=clip&dpr=2&usm=12&cs=strip"),
                      ),
                    ),
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
