import 'package:test/test.dart';
import 'package:osrm/osrm.dart';

void main() {
  final osrm = Osrm();
  test('get the nearest road', () async {
    final response = await osrm.nearest(
      NearestOptions(
        coordinate: (-0.1234, 51.1234),
        number: 3
      ),
    );
    expect(response.code, OsrmResponseCode.ok);
    expect(response.waypoints.length, 3);
  });

  /// Route service tests
  group('Route service tests', () {
    test('get the route', () async {
      final route = await osrm.route(
        RouteRequest(
          coordinates: [
            (-0.1234, 51.1234),
            (-0.1234, 51.1234),
            (-0.1234, 51.1234),
          ],
          alternatives: OsrmAlternative.true_,
          steps: true,
          annotations: OsrmAnnotation.true_, // or OsrmAnnotation.false_ or OsrmAnnotation.number(2)
          geometries: OsrmGeometries.geojson,
          overview: OsrmOverview.full,
          continueStraight: OsrmContinueStraight.true_,
          format: OsrmFormat.json,
          waypoints: [
            OsrmWaypoint(
              name: 'Start',
              hint: 'hint',
              distance: 0.0,
              location: (-0.1234, 51.1234),
            ),
            OsrmWaypoint(
              name: 'End',
              hint: 'hint',
              distance: 0.0,
              location: (-0.1234, 51.1234),
            ),
          ],
        ),
      );
      // expect route.routes not empty
      expect(route.routes.isNotEmpty, true, reason: 'routes expected to be not empty');
      // expect route.waypoints not empty
      expect(route.waypoints.isNotEmpty, true, reason: 'waypoints expected to be not empty');
      // expect route.routes[0].legs not empty
      expect(route.routes[0].legs?.isNotEmpty, true, reason: 'legs expected to be not empty');
      // expect route.routes[0].legs[0].steps not empty
      expect(route.routes[0].legs?[0].steps?.isNotEmpty, true, reason: 'steps expected to be not empty cous we set steps=true');
      // expect route.routes[0].legs[0].steps[0].intersections not empty
      expect(route.routes[0].legs?[0].steps?[0].intersections?.isNotEmpty, true, reason: 'intersections expected to be not empty cous we set steps=true');
      // expect route.routes[0].legs[0].steps[0].intersections[0].location not empty
      expect(route.routes[0].legs?[0].steps?[0].intersections?[0].location, isNotNull, reason: 'location expected to be not empty cous we set steps=true');
      // expect route.routes[0].legs[0].steps[0].intersections[0].bearings not empty
      expect(route.routes[0].legs?[0].steps?[0].intersections?[0].bearings?.isNotEmpty, true, reason: 'bearings expected to be not empty cous we set steps=true');
      // expect route.routes[0].legs[0].steps[0].intersections[0].bearings[0] not empty
      expect(route.routes[0].legs?[0].steps?[0].intersections?[0].bearings?[0], isNotNull, reason: 'bearings expected to be not empty cous we set steps=true');
      // expect route.routes[0].legs[0].steps[0].intersections[0].entry not empty
      expect(route.routes[0].legs?[0].steps?[0].intersections?[0].entry?.isNotEmpty, true, reason: 'entry expected to be not empty cous we set steps=true');
      // expect route.routes[0].legs[0].steps[0].intersections[0].out not be null
      expect(route.routes[0].legs?[0].steps?[0].intersections?[0].out, isNotNull, reason: 'out expected to be not empty cous we set steps=true');
    });
  });
}
