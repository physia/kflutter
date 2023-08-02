import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
// osrm
import 'package:osrm/osrm.dart';
import 'dart:math' as math;
// flutter_map
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Osrm Example',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.teal,
      ),
      home: const FlutterMapOsrmExample(),
    );
  }
}

class FlutterMapOsrmExample extends StatefulWidget {
  const FlutterMapOsrmExample({
    super.key,
  });

  @override
  State<FlutterMapOsrmExample> createState() => _FlutterMapOsrmExampleState();
}

class _FlutterMapOsrmExampleState extends State<FlutterMapOsrmExample> {
  var from = // Beni merred
      const LatLng(36.479960, 2.829099);
  var to = // Somia blida
      const LatLng(36.473662, 2.825987);
  var points = <LatLng>[];
  @override
  void initState() {
    super.initState();
    getRoute();
  }

  /// [distance] the distance between two coordinates [from] and [to]
  num distance = 0.0;

  /// [duration] the duration between two coordinates [from] and [to]
  num duration = 0.0;

  /// [getRoute] get the route between two coordinates [from] and [to]
  Future<void> getRoute() async {
    final osrm = Osrm(
        // source: OsrmSource(
        //   serverBuilder: OpenstreetmapServerBuilder().build,
        // ),
        );
    // get the route
    final options = RouteRequest(
      coordinates: [
        (from.longitude, from.latitude),
        (to.longitude, to.latitude),
      ],
      // geometries: OsrmGeometries.geojson,
      overview: OsrmOverview.full,
      // alternatives: OsrmAlternative.number(2),
      // annotations: OsrmAnnotation.true_,
      // steps: false,
    );
    final route = await osrm.route(options);
    distance = route.routes.first.distance!;
    duration = route.routes.first.duration!;
    points = route.routes.first.geometry!.lineString!.coordinates.map((e) {
      var location = e.toLocation();
      return LatLng(location.lat, location.lng);
    }).toList();
    if (kDebugMode) {
      print(points);
    }
    setState(() {});
  }

  // pairly
  bool isPairly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              onTap:
                  // use [isPairly] to switch between [from] and [to]
                  (_, point) {
                if (isPairly) {
                  to = point;
                } else {
                  from = point;
                }
                isPairly = !isPairly;
                setState(() {});
                getRoute();
              },
              center: const LatLng(36.479960, 2.829099),
              zoom: 13.0,
            ),
            nonRotatedChildren: [
              RichAttributionWidget(
                animationConfig:
                    const ScaleRAWA(), // Or `FadeRAWA` as is default
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(
                        Uri.parse('https://openstreetmap.org/copyright')),
                  ),
                  /// @mohamadlounnas
                  TextSourceAttribution(
                    'Mohamad Lounnas',
                    onTap: () => launchUrl(
                        Uri.parse('mailto:mohamadlounnas@gmail.com')),
                  ),
                ],
              ),
            ],
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),

              /// [PolylineLayer] draw the route between two coordinates [from] and [to]
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: points,
                    strokeWidth: 4.0,
                    color: Colors.red,
                  ),
                ],
              ),

              /// [MarkerLayer] draw the marker on the map
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: from,
                    builder: (ctx) => const Icon(
                      Icons.circle,
                      color: Colors.blue,
                    ),
                  ),
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: to,
                    builder: (ctx) => const Icon(
                      Icons.circle,
                      color: Colors.red,
                    ),
                  ),

                  /// in the middle of [points] list we draw the [Marker] shows the distance between [from] and [to]
                  if (points.isNotEmpty)
                    Marker(
                      rotate: true,
                      width: 80.0,
                      height: 30.0,
                      point: points[math.max(0, (points.length / 2).floor())],
                      builder: (ctx) => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${distance.toStringAsFixed(2)} m',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // copy right text
            ],
          ),

          /// [Form] with two [TextFormField] to get the coordinates [from] and [to]
          Align(
            alignment: Alignment.topRight,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              margin: const EdgeInsets.all(20),
              child: Container(
                width: 500,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                        initialValue: from.toSexagesimal(),
                        onChanged: (value) {
                          from = LatLng.fromSexagesimal(value);
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.location_on),
                          prefix: const Text('From: '),
                          border: const OutlineInputBorder().copyWith(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )),
                    const SizedBox(height: 20),
                    TextFormField(
                        initialValue: to.toSexagesimal(),
                        onChanged: (value) {
                          to = LatLng.fromSexagesimal(value);
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.location_on),
                          prefix: const Text('To: '),
                          border: const OutlineInputBorder().copyWith(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        FilledButton.icon(
                          icon: const Icon(Icons.directions),
                          onPressed: () {
                            getRoute();
                          },
                          label: const Text('Get Route'),
                        ),
                        const SizedBox(width: 20),
                        // grey text display the duration between [from] and [to] and the distance
                        Center(
                          child: Text(
                            // km and hour
                            '| ${(duration / 60).toStringAsFixed(2)} h - ${(distance / 1000).toStringAsFixed(2)} km',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
