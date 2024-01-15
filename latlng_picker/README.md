This package provide easy way pick location using flutter_map.

## Features

- [x] Single/multiple selection.
- [x] Support `flutter_map` package and its options.
- [x] Cache tiles using `cached_network_image` package.
- [x] Support all `cached_network_image` options.

## Getting started

```yaml
dependencies:
    latlng_picker: ^0.0.1
```

## Usage

for easy way you can use the `showLatLngPicker` function to show the picker in a dialog.
it uses `LatLngPickerDialog` internally wish is embading the `LatLngPicker` widget.

```dart
import 'package:latlng_picker/latlng_picker.dart';

LatLng? latLng = await showLatLngPicker(context);
```

## Additional information

for advanced usage you can use the `LatLngPicker` widget. it contains all the features of the `flutter_map` package.

## Other projects?

check my other projects:

1. [osrm](https://pub.dev/packages/osrm): Open Source Routing Machine (OSRM) client for Dart.
2. [indexed](https://pub.dev/packages/indexed): indexed widget, allow you to order the items inside stack, sothing like `z-index`.
3. [kplayer](https://pub.dev/packages/kplayer): audio player that support all platforms.
4. [puncher](https://pub.dev/packages/puncher): puncher is a flutter package that helps you to create a puncher widget.
4. [flutter_map_cached_tile_provider](https://pub.dev/packages/flutter_map_cached_tile_provider): cache for `flutter_map` plugin.

## Support/Job?

contact me: mohamadlounnas@gmail.com
