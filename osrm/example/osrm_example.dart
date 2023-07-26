import 'package:osrm/osrm.dart';
import 'dart:io';
import 'dart:math' as math;

void main() async {
  final osrm = Osrm();
  // get the route
  final options =  RouteRequest(
      coordinates: [
      (36.479960, 2.829099),
      (36.473662, 2.825987),
    ],
    geometries: OsrmGeometries.geojson,
    overview: OsrmOverview.full,
    alternatives: OsrmAlternative.number(2),
    annotations: OsrmAnnotation.true_,
    steps: true,
    
  );
  print(osrm.source.serverBuilder(options));
  final route = await osrm.route(options);
  List<Map<String,double>> latlng = route.routes.first.geometry!.lineString!.coordinates.map((e) {
    return {
      'lng': e.$1,
      'lat': e.$2,
    };
  }).toList();
  print(latlng);
}

