import '../../osrm.dart';

/// [MatchOptions]
/// Options for the match service.
class MatchOptions extends OsrmRequest {
  /// [steps] return route steps for each route leg
  final bool steps;

  /// [geometries] return route geometry as polyline or geojson
  final OsrmGeometries geometries;

  /// [annotations] return annotations for each route leg for duration, nodes, distance, weight, datasources, speed
  final OsrmAnnotation annotations;

  /// [overview] add overview geometry either full, simplified according to highest zoom level it could be display on, or not at all
  final OsrmOverview overview;

  /// [timestamps] timestamps for each coordinate in seconds since the Unix epoch (January 1, 1970)
  final List<int> timestamps;

  /// [radiuses] maximum distance in meters that the coordinate is allowed to move when shifted in the map matching process
  final List<int> radiuses;

  /// [gaps] Allows the input track splitting based on huge timestamp gaps between points
  final OsrmGaps gaps;

  /// [tidy] remove coordinates which are not connected to the rest of the route
  final bool tidy;

  /// [waypoints] an array with the same length as coordinates, an entry true indicates that the point must be matched, false indicates that the point should be omitted from the matching result (not yet implemented)
  final List<bool> waypoints;

  MatchOptions({
    super.version,
    super.profile,
    required super.coordinates,
    super.format,
    super.parameters,
    this.steps = false,
    this.geometries = OsrmGeometries.polyline,
    this.annotations = OsrmAnnotation.false_,
    this.overview = OsrmOverview.simplified,
    this.timestamps = const [],
    this.radiuses = const [],
    this.gaps = OsrmGaps.split,
    this.tidy = false,
    this.waypoints = const [],
  }) : super(service: OsrmService.match);

  @override
  Map<String, dynamic> get extraQueryParameters {
    final params = <String, dynamic>{
      'steps': steps,
      'geometries': geometries.name,
      'annotations': annotations.name,
      'overview': overview.name,
      'gaps': gaps.name,
      'tidy': tidy,
    };
    if (timestamps.isNotEmpty) {
      params['timestamps'] = timestamps.join(";");
    }
    if (radiuses.isNotEmpty) {
      params['radiuses'] = radiuses.join(";");
    }
    return params;
  }
}

/// [MatchResponse] class for the match response
class MatchResponse extends OsrmResponse {
  /// [tracepoints]  Array of Waypoint objects representing all points of the trace
  /// in order. If the trace point was ommited by map matching because it is an
  /// outlier, the entry will be null
  final List<OsrmWaypoint> tracepoints;

  /// [matchings] An array of Route objects that assemble the trace
  final List<OsrmRoute> matchings;

  MatchResponse({
    required OsrmResponseCode code,
    String? message,
    required this.tracepoints,
    required this.matchings,
  }) : super(
          code: code,
          message: message,
        );

  /// [fromMap] method to get the [MatchResponse] from a json map
  factory MatchResponse.fromMap(Map<String, dynamic> json) {
    return MatchResponse(
      code: OsrmResponseCode.fromString(json['code']),
      message: json['message'],
      tracepoints: (json['tracepoints'] as List)
          .map((e) => OsrmWaypoint.fromMap(e))
          .toList(),
      matchings:
          (json['matchings'] as List).map((e) => OsrmRoute.fromMap(e)).toList(),
    );
  }
}
