import '../../osrm.dart';

/// [NearestOptions]
/// Options for the nearest service.
class NearestOptions extends OsrmRequest {
  /// [number] number of nearest segments that should be returned
  final int number;

  NearestOptions({
    super.version,
    super.profile,
    required OsrmCoordinate coordinate,
    super.format,
    super.parameters,
    this.number = 1,
  }) : super(
    service: OsrmService.nearest,
    coordinates: [coordinate],
    );

  @override
  Map<String, dynamic> get extraQueryParameters => {
    'number': number,
  }; 
}



/// [NearestResponse] class for the nearest response
class NearestResponse extends OsrmResponse {
  /// [waypoints] the waypoints of the response
  final List<OsrmWaypoint> waypoints;
  NearestResponse({
    required OsrmResponseCode code,
    String? message,
    required this.waypoints,
  }) : super(
          code: code,
          message: message,
        );

  /// [fromMap] method to get the [NearestResponse] from a json map
  factory NearestResponse.fromMap(Map<String, dynamic> json) {
    return NearestResponse(
      code: OsrmResponseCode.fromString(json['code']),
      message: json['message'],
      waypoints: (json['waypoints'] as List).map((e) => OsrmWaypoint.fromMap(e)).toList(),
    );
  }
}