This package provide a cache for `flutter_map` plugin using `cached_network_image` package.

## Features

cache images from network with `cached_network_image` package.
all its features are available. check the `CachedTileProvider` class.

## Getting started

```yaml
dependencies:
  flutter_map_cached_tile_provider: ^0.0.1
```

## Usage

Add the `CachedTileProvider` to your `FlutterMap` layers.

```dart
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cached_tile_provider/flutter_map_cached_tile_provider.dart';

FlutterMap(
  options: MapOptions(
    plugins: [
      CachedTileProviderPlugin(),
    ],
  ),
  layers: [
    TileLayer(
        tileProvider: CachedTileProvider(), // use the CachedTileProvider
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    ),
  ],
);
```

## Additional information

you can change the `cacheManager` and all other options of `cached_network_image` package by passing them to the `CachedTileProvider` constructor.

## Other projects?

check my other projects:

1. [osrm](https://pub.dev/packages/osrm): Open Source Routing Machine (OSRM) client for Dart.
2. [indexed](https://pub.dev/packages/indexed): indexed widget, allow you to order the items inside stack, sothing like z-index
3. [kplayer](https://pub.dev/packages/kplayer): audio player that support all platforms.
4. [puncher](https://pub.dev/packages/puncher): puncher is a flutter package that helps you to create a puncher widget.

## Support/Job?

contact me: mohamadlounnas@gmail.com
