import '../osrm.dart';
import 'shared/core.dart';

/// [OsrmServerBuilder]
/// This class contains some default server builders for the OSRM server.
/// please read the policy of the project-osrm and openstreetmap before using these servers.
abstract class OsrmServerBuilder {
  /// [build] method to build the server uri
  Uri build(OsrmRequest options);

  /// [defaultBuilder] server for development
  static Uri defaultBuild(OsrmRequest options) =>
      ProjectOsrmServerBuilder().build(options);
}

/// [ProjectOsrmServerBuilder] class for the project-osrm server builder
class ProjectOsrmServerBuilder extends OsrmServerBuilder {
  /// [baseUrl] the base url of the server
  final String baseUrl;

  /// [ProjectOsrmServerBuilder] constructor
  ProjectOsrmServerBuilder({
    this.baseUrl = 'http://router.project-osrm.org',
  });

  /// [build] method to build the server uri
  @override
  Uri build(OsrmRequest options) {
    var profiles = ['foot', 'bike', 'car'];
    var urlToParse =
        '$baseUrl/${options.service.toString().split('.').last}/${options.version}/${profiles[options.profile.index]}/${options.stringCoordinates}';
    if (options.queryParameters.isNotEmpty) {
      urlToParse += '?';
      urlToParse += options.queryParameters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
    }
    return Uri.parse(urlToParse);
  }
}

/// [OpenstreetmapServerBuilder] class for the openstreetmap server builder
class OpenstreetmapServerBuilder extends OsrmServerBuilder {
  /// [baseUrl] the base url of the server
  final String baseUrl;

  /// [OpenstreetmapServerBuilder] constructor
  OpenstreetmapServerBuilder({
    this.baseUrl = 'http://router.project-osrm.org',
  });

  /// [build] method to build the server uri
  @override
  Uri build(OsrmRequest options) {
    var profiles = ['foot', 'bike', 'car'];
    var urlToParse =
        '$baseUrl/${options.service.toString().split('.').last}/${options.version}/${profiles[options.profile.index]}/${options.stringCoordinates}';
    if (options.queryParameters.isNotEmpty) {
      urlToParse += '?';
      urlToParse += options.queryParameters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
    }
    return Uri.parse(urlToParse);
  }
}

/// [MapboxServerBuilder] class for the Mapbox server builder
class MapboxServerBuilder extends OsrmServerBuilder {
  /// [baseUrl] the base url of the server
  final String baseUrl;

  /// [apiKey] the access token for the Mapbox API
  final String apiKey;

  /// [MapboxServerBuilder] constructor
  MapboxServerBuilder({
    this.baseUrl = 'https://api.mapbox.com',
    required this.apiKey,
  });

  /// [build] method to build the server uri
  @override
  Uri build(OsrmRequest options) {
    var profiles = ['walking', 'cycling', 'driving', 'driving-traffic'];
    var services = [
      'nearest',
      'directions',
      'match',
      'trip',
      'table',
    ];

    final queryParameters = {
      ...options.queryParameters,
      'access_token': apiKey,
    };
    var coords =
        options.stringCoordinates.replaceAll(',', '%2C').replaceAll(';', '%3B');
    var urlToParse =
        '$baseUrl/${services[options.service.index]}/v5/mapbox/${profiles[options.profile.index]}/${coords}';
    urlToParse += '?';
    urlToParse +=
        queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&');
    return Uri.parse(urlToParse);
  }
}

/// TODO: 
enum MapboxOsrmAnnotation {
  duration,
  distance,
  congestion,
  congestion_numeric,
  closure,
  state_of_charge,
  traffic_tendency,
  speed,
}

