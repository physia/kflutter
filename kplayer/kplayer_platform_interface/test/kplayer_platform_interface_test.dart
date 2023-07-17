import 'package:flutter_test/flutter_test.dart';

import 'package:kplayer_platform_interface/kplayer_platform_interface.dart';

void main() {
  test('check media types', () {
    const resource = "assets/file.mp3";
    final asset = PlayerMedia.asset(resource);
    final network = PlayerMedia.network(resource);
    final file = PlayerMedia.file(resource);
    expect(asset.type, PlayerMediaType.asset);
    expect(network.type, PlayerMediaType.network);
    expect(file.type, PlayerMediaType.file);
    // src
    expect(asset.resource, resource);
    expect(network.resource, resource);
    expect(file.resource, resource);

  });
  test('check enums length', () {
    expect(PlayerMediaType.values.length, 3);
    expect(PlayerStatus.values.length, 7);
    expect(PlayerEvent.values.length, 9);

    
  });
}

