import 'package:osrm/src/builders.dart';
import 'package:test/test.dart';
import 'package:osrm/osrm.dart';

void main() {
  List<ServerBuildFn> builders = [
    ProjectOsrmServerBuilder().build,
    OpenstreetmapServerBuilder().build,
    MapboxServerBuilder(
      apiKey: 'pk.eyJ1Ijoic3ByaW5nZ2VtIiwiYSI6ImNrc2c3YTJ0YzFkbjMycm5xaGR0MnludWEifQ.k04fviSsj-CTCWSboCHZ8Q',
    ).build,
    // Add other paid services here
  ];
  // for (var builder in builders) {
    test('Test 0"${builders.indexOf(builders.last)}"', () async {
    final response = await Osrm(
      source: OsrmSource(
        serverBuilder: builders.last
      )
    ).route(
      RouteRequest(
          coordinates: [
            (2.828798,36.470165),
            (7.747003, 36.904714),
          ],
          geometries: OsrmGeometries.geojson
      ),
    );
    // expect(response.code, OsrmResponseCode.ok);
    // expect(response.waypoints.length, 3);
  });
  // }

}
