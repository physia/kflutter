
import 'utils.dart';

/// [OsrmModel] abstract class for all the models
/// its insure that all the models have [toMap] method
abstract class OsrmModel<T> {
  /// [toMap] method to get the [OsrmModel] as a json map
  T toMap();
}

/// [OsrmWaypoint] class for a waypoint
class OsrmWaypoint extends OsrmModel<Map<String, dynamic>> {
  /// [name] name of the street the coordinate snapped to
  final String? name;
  /// [location] array that contains the [longitude, latitude] pair of the snapped coordinate
  final OsrmCoordinate? location;
  /// [distance] the distance, in metres, from the input coordinate to the snapped coordinate
  final num? distance;
  /// [hint] unique internal identifier of the segment (ephemeral, not constant over data updates)
  final String? hint;
  /// [nodes] OpenStreetMap node IDs
  final List<num>? nodes;
  /// [alternativesCount] number of probable alternative matchings for this trace point
  final num? alternativesCount;

  OsrmWaypoint({
    this.name,
    this.location,
    this.distance,
    this.hint,
    this.nodes,
    this.alternativesCount,
  });

  /// [fromMap] method to get the [OsrmWaypoint] from a json map
  factory OsrmWaypoint.fromMap(Map<String, dynamic> json) {
    return OsrmWaypoint(
      name: json['name'],
      location: json['location'] != null ? (json['location'][1], json['location'][0]) : null,
      distance: json['distance'],
      hint: json['hint'],
      nodes: json['nodes'] != null ? (json['nodes'] as List).map((e) => e as num).toList() : null,
      alternativesCount: json['alternatives_count'],
    );
  }

  /// [toMap] method to get the [OsrmWaypoint] as a json map
  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location != null ? [location!.toCoordinateList()] : null,
      'distance': distance,
      'hint': hint,
      'nodes': nodes,
      'alternatives_count': alternativesCount,
    };
  }
}


/// [OsrmPolyline] is just a string
typedef OsrmPolyline = String;

/// [OsrmPolyline] is just a string
typedef OsrmPolyline6 = String;

/// [OsrmGeometry] it have 3 values
class OsrmGeometry extends OsrmModel<dynamic> {
  /// [lineString] the geometry as a [OsrmLineString], it be filled if the [OsrmGeometries] is [OsrmGeometries.geojson]
  final OsrmLineString? lineString;

  /// [polyline] the geometry as a [OsrmPolyline], it be filled if the [OsrmGeometries] is [OsrmGeometries.polyline]
  final OsrmPolyline? polyline;

  /// [polyline6] the geometry as a [OsrmPolyline6], it be filled if the [OsrmGeometries] is [OsrmGeometries.polyline6]
  final OsrmPolyline6? polyline6;

  OsrmGeometry({
    this.lineString,
    this.polyline,
    this.polyline6,
  }) : // only one of them can be not null
       assert(((){
        var result = (lineString != null ? 1:0) + (polyline != null ? 1:0) + (polyline6 != null ? 1:0);
        return result <= 1;
       })(), 'only one of them can be not null');

  /// [detect] is static method to detect the geometry is [OsrmGeometries.geojson] or [OsrmGeometries.polyline] or [OsrmGeometries.polyline6]
  static OsrmGeometries? detect(dynamic geometry) {
    if (geometry == null) return null;
    /// for [OsrmGeometries.geojson] just check [geometry] is a [Map]
    if (geometry is Map) {
      return OsrmGeometries.geojson;
    } else if (geometry is String) {
      /// for [OsrmGeometries.polyline] or [OsrmGeometries.polyline6] just check [geometry] is a [String]
      if (geometry.contains('[')) {
        return OsrmGeometries.polyline;
      } else {
        return OsrmGeometries.polyline6;
      }
    } else {
      throw ArgumentError('Invalid geometry: $geometry');
    }
  }

  /// [from] method to get the [OsrmGeometry] from a dynamic value
  static OsrmGeometry from(dynamic geometry) {
    switch (detect(geometry)) {
      case OsrmGeometries.geojson:
        return OsrmGeometry(
          lineString: OsrmLineString.fromMap(geometry),
        );
      case OsrmGeometries.polyline:
        return OsrmGeometry(
          polyline: geometry,
        );
      case OsrmGeometries.polyline6:
        return OsrmGeometry(
          polyline6: geometry,
        );
      default:
        return OsrmGeometry();
    }
  }

  /// [toValue] method to get the [OsrmGeometry] as a dynamic value
  dynamic toValue() {
    if (lineString != null) {
      return lineString!.toMap();
    } else if (polyline != null) {
      return polyline;
    } else if (polyline6 != null) {
      return polyline6;
    } else {
      throw ArgumentError('Invalid geometry: $this');
    }
  }
  
  /// [toMap] method to get the [OsrmGeometry] as a json map
  /// here [toMap] is little bit different from other models
  /// it can return a [Map] or a [String]
  @override
  dynamic toMap() {
    return toValue();
  }
}

/// [OsrmLineString] class for a line string
/// read more: https://tools.ietf.org/html/rfc7946#section-3.1.4
/// basically it is a list of [OsrmCoordinate]
class OsrmLineString extends OsrmModel<Map<String, dynamic>>   {
  /// [coordinates] the coordinates of the line string
  final List<OsrmCoordinate> coordinates;

  OsrmLineString({
    required this.coordinates,
  });

  /// [fromMap] method to get the [OsrmLineString] from a json map
  factory OsrmLineString.fromMap(Map<String, dynamic> json) {
    return OsrmLineString(
      coordinates: List.from(json['coordinates']).map((e) {
        return (
          double.parse(e[0].toString()),
          double.parse(e[1].toString()),
        );
      }).toList(),
    );
  }

  /// [toMap] method to get the [OsrmLineString] as a json map
  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'LineString',
      'coordinates': coordinates.map((e) => e.toCoordinateList()).toList(),
    };
  }
}

/// [OsrmRoute] class for a route
class OsrmRoute extends OsrmModel<Map<String, dynamic>>  {
  /// [distance] The distance traveled by the route, in float meters.
  final num? distance;
  /// [duration] The estimated travel time, in float number of seconds.
  final num? duration;
  /// [weight] The calculated weight of the route.
  final num? weight;
  /// [weightName] The name of the weight profile used during extraction phase.
  final String? weightName;
  /// [geometry] Depending on the geometries parameter this is a GeoJSON LineString or Polyline string representation of the route.
  final OsrmGeometry? geometry;
  /// [legs] Array of RouteLeg objects that assemble the route. Each RouteLeg object contains information about the route between two waypoints.
  final List<OsrmRouteLeg>? legs;
  /// [voiceLocale] Locale of the returned turn-by-turn voice announcements. Can be used to influence the pronunciation of street names. The format should follow the IETF’s BCP 47 specification.
  final String? voiceLocale;

  OsrmRoute({
    this.distance,
    this.duration,
    this.weight,
    this.weightName,
    this.geometry,
    this.legs,
    this.voiceLocale,
  });

  /// [fromMap] method to get the [OsrmRoute] from a json map
  factory OsrmRoute.fromMap(Map<String, dynamic> json) {
    return OsrmRoute(
      distance: json['distance'],
      duration: json['duration'],
      weight: json['weight'],
      weightName: json['weight_name'],
      geometry: OsrmGeometry.from(json['geometry']),
      legs: (json['legs'] as List).map((e) => OsrmRouteLeg.fromMap(e)).toList(),
      voiceLocale: json['voiceLocale'],
    );
  }

  /// [toMap] method to get the [OsrmRoute] as a json map
  @override
  Map<String, dynamic> toMap() {
    return {
      'distance': distance,
      'duration': duration,
      'weight': weight,
      'weight_name': weightName,
      'geometry': geometry?.toMap(),
      'legs': legs?.map((e) => e.toMap()).toList(),
      'voiceLocale': voiceLocale,
    };
  }
}


/// [OsrmRouteLeg] class for a route leg
class OsrmRouteLeg extends OsrmModel<Map<String, dynamic>> {
  /// [distance] The distance traveled by the route leg, in float meters.
  final num? distance;
  /// [duration] The estimated travel time, in float number of seconds.
  final num? duration;
  /// [weight] The calculated weight of the route leg.
  final num? weight;
  /// [summary] Summary of the route taken as string. Depends on the steps parameter: if false, the summary will be a single string; if true, an array of strings for each step of the route leg.
  final String? summary;
  /// [steps] Array of RouteStep objects describing the turn-by-turn instructions of the route. Please note that even if the steps parameter is set to false this array will still contain a single element.
  final List<OsrmRouteStep>? steps;

  OsrmRouteLeg({
    this.distance,
    this.duration,
    this.weight,
    this.summary,
    this.steps,
  });

  /// [fromMap] method to get the [OsrmRouteLeg] from a json map
  factory OsrmRouteLeg.fromMap(Map<String, dynamic> json) {
    return OsrmRouteLeg(
      distance: json['distance'],
      duration: json['duration'],
      weight: json['weight'],
      summary: json['summary'],
      steps: (json['steps'] as List).map((e) => OsrmRouteStep.fromMap(e)).toList(),
    );
  }

  /// [toMap] method to get the [OsrmRouteLeg] as a json map
  @override
  Map<String, dynamic> toMap() {
    return {
      'distance': distance,
      'duration': duration,
      'weight': weight,
      'summary': summary,
      'steps': steps?.map((e) => e.toMap()).toList(),
    };
  }
}

/// [OsrmRouteStep] class for a route step
class OsrmRouteStep extends OsrmModel<Map<String, dynamic>>  {
  /// [distance] The distance traveled by the route step, in float meters.
  final num? distance;
  /// [duration] The estimated travel time, in float number of seconds.
  final num? duration;
  /// [weight] The calculated weight of the route step.
  final num? weight;
  /// [name] The name of the way along which travel proceeds.
  final String? name;
  /// [mode] The mode of transportation.
  final String? mode;
  /// [geometry] Depending on the geometries parameter this is a GeoJSON LineString or Polyline string representation of the route step.
  final OsrmGeometry? geometry;
  /// [maneuver] A StepManeuver object representing the maneuver.
  final OsrmStepManeuver? maneuver;
  /// [intersections] An array of Intersection objects that are passed along the segment, the very first belonging to the StepManeuver.
  final List<OsrmIntersection>? intersections;
  /// [voiceInstructions] A string with the name of the rotary.
  final OsrmVoiceInstructions? voiceInstructions;
  /// [bannerInstructions] A string with the name of the rotary.
  final OsrmBannerInstructions? bannerInstructions;

  OsrmRouteStep({
    this.distance,
    this.duration,
    this.weight,
    this.name,
    this.mode,
    this.geometry,
    this.maneuver,
    this.intersections,
    this.voiceInstructions,
    this.bannerInstructions,
  });

  /// [fromMap] method to get the [OsrmRouteStep] from a json map
  factory OsrmRouteStep.fromMap(Map<String, dynamic> json) {
    return OsrmRouteStep(
      distance: json['distance'],
      duration: json['duration'],
      weight: json['weight'],
      name: json['name'],
      mode: json['mode'],
      geometry: OsrmGeometry.from(json['geometry']),
      maneuver: json['maneuver'] != null ? OsrmStepManeuver.fromMap(json['maneuver']) : null,
      intersections: (json['intersections'] as List).map((e) => OsrmIntersection.fromMap(e)).toList(),
      voiceInstructions: json['voiceInstructions'] != null ? OsrmVoiceInstructions.fromMap(json['voiceInstructions']) : null,
      bannerInstructions: json['bannerInstructions'] != null ? OsrmBannerInstructions.fromMap(json['bannerInstructions']) : null,
    );
  }

  /// [toMap] method to get the [OsrmRouteStep] as a json map
  @override
  Map<String,dynamic> toMap() {
    return {
      'distance': distance,
      'duration': duration,
      'weight': weight,
      'name': name,
      'mode': mode,
      'geometry': geometry?.toMap(),
      'maneuver': maneuver?.toMap(),
      'intersections': intersections?.map((e) => e.toMap()).toList(),
      'voiceInstructions': voiceInstructions?.toMap(),
      'bannerInstructions': bannerInstructions?.toMap(),
    };
  }
}

/// [OsrmStepManeuver] class for a step maneuver
class OsrmStepManeuver extends OsrmModel<Map<String, dynamic>> {
  /// [location] A [OsrmCoordinate] object representing the location of the turn.
  final OsrmCoordinate? location;
  /// [bearingBefore] The clockwise angle from true north to the direction of travel immediately before the maneuver.
  final num? bearingBefore;
  /// [bearingAfter] The clockwise angle from true north to the direction of travel immediately after the maneuver.
  final num? bearingAfter;
  /// [type] A string indicating the type of maneuver.
  final String? type;
  /// [modifier] An optional string indicating the direction change of the maneuver.
  final String? modifier;
  /// [exit] An optional integer indicating the exit number or name of the roundabout exit.
  final String? exit;
  /// [instruction] A string indicating the verbal instruction to be announced just before the maneuver.
  final String? instruction;
  /// [streetName] A string indicating the name of the street to turn onto in order to complete the maneuver.
  final String? streetName;
  /// [rotaryName] A string with the name of the rotary.
  final String? rotaryName;
  /// [exitName] A string indicating the name of the exit.
  final String? exitName;

  OsrmStepManeuver({
    this.location,
    this.bearingBefore,
    this.bearingAfter,
    this.type,
    this.modifier,
    this.exit,
    this.instruction,
    this.streetName,
    this.rotaryName,
    this.exitName,
  });

  /// [fromMap] method to get the [OsrmStepManeuver] from a json map
  factory OsrmStepManeuver.fromMap(Map<String, dynamic> json) {
    return OsrmStepManeuver(
      location: json['location'] != null ? (json['location'][1], json['location'][0]) : null,
      bearingBefore: json['bearing_before'],
      bearingAfter: json['bearing_after'],
      type: json['type'],
      modifier: json['modifier'],
      exit: json['exit'],
      instruction: json['instruction'],
      streetName: json['street_name'],
      rotaryName: json['rotary_name'],
      exitName: json['exit_name'],
    );
  }

  /// [toMap] method to get the [OsrmStepManeuver] as a json map
  @override
  Map<String, dynamic> toMap() {
    return {
      'location': location != null ? location!.toCoordinateList() : null,
      'bearing_before': bearingBefore,
      'bearing_after': bearingAfter,
      'type': type,
      'modifier': modifier,
      'exit': exit,
      'instruction': instruction,
      'street_name': streetName,
      'rotary_name': rotaryName,
      'exit_name': exitName,
    };
  }
}

/// [OsrmIntersection] class for a intersection
class OsrmIntersection extends OsrmModel<Map<String, dynamic>> {
  /// [location] A [OsrmCoordinate] object representing the location of the turn.
  final OsrmCoordinate? location;
  /// [bearings] A list of bearing values (e.g. [0,90,180,270]) that are available at the intersection.
  final List<num>? bearings;
  /// [entry] A list of entry flags, corresponding in a 1:1 relationship to the bearings.
  final List<bool>? entry;
  /// [in] Index into bearings/entry array. Used to calculate the bearing just before the turn. Namely, the clockwise angle from true north to the direction of travel immediately before the maneuver/passing the intersection. To get the bearing in the direction of driving, the bearing has to be rotated by a value of 180. The value is not supplied for depart maneuvers.
  final num? in_;
  /// [out] Index into the bearings/entry array. Used to extract the bearing just after the turn. Namely, The clockwise angle from true north to the direction of travel immediately after the maneuver/passing the intersection. The value is not supplied for arrive maneuvers.
  final num? out;
  /// [lanes] Array of Lane objects that represent the available turn lanes at the intersection. If no lane information is available for an intersection, the lanes property will not be present.
  final List<OsrmLane>? lanes;

  OsrmIntersection({
    this.location,
    this.bearings,
    this.entry,
    this.in_,
    this.out,
    this.lanes,
  });

  /// [fromMap] method to get the [OsrmIntersection] from a json map
  factory OsrmIntersection.fromMap(Map<String, dynamic> json) {
    return OsrmIntersection(
      location: json['location'] != null ? (json['location'][1], json['location'][0]) : null,
      bearings: json['bearings'] != null ? (json['bearings'] as List).map((e) => e as num).toList() : null,
      entry: json['entry'] != null ? (json['entry'] as List).map((e) => e as bool).toList() : null,
      in_: json['in'],
      out: json['out'],
      lanes: json['lanes'] != null ? (json['lanes'] as List).map((e) => OsrmLane.fromMap(e)).toList() : null,
    );
  }

  /// [toMap] method to get the [OsrmIntersection] as a json map
  @override
  Map<String, dynamic> toMap() {
    return {
      'location': location != null ? location!.toCoordinateList() : null,
      'bearings': bearings,
      'entry': entry,
      'in': in_,
      'out': out,
      'lanes': lanes?.map((e) => e.toMap()).toList(),
    };
  }
}

/// [OsrmLane] class for a lane
class OsrmLane extends OsrmModel<Map<String, dynamic>> {
  /// [valid] A boolean flag indicating whether the lane is valid for the turn.
  final bool? valid;
  /// [indications] A list of LaneIndication objects representing the turn lane(s) that can be taken at the corresponding turn location.
  final List<OsrmLaneIndication>? indications;

  OsrmLane({
    this.valid,
    this.indications,
  });

  /// [fromMap] method to get the [OsrmLane] from a json map
  factory OsrmLane.fromMap(Map<String, dynamic> json) {
    return OsrmLane(
      valid: json['valid'],
      indications: json['indications'] != null ? (json['indications'] as List).map((e) {
        if (e is String) return OsrmLaneIndication(indication: e);
        return OsrmLaneIndication.fromMap(e);
      }).toList() : null,
    );
  }

  /// [toMap] method to get the [OsrmLane] as a json map
  @override
  Map<String, dynamic> toMap() {
    return {
      'valid': valid,
      'indications': indications?.map((e) => e.toMap()).toList(),
    };
  }
}

/// [OsrmLaneIndication] class for a lane indication
class OsrmLaneIndication extends OsrmModel<Map<String, dynamic>> {
  /// [valid] A boolean flag indicating whether the lane is valid for the turn.
  final bool? valid;
  /// [indications] A list of LaneIndication objects representing the turn lane(s) that can be taken at the corresponding turn location.
  final String? indication;

  OsrmLaneIndication({
    this.valid,
    this.indication,
  });

  /// [fromMap] method to get the [OsrmLaneIndication] from a json map
  factory OsrmLaneIndication.fromMap(Map<String, dynamic> json) {
    return OsrmLaneIndication(
      valid: json['valid'],
      indication: json['indication'],
    );
  }

  /// [toMap] method to get the [OsrmLaneIndication] as a json map
  @override
  Map<String, dynamic> toMap() {
    return {
      'valid': valid,
      'indication': indication,
    };
  }
}

/// [OsrmVoiceInstructions] class for voice instructions
class OsrmVoiceInstructions extends OsrmModel<Map<String, dynamic>> {
  /// [distanceAlongGeometry] A float indicating the distance from the beginning of the step at which the voice instruction should be said.
  final num? distanceAlongGeometry;
  /// [announcement] A string with the voice instruction.
  final String? announcement;
  /// [ssmlAnnouncement] A string with the SSML markup of the voice instruction.
  final String? ssmlAnnouncement;

  OsrmVoiceInstructions({
    this.distanceAlongGeometry,
    this.announcement,
    this.ssmlAnnouncement,
  });

  /// [fromMap] method to get the [OsrmVoiceInstructions] from a json map
  factory OsrmVoiceInstructions.fromMap(Map<String, dynamic> json) {
    return OsrmVoiceInstructions(
      distanceAlongGeometry: json['distanceAlongGeometry'],
      announcement: json['announcement'],
      ssmlAnnouncement: json['ssmlAnnouncement'],
    );
  }

  /// [toMap] method to get the [OsrmVoiceInstructions] as a json map
  @override
  Map<String, dynamic> toMap() {
    return {
      'distanceAlongGeometry': distanceAlongGeometry,
      'announcement': announcement,
      'ssmlAnnouncement': ssmlAnnouncement,
    };
  }
}

/// [OsrmBannerInstructions] class for banner instructions
class OsrmBannerInstructions extends OsrmModel<Map<String, dynamic>> {
  /// [distanceAlongGeometry] A float indicating the distance from the beginning of the step at which the voice instruction should be said.
  final num? distanceAlongGeometry;
  /// [primary] A string with the banner instruction.
  final String? primary;
  /// [secondary] A string with the secondary banner instruction.
  final String? secondary;
  /// [sub] A string with the sub banner instruction.
  final String? sub;
  /// [imageBaseUrl] A string with the base URL for the shield images.
  final String? imageBaseUrl;
  /// [type] A string indicating the type of maneuver.
  final String? type;
  /// [modifier] An optional string indicating the direction change of the maneuver.
  final String? modifier;
  /// [degrees] A float indicating the degrees of rotation of a rotary. Only available for the type `rotary`.
  final num? degrees;

  OsrmBannerInstructions({
    this.distanceAlongGeometry,
    this.primary,
    this.secondary,
    this.sub,
    this.imageBaseUrl,
    this.type,
    this.modifier,
    this.degrees,
  });

  /// [fromMap] method to get the [OsrmBannerInstructions] from a json map
  factory OsrmBannerInstructions.fromMap(Map<String, dynamic> json) {
    return OsrmBannerInstructions(
      distanceAlongGeometry: json['distanceAlongGeometry'],
      primary: json['primary'],
      secondary: json['secondary'],
      sub: json['sub'],
      imageBaseUrl: json['imageBaseUrl'],
      type: json['type'],
      modifier: json['modifier'],
      degrees: json['degrees'],
    );
  }

  /// [toMap] method to get the [OsrmBannerInstructions] as a json map
  @override
  Map<String, dynamic> toMap() {
    return {
      'distanceAlongGeometry': distanceAlongGeometry,
      'primary': primary,
      'secondary': secondary,
      'sub': sub,
      'imageBaseUrl': imageBaseUrl,
      'type': type,
      'modifier': modifier,
      'degrees': degrees,
    };
  }
}

