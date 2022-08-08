import 'package:flutter_test/flutter_test.dart';

import 'package:kplayer_platform_interface/kplayer_platform_interface.dart';

void main() {
  test('check media types', () {
    const _resource = "assets/file.mp3";
    final _asset = PlayerMedia.asset(_resource);
    final _network = PlayerMedia.network(_resource);
    final _file = PlayerMedia.file(_resource);
    expect(_asset.type, PlayerMediaType.asset);
    expect(_network.type, PlayerMediaType.network);
    expect(_file.type, PlayerMediaType.file);
    // src
    expect(_asset.resource, _resource);
    expect(_network.resource, _resource);
    expect(_file.resource, _resource);

  });
  test('check enums length', () {
    expect(PlayerMediaType.values.length, 3);
    expect(PlayerStatus.values.length, 7);
    expect(PlayerEvent.values.length, 9);

    
  });
}

