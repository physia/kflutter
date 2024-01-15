library flutter_map_cached_tile_provider;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
// ignore: depend_on_referenced_packages
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';

/// `flutter_map_cached_tile_provider.dart`
///
/// This file contains the `CachedTileProvider` class which extends the `TileProvider` class from the `flutter_map` package.
/// The `CachedTileProvider` class is used to provide tiles for the map, with caching capabilities.
///
/// Usage:
/// This class can be used with a `FlutterMap` widget to provide cached tiles for the map. The `CachedTileProvider` should be passed to the `tileProvider` property of the `TileLayerOptions` used with the `FlutterMap`.
/// example:
/// ```dart
/// FlutterMap(
///   options: MapOptions(),
///   layers: [
///     TileLayerOptions(
///       tileProvider: CachedTileProvider(),
///     ),
///   ],
/// );
/// ```
class CachedTileProvider extends TileProvider {
  /// [cacheManager] is the [BaseCacheManager] used to cache the tiles.
  ///
  /// [cacheManager] defaults to the [DefaultCacheManager].
  final BaseCacheManager? cacheManager;

  /// [cacheKey] is the key used to cache the tiles.
  ///
  /// [cacheKey] defaults to the [DefaultCacheManager].
  final String? cacheKey;

  /// [scale] is the scale used to cache the tiles.
  final double scale;

  /// [errorListener] is the error listener used to cache the tiles.
  final void Function(Object)? errorListener;

  /// [imageRenderMethodForWeb] is the image render method for web used to cache the tiles.
  final ImageRenderMethodForWeb imageRenderMethodForWeb;

  /// [maxHeight] is the max height used to cache the tiles.
  final int? maxHeight;

  /// [maxWidth] is the max width used to cache the tiles.
  final int? maxWidth;

  CachedTileProvider({
    super.headers,
    this.cacheManager,
    this.cacheKey,
    this.scale = 1.0,
    this.errorListener,
    this.imageRenderMethodForWeb = ImageRenderMethodForWeb.HtmlImage,
    this.maxHeight,
    this.maxWidth,
  });

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) => CachedNetworkImageProvider(
        getTileUrl(coordinates, options),
        headers: headers,
        cacheManager: cacheManager,
        cacheKey: cacheKey,
        scale: scale,
        errorListener: errorListener,
        imageRenderMethodForWeb: imageRenderMethodForWeb,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
      );
}
