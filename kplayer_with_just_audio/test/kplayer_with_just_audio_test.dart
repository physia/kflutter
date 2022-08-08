import 'package:flutter_test/flutter_test.dart';

import 'package:kplayer_with_just_audio/kplayer_with_just_audio.dart';

void main() {
  test('check players length', () {
    expect(Player.players.length, 0);
    expect(Player.players.length, 1);
  });
}
