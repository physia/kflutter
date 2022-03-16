import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:dart_vlc/src/widgets/video.dart';
import 'package:dart_vlc_ffi/src/internal/ffi.dart' as FFI;
import 'package:dart_vlc_ffi/dart_vlc_ffi.dart' as FFI;
export 'package:dart_vlc_ffi/dart_vlc_ffi.dart' hide DartVLC, Player;
export 'package:dart_vlc/src/widgets/video.dart';

abstract class DartVLC {
  static void initialize() {
    FFI.videoFrameCallback = (int playerId, Uint8List videoFrame) {
      if (videoStreamControllers[playerId] != null &&
          FFI.players[playerId] != null) {
        if (!videoStreamControllers[playerId]!.isClosed) {
          videoStreamControllers[playerId]!.add(VideoFrame(
              playerId: playerId,
              videoWidth: FFI.players[playerId]!.videoDimensions.width,
              videoHeight: FFI.players[playerId]!.videoDimensions.height,
              byteArray: videoFrame));
        }
      }
    };
    if (Platform.isWindows) {
      final libraryPath = path.join(
          path.dirname(Platform.resolvedExecutable), 'dart_vlc_plugin.dll');
      FFI.DartVLC.initialize(libraryPath);
    } else if (Platform.isLinux) {
      final libraryPath = path.join(path.dirname(Platform.resolvedExecutable),
          'lib', 'libdart_vlc_plugin.so');
      FFI.DartVLC.initialize(libraryPath);
    } else if (Platform.isMacOS) {
      final libraryPath = path.join(
          path.dirname(path.dirname(Platform.resolvedExecutable)),
          'Frameworks',
          'dart_vlc.framework',
          'dart_vlc');
      FFI.DartVLC.initialize(libraryPath);
    } else if (Platform.isIOS) {
      final libraryPath = path.join(
        path.dirname(Platform.resolvedExecutable),
        'Frameworks',
        'dart_vlc.framework',
        'dart_vlc',
      );
      FFI.DartVLC.initialize(libraryPath);
    }
  }
}
