// TODO Implement this library..


class Player  {
    late Stream<GeneralState> generalStream;
    late Stream<GeneralState> playbackStream;

   Stream<PositionState> positionStream = const Stream.empty();
  Player({required int id});

  void open(vlcMedia, { bool autoStart =false}) {}

  void play() {}

  void pause() {}

  void stop() {}

  void seek(Duration position) {}

  void dispose() {}

  void setRate(double speed) {}

  void setVolume(double volume) {}
}
class Media  {
  static asset(String resource) {}

  static network(String resource) {}
  
}
class PositionState {
  get position => null;
  get duration => null;

  bool get isCompleted => false;
}
class GeneralState {
  double get rate => 0.0;
  double get volume => 0.0;

  bool get isCompleted => false;
}

class DartVLC {
  static void initialize() {}
  
}