import '../../osrm.dart';

/// [OsrmCoordinate] class for a location with latitude and longitude
// class OsrmCoordinate {
//   /// [latitude] of the location
//   final double latitude;
//   /// [longitude] of the location
//   final double longitude;
//   OsrmCoordinate({
//     required this.latitude,
//     required this.longitude,
//   });
// }

/// Uri build(OsrmRequest options)
typedef ServerBuildFn = Uri Function(OsrmRequest options);

/// LongLat
typedef OsrmCoordinate = (double,double);

class OsrmLocation {
  final double lat;
  final double lng;
  OsrmLocation({
    required this.lat,
    required this.lng,
  });
}

extension OsrmCoordinateExtensions on OsrmCoordinate {
  /// Long Lat
  // ignore: prefer_interpolation_to_compose_strings
  String toLongLatCoordinateString() => $1.toString()+','+$2.toString();
  OsrmLocation toLocation() => OsrmLocation(lat:$2,lng:$1);
  List<double> toCoordinateList() => [$1,$2];
  Map<String,double> toCoordinateMap() => {
    'lng': $1,
    'lat': $2,
  };
}

/// [OsrmAnnotation] enum for the annotation parameter
/// the underscore is added because the name `true` and `false` are reserved for dart
/// see: https://dart.dev/guides/language/language-tour#keywords
/// when you get [Enum.name] it will return the correct name without the underscore
enum OsrmAnnotation {
  /// [true_] to return annotations
  true_,
  /// [false_] to not return annotations
  false_,
  /// [duration] to return annotations for duration
  duration,
  /// [nodes] to return annotations for nodes
  nodes,
  /// [distance] to return annotations for distance
  distance,
  /// [weight] to return annotations for weight
  weight,
  /// [datasources] to return annotations for datasources
  datasources,
  /// [speed] to return annotations for speed
  speed;

  /// [name] override
  String get name {
    switch (this) {
      case OsrmAnnotation.true_:
        return 'true';
      case OsrmAnnotation.false_:
        return 'false';
      case OsrmAnnotation.duration:
        return 'duration';
      case OsrmAnnotation.nodes:
        return 'nodes';
      case OsrmAnnotation.distance:
        return 'distance';
      case OsrmAnnotation.weight:
        return 'weight';
      case OsrmAnnotation.datasources:
        return 'datasources';
      case OsrmAnnotation.speed:
        return 'speed';
    }
  }

  /// [fromString] method to get the [OsrmAnnotation] from a string
  static OsrmAnnotation fromString(String annotation) {
    switch (annotation) {
      case 'true':
        return OsrmAnnotation.true_;
      case 'false':
        return OsrmAnnotation.false_;
      case 'duration':
        return OsrmAnnotation.duration;
      case 'nodes':
        return OsrmAnnotation.nodes;
      case 'distance':
        return OsrmAnnotation.distance;
      case 'weight':
        return OsrmAnnotation.weight;
      case 'datasources':
        return OsrmAnnotation.datasources;
      case 'speed':
        return OsrmAnnotation.speed;
      default:
        throw ArgumentError('Invalid annotation: $annotation');
    }
  }
}

/// [Union] class for the union types
/// Till dart supports union types we use this workaround
/// for creating union type we extend this class and add the union value as dynamic field
class Union<A,B> {
  /// [value] the value of the union type
  final dynamic value;
  const Union(this.value): assert(value is A || value is B);
}


/// [OsrmAlternative] enum for the alternative parameter
/// in reality this is a [bool] or [num] but dart does not support union types
/// so we use an enum instead, the underscore is added because the name `true` and `false` are reserved for dart
/// see: https://dart.dev/guides/language/language-tour#keywords
/// in case of adding num support we can use the [OsrmAlternative.number]
class OsrmAlternative {
  const OsrmAlternative._(this.value);
  /// [true_] to return alternatives
  static const OsrmAlternative true_ = OsrmAlternative._(Union<bool,num>(true));
  /// [false_] to not return alternatives
  static const OsrmAlternative false_ = OsrmAlternative._(Union<bool,num>(false));
  /// [number] to return a specific number of alternatives
  static OsrmAlternative number(int number) => OsrmAlternative._(Union<bool,num>(number));
  
  final Union<bool,num> value;
  OsrmAlternative(this.value);

  /// [from] method to get the [OsrmAlternative] from a dynamic value
  static OsrmAlternative from(dynamic alternative) {
    if (alternative is bool) {
      return alternative ? OsrmAlternative.true_ : OsrmAlternative.false_;
    } else if (alternative is num) {
      return OsrmAlternative.number(alternative.toInt());
    } else {
      throw ArgumentError('Invalid alternative: $alternative');
    }
  }

  /// [name] override
  String get name {
    if (value.value is bool) {
      return value.value ? 'true' : 'false';
    } else if (value.value is num) {
      return value.value.toString();
    } else {
      throw ArgumentError('Invalid alternative: ${value.value}');
    }
  }

  /// [toString] override
  @override
  String toString() => name;
}


/// [OsrmGeometries] enum for the geometries parameter
enum OsrmGeometries {
  /// [polyline] to return the route as polyline
  /// the encoded polyline is a string following the Google polyline algorithm
  polyline,
  /// [polyline6] to return the route as polyline6
  /// it is an encoded polyline with precision 1e6
  polyline6,
  /// [geojson] to return the route as geojson
  /// the geojson is a GeoJSON LineString
  geojson;

  /// [fromString] method to get the [OsrmGeometries] from a string
  static OsrmGeometries fromString(String geometries) {
    switch (geometries) {
      case 'polyline':
        return OsrmGeometries.polyline;
      case 'polyline6':
        return OsrmGeometries.polyline6;
      case 'geojson':
        return OsrmGeometries.geojson;
      default:
        throw ArgumentError('Invalid geometries: $geometries');
    }
  }  
}


/// [OsrmOverview] enum for the overview parameter
/// the underscore is added because the name `false` are reserved for dart
/// see: https://dart.dev/guides/language/language-tour#keywords
enum OsrmOverview with EnumMixinHelper {
  /// [simplified] to return the overview as simplified
  simplified,
  /// [full] to return the overview as full
  full,
  /// [false_] to not return the overview
  false_;

  /// [fromString] method to get the [OsrmOverview] from a string
  static OsrmOverview fromString(String overview) {
    switch (overview) {
      case 'simplified':
        return OsrmOverview.simplified;
      case 'full':
        return OsrmOverview.full;
      case 'false':
        return OsrmOverview.false_;
      default:
        throw ArgumentError('Invalid overview: $overview');
    }
  }
}



/// [EnumMixinHelper] mixin to get the name of an enum
mixin EnumMixinHelper on Enum {
  /// [name] override
  String get name {
    // if the last part of the enum is an underscore we remove it
    final enumName = toString().split('.').last;
    return enumName.endsWith('_') ? enumName.substring(0, enumName.length - 1) : enumName;
  }
}


/// [OsrmContinueStraight] enum for the continue_straight parameter
/// the underscore is added because the name `false` are reserved for dart
/// see: https://dart.dev/guides/language/language-tour#keywords
/// params are default (default), true_ , false_
enum OsrmContinueStraight with EnumMixinHelper {
  /// [default] to return the continue_straight as default
  default_,
  /// [true_] to return the continue_straight as true
  true_,
  /// [false_] to return the continue_straight as false
  false_;

  /// [fromString] method to get the [OsrmContinueStraight] from a string
  static OsrmContinueStraight fromString(String continueStraight) {
    switch (continueStraight) {
      case 'default':
        return OsrmContinueStraight.default_;
      case 'true':
        return OsrmContinueStraight.true_;
      case 'false':
        return OsrmContinueStraight.false_;
      default:
        throw ArgumentError('Invalid continueStraight: $continueStraight');
    }
  }
}