// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:kplayer/kplayer.dart';

// /// [PlatformInfo] class is used to get information about the platform.
// /// information like the current platform, environment, and version.
// abstract class PlatformInfo {
//   static PlatformEnvironment get environment {
//     if (kIsWeb){
//       return PlatformEnvironment.web;
//     } else if (Platform.isAndroid) {
//       return PlatformEnvironment.android;
//     } else if (Platform.isIOS) {
//       return PlatformEnvironment.ios;
//     } else if (Platform.isWindows) {
//       return PlatformEnvironment.windows;
//     } else if (Platform.isLinux) {
//       return PlatformEnvironment.linux;
//     } else if (Platform.isMacOS) {
//       return PlatformEnvironment.macos;
//     } else if (Platform.isFuchsia) {
//       return PlatformEnvironment.fuchsia;
//     } else {
//       return PlatformEnvironment.unknown;
//     }
//   }
// }

// ///Platform Adaptive Player