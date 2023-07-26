import superagent from 'superagent';

export type OsrmService = 'route' | 'nearest' | 'table' | 'match' | 'trip' | 'tile';

export type OutputType = 'json' | 'flatbuffers' | 'mvt';

export type Profile = 'driving' | 'bike' | 'foot';

export type Indication /** No dedicated indication is shown. */ =
  | 'none'
  /** An indication signaling the possibility to reverse (i.e. fully bend arrow). */
  | 'uturn'
  /**	An indication indicating a sharp right turn (i.e. strongly bend arrow). */
  | 'sharp right'
  /** An indication indicating a right turn (i.e. bend arrow). */
  | 'right'
  /** An indication indicating a slight right turn (i.e. slightly bend arrow). */
  | 'slight right'
  /** No dedicated indication is shown (i.e. straight arrow). */
  | 'straight'
  /** An indication indicating a slight left turn (i.e. slightly bend arrow). */
  | 'slight left'
  /** An indication indicating a left turn (i.e. bend arrow). */
  | 'left'
  /** An indication indicating a sharp left turn (i.e. strongly bend arrow).   */
  | 'sharp left'
  | string;

export type Annotation =
  | boolean
  | 'nodes'
  | 'distance'
  | 'duration'
  | 'datasources'
  | 'weight'
  | 'speed'
  | Array<'nodes' | 'distance' | 'duration' | 'datasources' | 'weight' | 'speed'>;

export type StepManeuverType =
  | 'turn'
  /** name	no turn is taken/possible, but the road name changes. The road can take a turn itself, following modifier. */
  | 'new'
  /** indicates the departure of the leg */
  | 'depart'
  /** indicates the destination of the leg */
  | 'arrive'
  /** merge onto a street (e.g. getting on the highway from a ramp, the modifier specifies the direction of the merge) */
  | 'merge'
  /** Deprecated. Replaced by on_ramp and off_ramp. */
  | 'ramp'
  /** ramp	take a ramp to enter a highway (direction given my modifier) */
  | 'on'
  /** ramp	take a ramp to exit a highway (direction given my modifier) */
  | 'off'
  /** take the left/right side at a fork depending on modifier */
  | 'fork'
  /** of road	road ends in a T intersection turn in direction of modifier */
  | 'end'
  /** lane	Deprecated replaced by lanes on all intersection entries */
  | 'use'
  /** Turn in direction of modifier to stay on the same road */
  | 'continue'
  /** traverse roundabout, if the route leaves the roundabout there will be an additional property exit for exit counting. The modifier specifies the direction of entering the roundabout. */
  | 'roundabout'
  /** a traffic circle. While very similar to a larger version of a roundabout, it does not necessarily follow roundabout rules for right of way. It can offer rotary_name and/or rotary_pronunciation parameters (located in the RouteStep object) in addition to the exit parameter (located on the StepManeuver object). */
  | 'rotary'
  /** turn	Describes a turn at a small roundabout that should be treated as normal turn. The modifier indicates the turn direciton. Example instruction: At the roundabout turn left. */
  | 'roundabout'
  /** not an actual turn but a change in the driving conditions. For example the travel mode or classes. If the road takes a turn itself, the modifier describes the direction */
  | 'notification'
  /** roundabout	Describes a maneuver exiting a roundabout (usually preceeded by a roundabout instruction) */
  | 'exit'
  /** rotary	Describes the maneuver exiting a rotary (large named roundabout)   */
  | 'exit'
  | string;

export type Coordinate = [number, number];
export type Polyline = string;
export type Bearing = number[];
export type Radius = number;
/** Base64 string */
export type Hint = string;
/** Keep waypoints on curb side, @default unrestricted */
export type Approach = 'curb' | 'unrestricted';
export type Duration = number;
export type Tile = [number, number, number];
export interface ILineString {
  type: 'LineString';
  coordinates: Coordinate[];
}

export enum OsrmResultCode {
  /** Request could be processed as expected. */
  Ok = 'Ok',
  /** URL string is invalid. */
  InvalidUrl = 'InvalidUrl',
  /** Service name is invalid. */
  InvalidService = 'InvalidService',
  /** Version is not found. */
  InvalidVersion = 'InvalidVersion',
  /** Options are invalid. */
  InvalidOptions = 'InvalidOptions',
  /** The query string is synctactically malformed. */
  InvalidQuery = 'InvalidQuery',
  /** The successfully parsed query parameters are invalid. */
  InvalidValue = 'InvalidValue',
  /** One of the supplied input coordinates could not snap to street segment. */
  NoSegment = 'NoSegment',
  /** The request size violates one of the service specific request size restrictions. */
  TooBig = 'TooBig',
  /** No route found (only for route service). */
  NoRoute = 'NoRoute',
  /** No trips found because input coordinates are not connected. */
  NoTrips = 'NoTrips',
  /** This request is not supported. */
  NotImplemented = 'NotImplemented',
  /** No matchings found (only for match service). */
  NoMatch = 'NoMatch',
  /**	No route found (only for table service). */
  NoTable = 'NoTable',
}

export interface IOsrmResult {
  code: OsrmResultCode;
  data_version?: string;
  message?: string;
}

export interface INearestOptions extends IOsrmOptions {
  /**
   * Number of nearest segments that should be returned.
   * Must be an integer greater than or equal to 1.
   * @default 1
   */
  number?: number;
  /** Bit silly, but if supplied, only returns the result code */
  skip_waypoints?: boolean;
}

/** Specific route options. */
export interface IRouteOptions extends IOsrmOptions {
  /**
   * Search for alternative routes.
   * Passing a number alternatives=n searches for up to n alternative routes.
   * @default false
   */
  alternatives?: boolean | number;
  /**
   * Returned route steps for each route leg.
   * @default false
   */
  steps?: boolean;
  /**
   * Returns additional metadata for each coordinate along the route geometry.
   * @default false
   */
  annotations?: Annotation;
  /**
   * Returned route geometry format (influences overview and per step)
   * @default polyline
   */
  geometries?: 'polyline' | 'polyline6' | 'geojson';
  /**
   * Add overview geometry either full, simplified according to highest zoom level
   * it could be display on, or not at all.
   * @default simplified
   */
  overview?: 'simplified' | 'full' | false;
  /**
   * Forces the route to keep going straight at waypoints constraining uturns there
   * even if it would be faster. Default value depends on the profile.
   * @default default
   */
  continue_straight?: boolean | 'default';
  /**
   * Treats input coordinates indicated by given indices as waypoints in returned Match object.
   * Default is to treat all input coordinates as waypoints.
   */
  waypoints?: number[];
  /** If supplied, for each coordinate generate a timestamp as Date.valueOf */
  timestamps?: number[];
  /** Skip the waypoints in the output result. */
  skip_waypoints?: boolean;
}

/**
 * Unlike other array encoded options, the length of sources and destinations can
 * be smaller or equal to number of input locations.
 */
export interface ITableOptions extends IOsrmOptions {
  /**
   * {index};{index}[;{index} ...] or all (default). Use location with given index as source.
   * Index: 0 <= integer < #locations
   */
  sources?: number[];
  /**
   * {index};{index}[;{index} ...] or all (default). Use location with given index as destination.
   * Index: 0 <= integer < #locations
   */
  destinations?: number[];
  /** duration (default), distance, or duration, distance. Return the requested table or tables in response. */
  annotations?: Annotation;
  /**
   * If no route found between a source/destination pair, calculate the
   * as-the-crow-flies distance, then use this speed to estimate duration.
   * Must be > 0.
   */
  fallback_speed?: number;
  /**
   * input (default), or snapped
   * When using a fallback_speed, use the user-supplied coordinate (input),
   * or the snapped location (snapped) for calculating distances.
   */
  fallback_coordinate?: Coordinate;
  /**
   * Use in conjunction with annotations=durations.
   * Scales the table duration values by this number.
   * Must be > 0.
   */
  scale_factor?: number;
}

/**
 * General options for all requests
 * @see http://project-osrm.org/docs/v5.22.0/api/#general-options
 */
export interface IOsrmOptions {
  /**
   * The coordinates this request will use. Array with [{lon},{lat}] values, in decimal degrees.
   */
  coordinates?: Coordinate[];
  /**
   * Limits the search to segments with given bearing in degrees towards true north in clockwise direction.
   * Null or array with [{value},{range}]. One entry per location or empty.
   */
  bearings?: Bearing[] | null;
  /**
   * Limits the search to given radius in meters. null or double >= 0 or unlimited (default). One entry per location or empty.
   */
  radiuses?: Radius[] | null;
  /**
   * Hint to derive position in street network. One entry per location or empty. Base64 string.
   */
  hints?: Hint[];
  /**
   * Adds a Hint to the response which can be used in subsequent requests, see hints parameter.
   */
  generate_hints?: boolean;
  /** Keep waypoints on curb side. One entry per location or empty. */
  approaches?: Approach[];
  /** Additive list of classes to avoid, order does not matter. Class names are determined by the profile or 'none'. */
  classes?: string[];
}

export interface IMatchOptions extends IOsrmOptions {
  /** If supplied, for each coordinate generate a timestamp (integer seconds since UNIX epoch). */
  timestamps?: number[];
  /**
   * Returned route instructions for each trip.
   * @default false
   */
  steps?: boolean;
  /**
   * Add overview geometry either full, simplified according to highest zoom level
   * it could be display on, or not at all.
   * @default simplified
   */
  overview?: 'simplified' | 'full' | false;
  /**
   * Allows the input track splitting based on huge timestamp gaps between points.
   * @default split
   */
  gaps?: 'split' | 'ignore';
  /**
   * Allows the input track modification to obtain better matching quality for noisy tracks.
   * @default false
   */
  tidy?: boolean;
  /** {Index};{index};{index}...	Treats input coordinates indicated by given indices as waypoints in returned Match object. Default is to treat all input coordinates as waypoints.   */
  waypoints?: number[];
  /**
   * Returned route geometry format (influences overview and per step)
   * @default polyline
   */
  geometries?: 'polyline' | 'polyline6' | 'geojson';
  /** Skip the waypoints in the output result. */
  skip_waypoints?: boolean;
  /**
   * Returns additional metadata for each coordinate along the route geometry.
   * @default false
   */
  annotations?: Annotation;
}

export interface ITripOptions extends IOsrmOptions {
  /**
   * Returned route is a roundtrip (route returns to first location)
   * @default true
   */
  roundtrip?: boolean;
  /**
   * Returned route starts at any or first coordinate.
   * @default any
   */
  source?: 'any' | 'first';
  /**
   * Returned route ends at any or last coordinate.
   * @default any
   */
  destination?: 'any' | 'last';
  /**
   * Returned route instructions for each trip.
   * @default false
   */
  steps?: boolean;
  /**
   * Returns additional metadata for each coordinate along the route geometry.
   * @default false
   */
  annotations?: Annotation;
  /**
   * Returned route geometry format (influences overview and per step)
   * @default polyline
   */
  geometries?: 'polyline' | 'polyline6' | 'geojson';
  /**
   * Add overview geometry either full, simplified according to highest zoom level
   * it could be display on, or not at all.
   * @default simplified
   */
  overview?: 'simplified' | 'full' | false;
  /** Multiple coordinates as [lon, lat] */
  coordinates?: Array<Coordinate>;
}

export interface IUrlOptions extends INearestOptions, IMatchOptions, IRouteOptions, ITableOptions, ITripOptions {
  service?: OsrmService;
  version?: string;
  query?: string;
  profile?: Profile;
  format?: OutputType;
  options?: any;
}

export interface IOsrmWaypoint {
  /** Name of the street the coordinate snapped to. */
  name?: string;
  /** Array that contains the [longitude, latitude] pair of the snapped coordinate. */
  location?: Coordinate;
  /** The distance, in metres, from the input coordinate to the snapped coordinate. */
  distance?: number;
  /**
   * Unique internal identifier of the segment (ephemeral, not constant over data updates).
   * This can be used on subsequent request to significantly speed up the query and to
   * connect multiple services. E.g. you can use the hint value obtained by the nearest
   * query as hint values for route inputs.
   */
  hint?: string;
  /** OpenStreetMap node IDs */
  nodes?: number[];
  /**
   * Number of probable alternative matchings for this trace point.
   * A value of zero indicate that this point was matched unambiguously.
   * Split the trace at these points for incremental map matching.
   */
  alternatives_count?: number;
}

export interface IOsrmMatchWaypoint extends IOsrmWaypoint {
  /** Index of the waypoint inside the trip or matched route. */
  waypoint_index?: number;
  /** Index to the Route object in matchings the sub-trace was matched to. */
  matchings_index?: number;
}

/**
 * Each Waypoint object has the following additional properties,
 *
 * 1) trips_index: index to trips of the sub-trip the point was matched to, and
 * 2) waypoint_index: index of the point in the trip.
 *
 * https://github.com/Project-OSRM/node-osrm/blob/master/docs/api.md#trip
 */
export interface IOsrmTripWaypoint extends IOsrmWaypoint {
  /** Index to trips of the sub-trip the point was matched to. */
  trips_index?: number;
  /** Index of the waypoint inside the trip or matched route. */
  waypoint_index?: number;
}

export interface IOsrmManeuver {
  /** indicates reversal of direction */
  modifier?: Indication;
  /** A [longitude, latitude] pair describing the location of the turn. */
  location?: Coordinate;
  /** The clockwise angle from true north to the direction of travel immediately after the maneuver. Range 0-359. */
  bearing_before?: number;
  /** The clockwise angle from true north to the direction of travel immediately before the maneuver. Range 0-359. */
  bearing_after?: number;
  /**
   * A string indicating the type of maneuver. new identifiers might be introduced without
   * API change Types unknown to the client should be handled like the turn type,
   * the existence of correct modifier values is guranteed.
   */
  type?: /** a basic turn into direction of the modifier */
  StepManeuverType;
  /**
   * An optional integer indicating number of the exit to take.
   * The property exists for the roundabout / rotary property:
   * Number of the roundabout exit to take. If exit is undefined the destination is on the roundabout. */
  exit?: number;
}

/**
 * An intersection gives a full representation of any cross-way the path passes
 * bay. For every step, the very first intersection (intersections[0]) corresponds
 * to the location of the StepManeuver. Further intersections are listed for every
 * cross-way until the next turn instruction.
 */
export interface IOsrmIntersection {
  /** A [longitude, latitude] pair describing the location of the turn. */
  location: Coordinate;
  /**
   * A list of bearing values (e.g. [0,90,180,270]) that are available at the
   * intersection. The bearings describe all available roads at the intersection.
   * Values are between 0-359 (0=true north). */
  bearings: number[];
  /**
   * An array of strings signifying the classes (as specified in the profile) of
   * the road exiting the intersection. E.g. ['toll', 'restricted'].
   */
  classes?: string[];
  /**
   * A list of entry flags, corresponding in a 1:1 relationship to the bearings.
   * A value of true indicates that the respective road could be entered on a
   * valid route. false indicates that the turn onto the respective road would
   * violate a restriction.
   */
  entry: boolean[];
  /**
   * Index into bearings/entry array. Used to calculate the bearing just before
   * the turn. Namely, the clockwise angle from true north to the direction of
   * travel immediately before the maneuver/passing the intersection. Bearings
   * are given relative to the intersection. To get the bearing in the direction
   * of driving, the bearing has to be rotated by a value of 180. The value is
   * not supplied for depart maneuvers.
   */
  in?: number;
  /**
   * Index into the bearings/entry array. Used to extract the bearing just after
   * the turn. Namely, The clockwise angle from true north to the direction of
   * travel immediately after the maneuver/passing the intersection. The value
   * is not supplied for arrive maneuvers.
   */
  out?: number;
  /**
   * Array of Lane objects that denote the available turn lanes at the intersection.
   * If no lane information is available for an intersection, the lanes property
   * will not be present.
   */
  lanes?: IOsrmLane[];
}

export interface IOsrmRouteStep {
  /** The distance of travel from the maneuver to the subsequent step, in float meters. */
  distance?: number;
  /** The estimated travel time, in float number of seconds. */
  duration?: number;
  /**
   * The unsimplified geometry of the route segment, depending on the geometries parameter.
   * polyline	polyline with precision 5 in [latitude,longitude] encoding
   * polyline6	polyline with precision 6 in [latitude,longitude] encoding
   * geojson	GeoJSON LineString
   */
  geometry?: 'polyline' | 'polyline6' | 'geojson' | ILineString;
  /** The calculated weight of the step. */
  weight?: number;
  /** The name of the way along which travel proceeds. */
  name?: string;
  /** A reference number or code for the way. Optionally included, if ref data is available for the given way. */
  ref?: string;
  /** A string containing an IPA phonetic transcription indicating how to pronounce the name in the name property. This property is omitted if pronunciation data is unavailable for the step. */
  pronunciation: string;
  /** The destinations of the way. Will be undefined if there are no destinations. */
  destinations?: string;
  /** The exit numbers or names of the way. Will be undefined if there are no exit numbers or names. */
  exits?: string;
  /** A string signifying the mode of transportation. */
  mode?: Profile;
  /** A StepManeuver object representing the maneuver. */
  maneuver?: IOsrmManeuver;
  /** A list of Intersection objects that are passed along the segment, the very first belonging to the StepManeuver */
  intersections?: IOsrmIntersection[];
  /** The name for the rotary. Optionally included, if the step is a rotary and a rotary name is available. */
  rotary_name?: string;
  /** The pronunciation hint of the rotary name. Optionally included, if the step is a rotary and a rotary pronunciation is available. */
  rotary_pronunciation?: string;
  /** The legal driving side at the location for this step. Either left or right.   */
  driving_side?: 'right' | 'left';
}

/** Annotation of the whole route leg with fine-grained information about each segment or node id. */
export interface IOsrmAnnotation {
  /** The distance, in metres, between each pair of coordinates */
  distance: number;
  /** The duration between each pair of coordinates, in seconds. Does not include the duration of any turns. */
  duration: number;
  /** The index of the datasource for the speed between each pair of coordinates. 0 is the default profile, other values are supplied via --segment-speed-file to osrm-contract or osrm-customize. String-like names are in the metadata.datasource_names array. */
  datasources: number[];
  /** The OSM node ID for each coordinate along the route, excluding the first/last user-supplied coordinates */
  nodes: number[];
  /** The weights between each pair of coordinates. Does not include any turn costs. */
  weight: number;
  /** Convenience field, calculation of distance / duration rounded to one decimal place. */
  speed: number;
  /** Metadata related to other annotations. */
  metadata: {
    /**
     * The names of the datasources used for the speed between each pair of coordinates.
     * lua profile is the default profile, other values arethe filenames supplied via
     *  --segment-speed-file to osrm-contract or osrm-customize */
    datasources_names: string[];
    [key: string]: any;
  };
}

/** A Lane represents a turn lane at the corresponding turn location. */
export interface IOsrmLane {
  /**
   * An indication (e.g. marking on the road) specifying the turn lane.
   * A road can have multiple indications (e.g. an arrow pointing straight and left).
   */
  indications: Indication[];
  /** A boolean flag indicating whether the lane is a valid choice in the current maneuver */
  valid: boolean;
}

/** Represents a route between two waypoints. */
export interface IOsrmRouteLeg {
  /** The distance traveled by this route leg, in float meters. */
  distance?: number;
  /** The estimated travel time, in float number of seconds. */
  duration?: number;
  /**
   * Summary of the route taken as string. Depends on the summary parameter:
   * - true: Names of the two major roads used. Can be empty if route is too short.
   * - false: empty string.
   */
  summary?: string;
  /** The calculated weight of the route leg. */
  weight?: number;
  /**
   * Depends on the steps parameter.
   * - true: array of IOsrmRouteStep objects describing the turn-by-turn instructions
   * - false: empty array
   */
  steps?: IOsrmRouteStep[];
  /**
   * Additional details about each coordinate along the route geometry:
   * - true: An Annotation object containing node ids, durations, distances and weights.
   * - false: undefined
   */
  annotation?: IOsrmAnnotation;
}

export interface IOsrmRoute {
  /** The distance traveled by the route, in float meters. */
  distance?: number;
  /** The estimated travel time, in float number of seconds. */
  duration?: number;
  /**
   * The whole geometry of the route value depending on overview parameter,
   * format depending on the geometries parameter.
   * See RouteStep's geometry property for a parameter documentation. */
  geometry?: string;
  /** The legs between the given waypoints, an array of RouteLeg objects. */
  legs?: IOsrmRouteLeg[];
  /** The name of the weight profile used during extraction phase. */
  weight_name?: 'routability';
  /** The calculated weight of the route. */
  weight?: number;
}

export interface IOsrmMatchRoute extends IOsrmRoute {
  /**
   * (Optional) confidence of the matching (for match service).
   * Float value between 0 and 1. 1 is very confident that the matching is correct.
   */
  confidence?: number;
}

export interface IOsrmNearestResult extends IOsrmResult {
  /** Array of Waypoint objects sorted by distance to the input coordinate. */
  waypoints: IOsrmWaypoint[];
}

export interface IOsrmRouteResult extends IOsrmResult {
  /** Array of Waypoint objects representing all waypoints in order: */
  waypoints: IOsrmWaypoint[];
  /** An array of Route objects, ordered by descending recommendation rank. */
  routes: IOsrmRoute[];
}

export interface IOsrmMatchResult extends IOsrmResult {
  /**
   * Array of Waypoint objects representing all points of the trace in order.
   * If the trace point was ommited by map matching because it is an outlier,
   * the entry will be null.
   */
  tracepoints: IOsrmMatchWaypoint[];
  /**
   * An array of Route objects that assemble the trace. */
  matchings: IOsrmMatchRoute[];
}

export interface IOsrmTableResult extends IOsrmResult {
  /**
   * Array of arrays that stores the matrix in row-major order.
   * durations[i][j] gives the travel time from the i-th waypoint to the j-th waypoint.
   * Values are given in seconds. Can be null if no route between i and j can be found.
   */
  durations: number[][];
  /**
   * Array of arrays that stores the matrix in row-major order.
   * distances[i][j] gives the travel distance from the i-th waypoint to the j-th waypoint.
   * Values are given in meters. Can be null if no route between i and j can be found.
   */
  distances: number[][];
  /** Array of Waypoint objects describing all sources in order. */
  sources: IOsrmWaypoint[];
  /** Array of Waypoint objects describing all destinations in order. */
  destinations: IOsrmWaypoint[];
  /**
   * (Optional) array of arrays containing i,j pairs indicating which cells contain estimated
   * values based on fallback_speed. Will be absent if fallback_speed is not used.
   */
  fallback_speed_cells?: number[][];
}

export interface IOsrmTripResult extends IOsrmResult {
  /** Array of Waypoint objects representing all waypoints in order: */
  waypoints: IOsrmTripWaypoint[];
  /** An array of Route objects, ordered by descending recommendation rank. */
  trips: IOsrmRoute[];
}

export interface IOsrm {
  /** Snaps a coordinate to the street network and returns the nearest n matches. */
  nearest: {
    (options: INearestOptions, callback: (err: Error | null, result?: IOsrmNearestResult | undefined) => void): void;
    (options: INearestOptions): Promise<IOsrmNearestResult>;
  };
  /** Finds the fastest route between coordinates in the supplied order. */
  route: {
    (options: IRouteOptions, callback: (err: Error | null, result?: IOsrmRouteResult | undefined) => void): void;
    (options: IRouteOptions): Promise<IOsrmRouteResult>;
  };
  /**
   * Map matching matches/snaps given GPS points to the road network in the most plausible way.
   * Please note the request might result multiple sub-traces. Large jumps in the timestamps
   * (> 60s) or improbable transitions lead to trace splits if a complete matching could not
   * be found. The algorithm might not be able to match all points.
   * Outliers are removed if they can not be matched successfully.
   */
  match: {
    (options: IMatchOptions, callback: (err: Error | null, result?: IOsrmMatchResult | undefined) => void): void;
    (options: IMatchOptions): Promise<IOsrmMatchResult>;
  };
  /**
   * The trip plugin solves the Traveling Salesman Problem using a greedy heuristic
   * (farthest-insertion algorithm) for 10 or more waypoints and uses brute force
   * for less than 10 waypoints. The returned path does not have to be the fastest path.
   * As TSP is NP-hard it only returns an approximation.
   * Note that all input coordinates have to be connected for the trip service to work.
   */
  trip: {
    (options: ITripOptions, callback: (err: Error | null, result?: IOsrmTripResult | undefined) => void): void;
    (options: ITripOptions): Promise<IOsrmTripResult>;
  };
  /**
   * Computes the duration of the fastest route between all pairs of supplied coordinates.
   * Returns the durations or distances or both between the coordinate pairs. Note that
   * the distances are not the shortest distance between two coordinates, but rather the
   * distances of the fastest routes. Duration is in seconds and distances is in meters.
   */
  table: {
    (options: ITableOptions, callback: (err: Error | null, result?: IOsrmTableResult | undefined) => void): void;
    (options: ITableOptions): Promise<IOsrmTableResult>;
  };
  /**
   * This service generates Mapbox Vector Tiles that can be viewed with a vector-tile capable
   * slippy-map viewer. The tiles contain road geometries and metadata that can be used to
   * examine the routing graph. The tiles are generated directly from the data in-memory,
   * so are in sync with actual routing results, and let you examine which roads are actually routable,
   * and what weights they have applied.
   */
  tile: {
    (xyz: number[], callback: (err: Error | null, result?: Buffer | undefined) => void): void;
    (xyz: number[]): Promise<Buffer>;
  };
}

export const OSRM = (
  arg: {
    /** OSRM server URL */
    osrm?: string;
    /** Default routing profile */
    defaultProfile?: Profile;
    /** Timeout in msec, default 10s */
    timeout?: number;
  } = {}
) => {
  const { osrm = 'https://router.project-osrm.org', defaultProfile = 'driving', timeout = 10000 } = arg;

  const protocol = osrm.substr(0, osrm.indexOf('//'));
  if (protocol !== 'http:' && protocol !== 'https:') {
    throw new Error(`Unsupported protocol: ${protocol}`);
  }

  // const get2 = (url: string, callback: (result: any) => void) =>
  //   protocol === 'http:' ? http.get(url, callback) : https.get(url, callback);

  // const get = (url: string, callback: (result: any) => void) =>
  //   protocol === 'http:' ? superagent.get(url, callback);

  /** Remove certain options */
  const filterOptions = (options: IOsrmOptions, keys: Array<keyof IOsrmOptions>) => {
    const filtered = {} as IOsrmOptions;
    for (const k in options) {
      if (keys.indexOf(k as keyof IOsrmOptions) >= 0) {
        continue;
      }
      filtered[k as keyof IOsrmOptions] = options[k as keyof IOsrmOptions] as any;
    }
    return filtered;
  };

  /** Convert the coordinates to a string */
  const stringifyCoordinates = (lonLats: Coordinate[]) => lonLats.map((c) => `${c[0]},${c[1]}`).join(';');

  const stringifyOptions = (obj: { [key: string]: any } = {}) =>
    Object.keys(obj)
      .filter((key) => typeof obj[key] !== 'undefined' && obj[key] !== '' && obj[key] !== null)
      .reduce((acc, key) => {
        const k = encodeURIComponent(key);
        const v = obj[key];
        const val = v instanceof Array ? v.map((value) => (value === null && '') || value).join(';') : v;
        acc.push(`${k}=${encodeURIComponent(val)}`);
        return acc;
      }, [] as string[])
      .join('&');

  const queryOptions = (options: ITripOptions | IMatchOptions | IRouteOptions | ITableOptions, expectedLength = 2) => {
    if (!options.coordinates) {
      throw new Error('No coordinates properties in options!');
    }
    if (options.coordinates.length < expectedLength) {
      throw new Error(`Needs at least ${expectedLength} coordinate${expectedLength === 1 ? '' : 's'}!`);
    }
    const query = stringifyCoordinates(options.coordinates);
    const opts = filterOptions(options, ['coordinates']);
    return { query, opts };
  };

  const encodeUrl = ({
    service,
    version = 'v1',
    query,
    format = 'json',
    profile = defaultProfile,
    options = {},
  }: Partial<IUrlOptions>) => {
    const optionStr = stringifyOptions(options);
    return `${osrm}/${service}/${version}/${profile}/${query}.${format}${optionStr.length > 0 ? `?${optionStr}` : ''}`;
  };

  const request = (arg: string | Partial<IUrlOptions>, callback: (err: Error | null, result?: any) => void) => {
    const url = typeof arg === 'string' ? osrm + arg : encodeUrl(arg);

    superagent
      .get(url)
      .timeout(10000)
      .then((response) => {
        const format = response.header['content-type'].split(';')[0];
        if (format === 'application/json') {
          callback(null, JSON.parse(response.text));
        } else {
          callback(null, response.body); // unknown, pass through
        }
      })
      .catch((err) => callback(err));
  };

  function nearest(options: INearestOptions, callback: (err: Error | null, result?: IOsrmNearestResult) => void): void;
  function nearest(options: INearestOptions): Promise<IOsrmNearestResult>;

  /** Snaps a coordinate to the street network and returns the nearest n matches. */
  function nearest(options: INearestOptions, callback?: (err: Error | null, result?: IOsrmNearestResult) => void) {
    const { query, opts } = queryOptions(options, 1);
    if (callback) {
      request({ service: 'nearest', query, options: opts }, callback);
    } else {
      return new Promise<IOsrmNearestResult>((resolve, reject) => {
        request({ service: 'nearest', query, options: opts }, (err, result) => {
          if (err) {
            reject(err);
          } else {
            resolve(result);
          }
        });
      });
    }
  }

  function match(options: IMatchOptions, callback: (err: Error | null, result?: IOsrmMatchResult) => void): void;
  function match(options: IMatchOptions): Promise<IOsrmMatchResult>;

  /**
   * Map matching matches/snaps given GPS points to the road network in the most plausible way.
   * Please note the request might result multiple sub-traces. Large jumps in the timestamps
   * (> 60s) or improbable transitions lead to trace splits if a complete matching could not
   * be found. The algorithm might not be able to match all points.
   * Outliers are removed if they can not be matched successfully.
   */
  function match(options: IMatchOptions, callback?: (err: Error | null, result?: IOsrmMatchResult) => void) {
    if (options.timestamps && options.coordinates && options.coordinates.length !== options.timestamps.length) {
      throw new Error('Timestamps array needs to be the same size as the coordinates array');
    }
    const { query, opts } = queryOptions(options);
    if (callback) {
      request({ service: 'match', query, options: opts }, callback);
    } else {
      return new Promise<IOsrmMatchResult>((resolve, reject) => {
        request({ service: 'match', query, options: opts }, (err, result) => {
          if (err) {
            reject(err);
          } else {
            resolve(result);
          }
        });
      });
    }
  }

  function route(options: IRouteOptions, callback: (err: Error | null, result?: IOsrmRouteResult) => void): void;
  function route(options: IRouteOptions): Promise<IOsrmRouteResult>;

  /** Finds the fastest route between coordinates in the supplied order. */
  function route(options: IRouteOptions, callback?: (err: Error | null, result?: IOsrmRouteResult) => void) {
    const { query, opts } = queryOptions(options);
    if (callback) {
      request({ service: 'route', query, options: opts }, callback);
    } else {
      return new Promise<IOsrmRouteResult>((resolve, reject) => {
        request({ service: 'route', query, options: opts }, (err, result) => {
          if (err) {
            reject(err);
          } else {
            resolve(result);
          }
        });
      });
    }
  }

  function table(options: ITableOptions, callback: (err: Error | null, result?: IOsrmTableResult) => void): void;
  function table(options: ITableOptions): Promise<IOsrmTableResult>;

  /**
   * Computes the duration of the fastest route between all pairs of supplied coordinates.
   * Returns the durations or distances or both between the coordinate pairs. Note that
   * the distances are not the shortest distance between two coordinates, but rather the
   * distances of the fastest routes. Duration is in seconds and distances is in meters.
   */
  function table(options: ITableOptions, callback?: (err: Error | null, result?: IOsrmTableResult) => void) {
    const { query, opts } = queryOptions(options);
    if (callback) {
      request({ service: 'table', query, options: opts }, callback);
    } else {
      return new Promise<IOsrmTableResult>((resolve, reject) => {
        request({ service: 'table', query, options: opts }, (err, result) => {
          if (err) {
            reject(err);
          } else {
            resolve(result);
          }
        });
      });
    }
  }

  function trip(options: ITripOptions, callback: (err: Error | null, result?: IOsrmTripResult) => void): void;
  function trip(options: ITripOptions): Promise<IOsrmTripResult>;

  /**
   * The trip plugin solves the Traveling Salesman Problem using a greedy heuristic
   * (farthest-insertion algorithm) for 10 or more waypoints and uses brute force
   * for less than 10 waypoints. The returned path does not have to be the fastest path.
   * As TSP is NP-hard it only returns an approximation.
   * Note that all input coordinates have to be connected for the trip service to work.
   */
  function trip(options: ITripOptions, callback?: (err: Error | null, result?: IOsrmTripResult) => void) {
    const { query, opts } = queryOptions(options);
    if (callback) {
      request({ service: 'trip', query, options: opts }, callback);
    } else {
      return new Promise<IOsrmTripResult>((resolve, reject) => {
        request({ service: 'trip', query, options: opts }, (err, result) => {
          if (err) {
            reject(err);
          } else {
            resolve(result);
          }
        });
      });
    }
  }

  function tile(xyz: number[], callback: (err: Error | null, result?: Buffer) => void): void;
  function tile(xyz: number[]): Promise<Buffer>;

  /**
   * This service generates Mapbox Vector Tiles that can be viewed with a vector-tile capable
   * slippy-map viewer. The tiles contain road geometries and metadata that can be used to
   * examine the routing graph. The tiles are generated directly from the data in-memory,
   * so are in sync with actual routing results, and let you examine which roads are actually routable,
   * and what weights they have applied.
   */
  function tile(xyz: number[], callback?: (err: Error | null, result?: Buffer) => void) {
    const query = `tile(${xyz.join(',')})`;
    if (callback) {
      request({ service: 'tile', query, format: 'mvt' }, callback);
    } else {
      return new Promise<Buffer>((resolve, reject) => {
        request({ service: 'tile', query, format: 'mvt' }, (err, result) => {
          if (err) {
            reject(err);
          } else {
            resolve(result);
          }
        });
      });
    }
  }

  return {
    /** Snaps a coordinate to the street network and returns the nearest n matches. */
    nearest,
    /** Finds the fastest route between coordinates in the supplied order. */
    route,
    /**
     * Map matching matches/snaps given GPS points to the road network in the most plausible way.
     * Please note the request might result multiple sub-traces. Large jumps in the timestamps
     * (> 60s) or improbable transitions lead to trace splits if a complete matching could not
     * be found. The algorithm might not be able to match all points.
     * Outliers are removed if they can not be matched successfully.
     */
    match,
    /**
     * The trip plugin solves the Traveling Salesman Problem using a greedy heuristic
     * (farthest-insertion algorithm) for 10 or more waypoints and uses brute force
     * for less than 10 waypoints. The returned path does not have to be the fastest path.
     * As TSP is NP-hard it only returns an approximation.
     * Note that all input coordinates have to be connected for the trip service to work.
     */
    trip,
    /**
     * Computes the duration of the fastest route between all pairs of supplied coordinates.
     * Returns the durations or distances or both between the coordinate pairs. Note that
     * the distances are not the shortest distance between two coordinates, but rather the
     * distances of the fastest routes. Duration is in seconds and distances is in meters.
     */
    table,
    /**
     * This service generates Mapbox Vector Tiles that can be viewed with a vector-tile capable
     * slippy-map viewer. The tiles contain road geometries and metadata that can be used to
     * examine the routing graph. The tiles are generated directly from the data in-memory,
     * so are in sync with actual routing results, and let you examine which roads are actually routable,
     * and what weights they have applied.
     */
    tile,
  } as IOsrm;
};
