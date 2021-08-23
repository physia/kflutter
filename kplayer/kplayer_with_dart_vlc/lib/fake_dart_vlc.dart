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

class Media {
  static asset(String resource) {}

  static network(String resource) {}
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
