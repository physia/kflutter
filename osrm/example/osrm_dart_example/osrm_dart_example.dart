import 'package:osrm/osrm.dart';

/// how to use the OSRM package to get a route between two coordinates.
void main() async {
  final osrm = Osrm();
  // get the route
  final options =  RouteRequest(
      coordinates: [
      // LngLat
      (2.829099,36.479960),
      (2.825987,36.473662),
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
    return e.toCoordinateMap();
  }).toList();
  print(latlng);
}

