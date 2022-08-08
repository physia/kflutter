// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final player = AudioPlayer();
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   dispose() {
//     super.dispose();
//     player.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           FloatingActionButton(
//             child: Text("setSourceUrl"),
//             onPressed: () {
//               player.setSourceUrl(
//                   "https://archive.org/download/s0v5kiwcwp1zaps7pdwjtp5o8e6clmevdnewngnd/JSJ_385_Panel.mp3");
//               player.resume();
//             },
//           ),
//           FloatingActionButton(
//             child: Text("setSourceAsset"),
//             onPressed: () {
//               player.setSourceAsset("assets/Introducing_flutter.mp3");
//               player.resume();
//             },
//           ),
//           FloatingActionButton(
//             child: Text("setSourceAsset"),
//             onPressed: () {
//               player.setSourceDeviceFile(
//                   "C:/Users/Snow/Desktop/opensource/flutter/kimia/kflutter/kplayer/kplayer/example/assets/Introducing_flutter.mp3");
//               player.resume();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
