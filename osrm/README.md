# OSRM
This package is the OSRM client for Dart and Flutter. It provides a simple and easy-to-use interface for communicating with an OSRM server and retrieving routing and other information.

To use this package, simply add it to your `pubspec.yaml` file:
dependencies:
    osrm:
## Usage
To use the OSRM client, first create an instance of the `OSRM` class:
### Simple use
#### nearest service
```dart
NearestResponse response = await osrm.nearest(
  NearestOptions(
    coordinate: (-0.1234, 51.1234),
    number: 3
  ),
);
```
#### routing (direction) service
```dart
final route = await osrm.route(
  RouteRequest(
    coordinates: [
      (-0.1234, 51.1234),
      (-0.1234, 51.1234),
      (-0.1234, 51.1234),
    ],
    alternatives: OsrmAlternative.true_,
    steps: true,
    annotations: OsrmAnnotation.true_,
    overview: OsrmOverview.full,
    continueStraight: OsrmContinueStraight.true_,
    format: OsrmFormat.json,
    waypoints: [
      OsrmWaypoint(
        distance: 0.0,
        location: (-0.1234, 51.1234),
      ),
    ],
  ),
);
```

this package under development.

## TODO
(*) add 'Nearest' service
(*) add 'Nearest' service tests
(*) add 'Route' service
(*) add 'Route' service tests
( ) add 'Match' service
( ) add 'Table' service
( ) add 'trip' service
( ) add 'Tile' service
( ) integrate with flutter

## Support/Sponcer this project
contact me: <mohamadlounnas@gmail.com>

**Coffee for my mind**
<a href="https://www.buymeacoffee.com/mohamadlounnas"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=mohamadlounnas&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff"></a>
