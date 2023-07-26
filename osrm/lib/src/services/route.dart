import '../../osrm.dart';

/// [RouteRequest]
/// Options for the route service.
class RouteRequest extends OsrmRequest {
  /// [RouteRequest] constructor.
  RouteRequest({
    super.version,
    super.profile,
    required super.coordinates,
    super.format,
    super.parameters,
    this.alternatives = OsrmAlternative.false_,
    this.steps = false,
    this.annotations = OsrmAnnotation.speed,
    this.geometries = OsrmGeometries.geojson,
    this.overview = OsrmOverview.simplified,
    this.continueStraight = OsrmContinueStraight.false_,
    this.waypoints = const [],
  }) : super(
    service: OsrmService.route,
  );

  /// [alternatives] search for alternative routes and return as well
  final OsrmAlternative alternatives;

  /// [steps] return route steps for each route leg
  final bool steps;

  /// [annotations] return annotations for each route leg for duration, nodes, distance, weight, datasources, speed
  final OsrmAnnotation annotations;

  /// [geometries] return route geometry as polyline or geojson
  final OsrmGeometries geometries;

  /// [overview] add overview geometry either full, simplified according to highest zoom level it could be display on, or not at all
  final OsrmOverview overview;

  /// [continueStraight] forces the route to keep going straight at waypoints constraining uturns there even if it would be faster
  final OsrmContinueStraight continueStraight;

  /// [waypoints] array of [OsrmWaypoint] objects
  final List<OsrmWaypoint> waypoints;

  @override
  Map<String, dynamic> get extraQueryParameters => {
        'alternatives': alternatives.name,
        'steps': steps,
        'annotations': annotations.name,
        'geometries': geometries.name,
        'overview': overview.name,
        'continue_straight': continueStraight.name,
      };
}

/// [RouteResponse] class for the route response
class RouteResponse extends OsrmResponse {
  /// [routes] the routes of the response
  final List<OsrmRoute> routes;
  final List<OsrmWaypoint> waypoints;

  RouteResponse({
    required OsrmResponseCode code,
    String? message,
    required this.routes,
    this.waypoints = const [],
  }) : super(
          code: code,
          message: message,
        );

  /// [fromMap] method to get the [RouteResponse] from a json map
  factory RouteResponse.fromMap(Map<String, dynamic> json) {
    return RouteResponse(
      code: OsrmResponseCode.fromString(json['code']),
      message: json['message'],
      routes: (json['routes'] as List).map((e) {
        return OsrmRoute.fromMap(e);
      }).toList(),
      waypoints: json['waypoints'] != null ? (json['waypoints'] as List).map((e) {
        return OsrmWaypoint.fromMap(e);
      }).toList() : [],
    );
  }
}
