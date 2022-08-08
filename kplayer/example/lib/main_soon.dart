// import 'dart:async';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:kplayer/kplayer.dart';
// import 'package:kplayer_with_audioplayers/kplayer_with_audioplayers.dart';

// // StreamController for isDarkMode
// final isDarkMode = ValueNotifier(true);
// void main() {
//   Player.boot();
//   runApp(
//     ValueListenableBuilder(
//       valueListenable: isDarkMode,
//       builder: (context, snapshot, w) {
//         return MaterialApp(
//           themeMode: isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
//           theme: ThemeData(
//             brightness: isDarkMode.value ? Brightness.dark : Brightness.light,
//           ),
//           darkTheme: ThemeData.dark(),
//           home: const MyApp(),
//         );
//       },
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   var player = Player(
//       media: PlayerMedia.network(
//           "https://archive.org/download/s0v5kiwcwp1zaps7pdwjtp5o8e6clmevdnewngnd/JSJ_385_Panel.mp3"),
//       autoPlay: true)
//     ..init();
//   final _loadFromNetworkController = TextEditingController(
//       text:
//           "https://archive.org/download/s0v5kiwcwp1zaps7pdwjtp5o8e6clmevdnewngnd/JSJ_385_Panel.mp3");
//   final _loadFromAssetController =
//       TextEditingController(text: "assets/Introducing_flutter.mp3");
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   dispose() {
//     super.dispose();
//     player.dispose();
//   }

//   bool loading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('KPlayer'),
//       ),
//       body: ListView(
//         children: [
//           const SizedBox(height: 20),
//           ListTile(
//             leading: const Icon(Icons.language),
//             title: const Text("Load from network"),
//             subtitle: TextField(
//               controller: _loadFromNetworkController,
//               decoration:
//                   const InputDecoration(hintText: "URL of the media to load"),
//             ),
//             trailing: IconButton(
//               icon: const Icon(Icons.play_arrow),
//               onPressed: () {
//                 setState(() {
//                   player.dispose();
//                   player = Player(
//                     media: PlayerMedia.network(
//                         "https://archive.org/download/s0v5kiwcwp1zaps7pdwjtp5o8e6clmevdnewngnd/JSJ_385_Panel.mp3"),
//                     autoPlay: true,
//                   )..init();
//                 });
//               },
//             ),
//           ),
//           const Divider(),
//           // load from Assets
//           ListTile(
//             leading: const Icon(Icons.audiotrack),
//             title: const Text("Load from assets"),
//             subtitle: TextField(
//               controller: _loadFromAssetController,
//               decoration: const InputDecoration(hintText: "assets path"),
//             ),
//             trailing: IconButton(
//               icon: const Icon(Icons.play_arrow),
//               onPressed: () {
//                 setState(() {
//                   player.dispose();
//                   player = Player(
//                     media: PlayerMedia.asset(_loadFromAssetController.text),
//                     autoPlay: true,
//                   )..init();
//                 });
//               },
//             ),
//           ),
//           const Divider(),
//           // use file picker to load from file
//           ListTile(
//             leading: const Icon(Icons.folder),
//             title: const Text("Load from file"),
//             trailing: IconButton(
//               icon: const Icon(Icons.play_arrow),
//               onPressed: () async {
//                 FilePickerResult? result =
//                     await FilePicker.platform.pickFiles();

//                 if (result != null) {
//                   setState(() {
//                     player.dispose();
//                     player = Player(
//                         media: PlayerMedia.file(result.files.single.path!))
//                       ..init();
//                   });
//                 }
//               },
//             ),
//           ),
//           const Divider(),
//           // widget for log
//           StreamBuilder<PlayerStatus>(
//               stream: player.streams.status,
//               builder: (context, snapshot) {
//                 return Column(
//                   children: [
//                     const Text(
//                       "Logs",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     Text("Duration: " + player.duration.toString()),
//                     Text("Position: " + player.position.toString()),
//                     Text("Volume: " + player.volume.toString()),
//                     Text("Speed: " + player.speed.toString()),
//                     Text("Loop: " + player.loop.toString()),
//                     Text("Status: " + player.status.toString()),
//                     Text("Media type: " + player.media.type.toString()),
//                     Text("Media resource: " + player.media.resource.toString()),
//                   ],
//                 );
//               }),
//         ],
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: SizedBox(
//           height: 60,
//           child: PlayerBar(player: player, options: [
//             // listTileSw for dark mode
//             ValueListenableBuilder(
//               valueListenable: isDarkMode,
//               builder: (context, snapshot, w) {
//                 return SwitchListTile(
//                   secondary: const Icon(Icons.brightness_2),
//                   title: const Text("Dark mode"),
//                   value: isDarkMode.value,
//                   onChanged: (bool value) {
//                     isDarkMode.value = !isDarkMode.value;
//                   },
//                 );
//               },
//             ),
//           ]),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           MethodChannel channel = const MethodChannel('kplayer_channel');
//           var result = await channel.invokeMethod(
//               'GetSystemVolume', 'Hello from flutter');
//           print("result.toString()");
//           print(result);
//         },
//         child: const Icon(Icons.replay),
//       ),
//     );
//   }
// }
