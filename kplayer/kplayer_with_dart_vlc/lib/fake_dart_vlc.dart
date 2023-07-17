import "fake_io.dart" if (dart.library.io) 'dart:io';
//  Fake player

class Player {
  late Stream<GeneralState> generalStream;
  late Stream<PlaybackState> playbackStream;

  Stream<PositionState> positionStream = const Stream.empty();
  Player({required int id});

  void open(vlcMedia, {bool autoStart = false}) {}

  void play() {}

  void pause() {}

  void stop() {}

  void seek(Duration position) {}

  void dispose() {}

  void setRate(double speed) {}

  void setVolume(double volume) {}
}

class MediaSourceType {}

class MediaSource {}

class MediaType {}

/// A media object to open inside a [Player].
///
/// Pass `true` to [parse] for retrieving the metadata of the [Media].
/// [timeout] sets the time-limit for retriveing metadata.
/// [Media.metas] can be then, accessed to get the retrived metadata as `Map<String, String>`.
///
/// * A [Media] from a [File].
///
/// ```dart
/// Media media = Media.file(File('C:/music.ogg'));
/// ```
///
/// * A [Media] from a [Uri].
///
/// ```dart
/// Media media = Media.network('http://alexmercerind.github.io/music.mp3');
/// ```
///
/// For starting a [Media] at particular time, one can pass `startTime`.
///
/// ```dart
/// Media media = Media.file(
///   File('C:/music.ogg'),
///   startTime: Duration(milliseconds: 20),
/// );
/// ```
///
class Media implements MediaSource {
  MediaSourceType get mediaSourceType {
    throw UnimplementedError('The platform is not supported');
  }

  final MediaType mediaType;
  final String resource;
  final Duration startTime;
  final Duration stopTime;
  final Map<String, String> metas;

  // ignore: unused_element
  const Media._({
    required this.mediaType,
    required this.resource,
    required this.metas,
  })  : startTime = Duration.zero,
        stopTime = Duration.zero;

  /// Makes [Media] object from a [File].
  factory Media.file(
    File file, {
    bool parse = false,
    Map<String, dynamic>? extras,
    Duration timeout = const Duration(seconds: 10),
    startTime = Duration.zero,
    stopTime = Duration.zero,
  }) {
    throw UnimplementedError('The platform is not supported');
  }

  /// Makes [Media] object from url.
  factory Media.network(
    dynamic url, {
    bool parse = false,
    Map<String, dynamic>? extras,
    Duration timeout = const Duration(seconds: 10),
    startTime = Duration.zero,
    stopTime = Duration.zero,
  }) {
    throw UnimplementedError('The platform is not supported');
  }

  /// Makes [Media] object from direct show.
  factory Media.directShow({String? rawUrl, Map<String, dynamic>? args, String? vdev, String? adev, int? liveCaching}) {
    throw UnimplementedError('The platform is not supported');
  }

  /// Makes [Media] object from assets.
  ///
  /// **WARNING**
  ///
  /// This method only works for Flutter.
  /// Might result in an exception on Dart CLI.
  ///
  factory Media.asset(
    String asset, {
    startTime = Duration.zero,
  }) {
    throw UnimplementedError('The platform is not supported');
  }

  /// Parses the [Media] to retrieve [Media.metas].
  void parse(Duration timeout) {
    throw UnimplementedError('The platform is not supported');
  }
}

class PositionState {
  get position => null;
  get duration => null;

  bool get isCompleted => false;
}

/// State of a [Player] instance.
class CurrentState {
  /// Index of currently playing [Media].
  int? index;

  /// Currently playing [Media].
  Media? media;

  /// [List] of [Media] currently opened in the [Player] instance.
  List<Media> medias = <Media>[];

  /// Whether a [Playlist] is opened or a [Media].
  bool isPlaylist = false;
}

/// Playback state of a [Player] instance.
class PlaybackState {
  /// Whether [Player] instance is playing or not.
  bool isPlaying = false;

  /// Whether [Player] instance is seekable or not.
  bool isSeekable = true;

  /// Whether the current [Media] has ended playing or not.
  bool isCompleted = false;
}

/// Volume & Rate state of a [Player] instance.
class GeneralState {
  /// Volume of [Player] instance.
  double volume = 1.0;

  /// Rate of playback of [Player] instance.
  double rate = 1.0;
}

class DartVLC {
  static void initialize() {}
}
