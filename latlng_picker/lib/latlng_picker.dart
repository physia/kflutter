library latlng_picker;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cached_tile_provider/flutter_map_cached_tile_provider.dart';
import 'package:latlong2/latlong.dart';

/// [LatLngPicker] is a widget that allows the user to pick a location on the map.
/// It can be used as a dialog or as a widget in the widget tree.
class LatLngPicker extends StatefulWidget {
  const LatLngPicker({
    super.key,
    this.controller,
    this.options,
    this.length = 1,
    this.onConfirm,
    this.onSelect,
  }) : assert(length > 0, 'length must be greater than 0');
  const LatLngPicker.single({
    super.key,
    this.controller,
    this.options,
    this.onConfirm,
    this.onSelect,
  }) : length = 1;
  const LatLngPicker.multiple({
    super.key,
    this.controller,
    this.options,
    required this.length,
    this.onConfirm,
    this.onSelect,
  }) : assert(length > 0, 'length must be greater than 0');

  /// The [MapController] that controls the map.
  /// see `flutter_map` package for more info.
  final MapController? controller;

  /// The [MapOptions] that controls the map.
  /// see `flutter_map` package for more info.
  final MapOptions? options;

  /// The number of locations to pick.
  final int length;

  /// Called when the user confirms the selected locations.
  final void Function(List<LatLng>)? onConfirm;

  /// Called when the user selects a location.
  final void Function(LatLng)? onSelect;

  @override
  State<LatLngPicker> createState() => _LatLngPickerState();
}

class _LatLngPickerState extends State<LatLngPicker> {
  late final controller = widget.controller ?? MapController();
  late final options = widget.options ??
      const MapOptions(
        initialCenter: LatLng(31.5, 34.46667),
      );
  late StreamSubscription<MapEvent> _mapEventSubscription;
  late LatLng _currentMarker = options.initialCenter;
  final List<LatLng> _markers = [];

  @override
  void initState() {
    super.initState();
    _mapEventSubscription = controller.mapEventStream.listen((event) {
      if (event is MapEventMove) {
        setState(() {
          _currentMarker = event.camera.center;
        });
      }
    });
  }

  @override
  void dispose() {
    _mapEventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: FlutterMap(
            mapController: controller,
            options: options,
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.google.maps',
                tileProvider: CachedTileProvider(),
              ),
              // pins of assistances
              MarkerLayer(
                markers: [
                  for (final marker in _markers)
                    Marker(
                      width: 25,
                      height: 25,
                      point: marker,
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.primary),
                        child: Center(
                          child: Text(
                            '${_markers.toList().indexOf(marker) + 1}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        // marker at the center of the map
        const IgnorePointer(
          child: Center(
            child: MapPointer(
              width: 2,
            ),
          ),
        ),

        // gradient
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 100,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.background.withOpacity(0),
                    Theme.of(context).colorScheme.background.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_markers.length == widget.length) ...[
                // delete all markers
                TextButton.icon(
                  icon: const Icon(Icons.delete_forever_rounded),
                  label: const Text('CLEAR'),
                  onPressed: () {
                    setState(() {
                      _markers.clear();
                    });
                  },
                ),
                const SizedBox(height: 16),
                // confirm
                FilledButton.icon(
                  style: ElevatedButton.styleFrom(elevation: 5),
                  icon: const Icon(Icons.done_all_rounded),
                  label: const Text('CONFIRM'),
                  onPressed: () {
                    widget.onConfirm?.call(_markers);
                  },
                )
              ] else
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(elevation: 5),
                  icon: const Icon(Icons.gps_fixed_outlined),
                  label: const Text('SELECT'),
                  onPressed: () {
                    setState(() {
                      _markers.add(_currentMarker);
                    });
                    widget.onSelect?.call(_currentMarker);
                  },
                ),
              const SizedBox(height: 16),
              Text(
                "${_currentMarker.latitude}, ${_currentMarker.longitude}",
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// [LatLngPickerDialog] is a dialog that allows the user to pick a location on the map.
/// it uses [LatLngPicker] internally.
class LatLngPickerDialog extends StatelessWidget {
  const LatLngPickerDialog({
    super.key,
    this.options,
    this.fullscreen = false,
    this.length = 1,
  });
  final bool fullscreen;
  final int length;
  final MapOptions? options;

  @override
  Widget build(BuildContext context) {
    var child = Stack(
      children: [
        Positioned.fill(
          child: LatLngPicker(
            options: options,
            length: length,
            onConfirm: (latLngs) {
              Navigator.of(context).pop(latLngs);
            },
          ),
        ),
        // gradient
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 100,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.background.withOpacity(0.7),
                    Theme.of(context).colorScheme.background.withOpacity(0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        // app bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text('Select location'),
          ),
        ),
      ],
    );
    if (fullscreen) {
      return Dialog.fullscreen(
        child: child,
      );
    }
    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: child,
      ),
    );
  }
}

/// [MapPointer] is a widget that draws a pointer on the map.
class MapPointer extends StatelessWidget {
  const MapPointer({
    super.key,
    this.lines = 3,
    this.color,
    this.width = 2,
  });

  final int lines;
  final Color? color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: kMinInteractiveDimension,
      child: Stack(
        children: [
          for (var i = 0; i < lines; i++)
            Center(
              child: Transform.rotate(
                // angle: (-2*pi / 3)*i + pi/2,
                angle: (-2 * pi / lines) * i + pi / 2,
                child: Container(
                  width: double.infinity,
                  height: width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (color ?? Theme.of(context).colorScheme.primary).withOpacity(0),
                        color ?? Theme.of(context).colorScheme.primary,
                        (color ?? Theme.of(context).colorScheme.primary).withOpacity(0),
                      ],
                      stops: const [
                        0.0,
                        0.5,
                        0.0
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// [showLatLngPickerDialog] is a helper function that shows a [LatLngPickerDialog].
Future<List<LatLng>?> showLatLngPickerDialog({
  // latlng picker options
  MapOptions? options,
  bool fullscreen = false,
  int length = 1,
  // dialog options
  required BuildContext context,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TraversalEdgeBehavior? traversalEdgeBehavior,
}) async {
  return await showDialog<List<LatLng>>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    traversalEdgeBehavior: traversalEdgeBehavior,
    builder: (context) {
      return LatLngPickerDialog(
        options: options,
        fullscreen: fullscreen,
        length: length,
      );
    },
  );
}
