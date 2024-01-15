<div style="display:flex;"><img width="250" src="https://github.com/physia/kflutter/assets/22839194/9f122928-0ec1-4b2d-a908-13307f257acb"><img width="150" src="https://github.com/physia/kflutter/assets/22839194/0145bb19-3c3c-49ec-8654-73c63f0c94a9"><img width="150"  src="https://github.com/physia/kflutter/assets/22839194/7b923821-f43b-436c-b057-bbd3da7c7351"></div>

This package provide easy way pick location using flutter_map.

## Features

- [X] Single/multiple selection.
- [X] Support `flutter_map` package and its options.
- [X] Cache tiles using `cached_network_image` package.
- [X] Support all `cached_network_image` options.

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
5. [flutter_map_cached_tile_provider](https://pub.dev/packages/flutter_map_cached_tile_provider): cache for `flutter_map` plugin.

## Support/Job?

contact me: mohamadlounnas@gmail.com
