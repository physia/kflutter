/// This file contains the full SDK for Project-OSRM in Dart.
///
/// To use this SDK, you will need to import this file into your Dart project.
///
/// Here are the steps to use this SDK:
///
/// 1. Import this file into your Dart project:
///
///    ```dart
///    import 'path/to/osrm.dart';
///    ```
///
/// 2. Create an instance of the `OSRM` class:
///
///    ```dart
///    final osrm = Osrm();
///    // you can set extra options example:
///    final _osrm = Osrm(
///       source: OsrmSource(
///         ///...
///       ),
///    );
///    ```
///
///    Replace `http://localhost:5000` with the URL of your OSRM server.
///
/// 3. Use the `OSRM` instance to make requests to the OSRM server:
///
///    ```dart
///    final route = await osrm.route(
///      waypoints: [
///        Waypoint(location: Location(latitude: 52.5160, longitude: 13.3779)),
///        Waypoint(location: Location(latitude: 52.5206, longitude: 13.3862)),
///      ],
///      steps: true,
///      // other parameters
///    );
///    ```
///
///    This example makes a request to the OSRM server to calculate a route between two waypoints.
///
///    The `route` variable will contain a `Route` object that represents the calculated route.
///
///    You can customize the request by passing additional parameters to the `route` method.
///
///    For more information on the available parameters, see the documentation for the `OSRM` class.
///
/// This SDK follows best practices for Dart development, including the use of asynchronous methods and the `dart:io` library for making HTTP requests.
library osrm;

import 'src/services/nearest.dart';
import 'src/services/route.dart';
import 'src/shared/core.dart';

export 'src/shared/core.dart';
export 'src/shared/models.dart';
export 'src/shared/utils.dart';

// Services
export 'src/services/nearest.dart';
export 'src/services/route.dart';

/// [Osrm] the main class for the SDK
/// This class contains all methods for the OSRM requests.
/// The class is initialized with an [OsrmSource] which is used to make the requests.
/// The [OsrmSource] is an interface which can be implemented by any class.
/// The SDK contains a default implementation of the [OsrmSource] which can be used (use your server url template builder).
/// The SDK also contains a [OsrmMockSource] which can be used for testing.
class Osrm {
  /// [source] the source for the requests
  final OsrmSource source;

  Osrm({
    OsrmSource? source,
  }): source = source ?? OsrmSource();

  /// [nearest] 
  /// 
  /// If you encounter any issues or have any questions, please consult the Project-OSRM documentation or open an issue on the Project-OSRM GitHub repository.
  /// Snaps a coordinate to the street network and returns the nearest n matches.
  /// Parameters:
  /// - coordinate: [Location]
  /// - number: number of nearest segments that should be returned
  /// 
  /// Examples:
  /// #### cURL example
  /// ```
  /// curl "http://router.project-osrm.org/nearest/v1/driving/-0.1234,51.1234?number=3"
  /// ```
  /// 
  /// #### Dart example
  /// ```dart
  /// final nearest = await osrm.nearest(
  ///   NearestOptions(
  ///     coordinate: Location(latitude: 52.4224, longitude: 13.333086),
  ///     number: 3,
  ///   ),
  /// );
  /// ```
  Future<NearestResponse> nearest(NearestOptions options) async {
    final response = await source.request(options);
    return NearestResponse.fromMap(response);
  }

  /// [route]
  /// Finds the fastest route between coordinates in the supplied order.
  /// Parameters:
  /// - alternatives: search for alternative routes and return as well
  /// - steps: return route steps for each route leg
  /// - annotations: return annotations for each route leg for duration, nodes, distance, weight, datasources, speed
  /// - geometries: return route geometry as polyline or geojson
  /// - overview: add overview geometry either full, simplified according to highest zoom level it could be display on, or not at all
  /// - continueStraight: forces the route to keep going straight at waypoints constraining uturns there even if it would be faster
  /// - waypoints: array of [Waypoint] objects
  /// Examples:
  /// #### cURL example
  /// ```
  /// curl "http://router.project-osrm.org/route/v1/driving/13.388860,52.517037;13.385983,52.496891?steps=true&alternatives=true"
  /// ```
  /// 
  /// #### Dart example
  /// ```dart
  /// final route = await osrm.route(
  ///   RouteOptions(
  ///      waypoints: [
  ///       Waypoint(location: Location(latitude: 52.4224, longitude: 13.333086)),
  ///       Waypoint(location: Location(latitude: 52.4224, longitude: 13.333086)),
  ///       Waypoint(location: Location(latitude: 52.4224, longitude: 13.333086)),
  ///     ],
  ///     alternatives: true,
  ///     steps: true,
  ///     annotations: OsrmAnnotation.true_, // or OsrmAnnotation.false_ or OsrmAnnotation.number(2)
  ///     geometries: Geometries.geojson,
  ///     overview: Overview.full,
  ///     continueStraight: true,
  ///   ),
  /// );
  /// ```
  Future<RouteResponse> route(RouteRequest options) async {
    final response = await source.request(options);
    return RouteResponse.fromMap(response);
  }
}

/// [Osrm.nearest] 
/// If you encounter any issues or have any questions, please consult the Project-OSRM documentation or open an issue on the Project-OSRM GitHub repository.
/// Snaps a coordinate to the street network and returns the nearest n matches.
/// Parameters:
/// - coordinates: array of Location objects
/// - number: number of nearest segments that should be returned
/// 
/// Examples:
/// ```curl
/// curl "http://router.project-osrm.org/nearest/v1/driving/-0.1234,51.1234?number=3"
/// ```
/// ```dart
/// final nearest = await osrm.nearest(
///   NearestOptions(
///    coordinates: [
///     Location(latitude: 52.4224, longitude: 13.333086),
///     Location(latitude: 52.4224, longitude: 13.333086),
///     Location(latitude: 52.4224, longitude: 13.333086),
///   ],
///   number: 3,
/// );
/// ```


/// [Osrm.route]
/// Finds the fastest route between coordinates in the supplied order.
/// Template: /route/v1/{profile}/{coordinates}?alternatives={true|false|number}&steps={true|false}&geometries={polyline|polyline6|geojson}&overview={full|simplified|false}&annotations={true|false}
/// Parameters:
/// - coordinates: array of Location objects
/// - alternatives: search for alternative routes and return as well
/// - steps: return route steps for each route leg
/// - annotations: return annotations for each route leg for duration, nodes, distance, weight, datasources, speed
/// - geometries: return route geometry as polyline or geojson
/// - overview: add overview geometry either full, simplified according to highest zoom level it could be display on, or not at all
/// - continueStraight: forces the route to keep going straight at waypoints constraining uturns there even if it would be faster
/// Examples:
/// ```curl
/// curl "http://router.project-osrm.org/route/v1/driving/13.388860,52.517037;13.385983,52.496891?steps=true&alternatives=true"
/// ```
/// ```dart
/// final route = await osrm.route(
///   RouteOptions(
///     /// List<OsmCoordinate>
///     coordinates: [ 
///       (52.124, 13.333006),
///       (52.4424, 13.3326),
///       (52.224, 13.1330086),
///     ],
///     alternatives: true,
///     steps: true,
///     annotations: true,
///     geometries: OsrmGeometries.geojson,
///     overview: OsrmOverview.full,
///     continueStraight: true,
///  ),
/// );
/// ```

/// [Osrm.match] 
/// Map matching matches/snaps given GPS points to the road network in the most plausible way.
/// Please note the request might result multiple sub-traces. Large jumps in the timestamps
/// (> 60s) or improbable transitions lead to trace splits if a complete matching could not
/// be found. The algorithm might not be able to match all points.
/// Outliers are removed if they can not be matched successfully.
/// 
/// Template: /match/v1/{profile}/{coordinates}?steps={true|false}&geometries={polyline|polyline6|geojson}&overview={simplified|full|false}&annotations={true|false}
/// Parameters:
/// - coordinates: array of Location objects
/// - steps: return route steps for each route leg
/// - annotations: return annotations for each route leg for duration, nodes, distance, weight, datasources, speed
/// - geometries: return route geometry as polyline or geojson
/// - overview: add overview geometry either full, simplified according to highest zoom level it could be display on, or not at all
/// - timestamps: timestamps for each coordinate in seconds since the Unix epoch (January 1, 1970)
/// - radiuses: maximum distance in meters that the coordinate is allowed to move when shifted in the map matching process
/// - gaps: maximum distance between points to be matched that allows for a connection. Gaps parameter is mandatory for the first coordinate.
/// - tidy: remove coordinates which are not connected to the rest of the route
/// - waypoints: an array with the same length as coordinates, an entry true indicates that the point must be matched, false indicates that the point should be omitted from the matching result (not yet implemented)

/// The trip plugin solves the Traveling Salesman Problem using a greedy heuristic
/// (farthest-insertion algorithm) for 10 or more waypoints and uses brute force
/// for less than 10 waypoints. The returned path does not have to be the fastest path.
/// As TSP is NP-hard it only returns an approximation.
/// Note that all input coordinates have to be connected for the trip service to work.
/// [Osrm.trip] 

/// Computes the duration of the fastest route between all pairs of supplied coordinates.
/// Returns the durations or distances or both between the coordinate pairs. Note that
/// the distances are not the shortest distance between two coordinates, but rather the
/// distances of the fastest routes. Duration is in seconds and distances is in meters.
/// [Osrm.table] 
/// 




