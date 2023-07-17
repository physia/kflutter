import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dart_vlc/dart_vlc.dart';

void main() async {
  DartVLC.initialize(/*useFlutterNativeView: true*/);
  runApp(const DartVLCExample());
}

class DartVLCExample extends StatefulWidget {
  const DartVLCExample({super.key});

  @override
  DartVLCExampleState createState() => DartVLCExampleState();
}

class DartVLCExampleState extends State<DartVLCExample> {
  Player player = Player(
    id: 0,
    videoDimensions: const VideoDimensions(640, 360),
    // registerTexture: !Platform.isWindows,
  );
  MediaType mediaType = MediaType.file;
  CurrentState current = CurrentState();
  PositionState position = PositionState();
  PlaybackState playback = PlaybackState();
  GeneralState general = GeneralState();
  VideoDimensions videoDimensions = const VideoDimensions(0, 0);
  List<Media> medias = <Media>[];
  List<Device> devices = <Device>[];
  TextEditingController controller = TextEditingController();
  TextEditingController metasController = TextEditingController();
  double bufferingProgress = 0.0;
  Media? metasMedia;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      player.currentStream.listen((current) {
        setState(() => this.current = current);
      });
      player.positionStream.listen((position) {
        setState(() => this.position = position);
      });
      player.playbackStream.listen((playback) {
        setState(() => this.playback = playback);
      });
      player.generalStream.listen((general) {
        setState(() => this.general = general);
      });
      player.videoDimensionsStream.listen((videoDimensions) {
        setState(() => this.videoDimensions = videoDimensions);
      });
      player.bufferingProgressStream.listen(
        (bufferingProgress) {
          setState(() => this.bufferingProgress = bufferingProgress);
        },
      );
      player.errorStream.listen((event) {
        log('libvlc error.');
      });
      devices = Devices.all;
      Equalizer equalizer = Equalizer.createMode(EqualizerMode.live);
      equalizer.setPreAmp(10.0);
      equalizer.setBandAmp(31.25, 10.0);
      player.setEqualizer(equalizer);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet;
    bool isPhone;
    final double devicePixelRatio = View.of(context).devicePixelRatio;
    final double width = View.of(context).physicalSize.width;
    final double height = View.of(context).physicalSize.height;
    if (devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      isTablet = true;
      isPhone = false;
    } else if (devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      isTablet = true;
      isPhone = false;
    } else {
      isTablet = false;
      isPhone = true;
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('dart_vlc'),
          centerTitle: true,
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(4.0),
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Platform.isWindows
                //     ? NativeVideo(
                //         player: player,
                //         width: isPhone ? 320 : 640,
                //         height: isPhone ? 180 : 360,
                //         volumeThumbColor: Colors.blue,
                //         volumeActiveColor: Colors.blue,
                //         showControls: !isPhone,
                //       )
                //     :
                Video(
                  player: player,
                  width: isPhone ? 320 : 640,
                  height: isPhone ? 180 : 360,
                  volumeThumbColor: Colors.blue,
                  volumeActiveColor: Colors.blue,
                  showControls: !isPhone,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isPhone) _controls(context, isPhone),
                      Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.all(4.0),
                        child: Container(
                          margin: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                  const Text('Playlist creation.'),
                                  const Divider(
                                    height: 8.0,
                                    color: Colors.transparent,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: controller,
                                          cursorWidth: 1.0,
                                          autofocus: true,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                          ),
                                          decoration: const InputDecoration.collapsed(
                                            hintStyle: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                            hintText: 'Enter Media path.',
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 152.0,
                                        child: DropdownButton<MediaType>(
                                          value: mediaType,
                                          onChanged: (mediaType) => setState(() => this.mediaType = mediaType!),
                                          items: [
                                            DropdownMenuItem<MediaType>(
                                              value: MediaType.file,
                                              child: Text(
                                                MediaType.file.toString(),
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                            DropdownMenuItem<MediaType>(
                                              value: MediaType.network,
                                              child: Text(
                                                MediaType.network.toString(),
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                            DropdownMenuItem<MediaType>(
                                              value: MediaType.asset,
                                              child: Text(
                                                MediaType.asset.toString(),
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (mediaType == MediaType.file) {
                                              medias.add(
                                                Media.file(
                                                  File(
                                                    controller.text.replaceAll('"', ''),
                                                  ),
                                                ),
                                              );
                                            } else if (mediaType == MediaType.network) {
                                              medias.add(
                                                Media.network(
                                                  controller.text,
                                                ),
                                              );
                                            }
                                            setState(() {});
                                          },
                                          child: const Text(
                                            'Add to Playlist',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    height: 12.0,
                                  ),
                                  const Divider(
                                    height: 8.0,
                                    color: Colors.transparent,
                                  ),
                                  const Text('Playlist'),
                                ] +
                                medias
                                    .map(
                                      (media) => ListTile(
                                        title: Text(
                                          media.resource,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          media.mediaType.toString(),
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList() +
                                <Widget>[
                                  const Divider(
                                    height: 8.0,
                                    color: Colors.transparent,
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => setState(
                                          () {
                                            player.setPlaylistMode(PlaylistMode.single);
                                            player.open(
                                              Playlist(
                                                medias: medias,
                                              ),
                                            );
                                          },
                                        ),
                                        child: const Text(
                                          'Open into Player',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() => medias.clear());
                                        },
                                        child: const Text(
                                          'Clear the list',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.all(4.0),
                        child: Container(
                          margin: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Playback event listeners.'),
                              const Divider(
                                height: 12.0,
                                color: Colors.transparent,
                              ),
                              const Divider(
                                height: 12.0,
                              ),
                              const Text('Playback position.'),
                              const Divider(
                                height: 8.0,
                                color: Colors.transparent,
                              ),
                              Slider(
                                min: 0,
                                max: position.duration?.inMilliseconds.toDouble() ?? 1.0,
                                value: position.position?.inMilliseconds.toDouble() ?? 0.0,
                                onChanged: (double position) => player.seek(
                                  Duration(
                                    milliseconds: position.toInt(),
                                  ),
                                ),
                              ),
                              const Text('Event streams.'),
                              const Divider(
                                height: 8.0,
                                color: Colors.transparent,
                              ),
                              Table(
                                children: [
                                  TableRow(
                                    children: [const Text('player.general.volume'), Text('${general.volume}')],
                                  ),
                                  TableRow(
                                    children: [const Text('player.general.rate'), Text('${general.rate}')],
                                  ),
                                  TableRow(
                                    children: [const Text('player.position.position'), Text('${position.position}')],
                                  ),
                                  TableRow(
                                    children: [const Text('player.position.duration'), Text('${position.duration}')],
                                  ),
                                  TableRow(
                                    children: [const Text('player.playback.isCompleted'), Text('${playback.isCompleted}')],
                                  ),
                                  TableRow(
                                    children: [const Text('player.playback.isPlaying'), Text('${playback.isPlaying}')],
                                  ),
                                  TableRow(
                                    children: [const Text('player.playback.isSeekable'), Text('${playback.isSeekable}')],
                                  ),
                                  TableRow(
                                    children: [const Text('player.current.index'), Text('${current.index}')],
                                  ),
                                  TableRow(
                                    children: [const Text('player.current.media'), Text('${current.media}')],
                                  ),
                                  TableRow(
                                    children: [const Text('player.current.medias'), Text('${current.medias}')],
                                  ),
                                  TableRow(
                                    children: [const Text('player.videoDimensions'), Text('$videoDimensions')],
                                  ),
                                  TableRow(
                                    children: [const Text('player.bufferingProgress'), Text('$bufferingProgress')],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.all(4.0),
                        child: Container(
                          margin: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                                  Text('Playback devices.'),
                                  Divider(
                                    height: 12.0,
                                    color: Colors.transparent,
                                  ),
                                  Divider(
                                    height: 12.0,
                                  ),
                                ] +
                                devices
                                    .map(
                                      (device) => ListTile(
                                        title: Text(
                                          device.name,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          device.id,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        onTap: () => player.setDevice(device),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.all(4.0),
                        child: Container(
                          margin: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Metas parsing.'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: metasController,
                                      cursorWidth: 1.0,
                                      autofocus: true,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                      ),
                                      decoration: const InputDecoration.collapsed(
                                        hintStyle: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                        hintText: 'Enter Media path.',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 152.0,
                                    child: DropdownButton<MediaType>(
                                      value: mediaType,
                                      onChanged: (mediaType) => setState(() => this.mediaType = mediaType!),
                                      items: [
                                        DropdownMenuItem<MediaType>(
                                          value: MediaType.file,
                                          child: Text(
                                            MediaType.file.toString(),
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                        DropdownMenuItem<MediaType>(
                                          value: MediaType.network,
                                          child: Text(
                                            MediaType.network.toString(),
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                        DropdownMenuItem<MediaType>(
                                          value: MediaType.asset,
                                          child: Text(
                                            MediaType.asset.toString(),
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (mediaType == MediaType.file) {
                                          metasMedia = Media.file(
                                            File(metasController.text),
                                            parse: true,
                                          );
                                        } else if (mediaType == MediaType.network) {
                                          metasMedia = Media.network(
                                            metasController.text,
                                            parse: true,
                                          );
                                        }
                                        setState(() {});
                                      },
                                      child: const Text(
                                        'Parse',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 12.0,
                              ),
                              const Divider(
                                height: 8.0,
                                color: Colors.transparent,
                              ),
                              Text(
                                const JsonEncoder.withIndent('    ').convert(metasMedia?.metas),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isPhone) _playlist(context),
                    ],
                  ),
                ),
                if (isTablet)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _controls(context, isPhone),
                        _playlist(context),
                      ],
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _controls(BuildContext context, bool isPhone) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(4.0),
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Playback controls.'),
            const Divider(
              height: 8.0,
              color: Colors.transparent,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => player.play(),
                  child: const Text(
                    'play',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () => player.pause(),
                  child: const Text(
                    'pause',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () => player.playOrPause(),
                  child: const Text(
                    'playOrPause',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => player.stop(),
                  child: const Text(
                    'stop',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () => player.next(),
                  child: const Text(
                    'next',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () => player.previous(),
                  child: const Text(
                    'previous',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              height: 12.0,
              color: Colors.transparent,
            ),
            const Divider(
              height: 12.0,
            ),
            const Text('Volume control.'),
            const Divider(
              height: 8.0,
              color: Colors.transparent,
            ),
            Slider(
              min: 0.0,
              max: 1.0,
              value: player.general.volume,
              onChanged: (volume) {
                player.setVolume(volume);
                setState(() {});
              },
            ),
            const Text('Playback rate control.'),
            const Divider(
              height: 8.0,
              color: Colors.transparent,
            ),
            Slider(
              min: 0.5,
              max: 1.5,
              value: player.general.rate,
              onChanged: (rate) {
                player.setRate(rate);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _playlist(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16.0, top: 16.0),
            alignment: Alignment.topLeft,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Playlist manipulation.'),
                Divider(
                  height: 12.0,
                  color: Colors.transparent,
                ),
                Divider(
                  height: 12.0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 456.0,
            child: ReorderableListView(
              shrinkWrap: true,
              onReorder: (int initialIndex, int finalIndex) async {
                /// 🙏🙏🙏
                /// In the name of God,
                /// With all due respect,
                /// I ask all Flutter engineers to please fix this issue.
                /// Peace.
                /// 🙏🙏🙏
                ///
                /// Issue:
                /// https://github.com/flutter/flutter/issues/24786
                /// Prevention:
                /// https://stackoverflow.com/a/54164333/12825435
                ///
                if (finalIndex > current.medias.length) finalIndex = current.medias.length;
                if (initialIndex < finalIndex) finalIndex--;

                player.move(initialIndex, finalIndex);
                setState(() {});
              },
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: List.generate(
                current.medias.length,
                (int index) => ListTile(
                  key: Key(index.toString()),
                  leading: Text(
                    index.toString(),
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  title: Text(
                    current.medias[index].resource,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  subtitle: Text(
                    current.medias[index].mediaType.toString(),
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
                growable: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
