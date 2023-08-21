## 0.4.2
- fix loop bug
- add helper methods
## 0.4.1
- fix bugs
- implement `kplayer_platform_interface: ^0.4.1`
- deprcated `kplayer_with_just_audio` and `kplayer_with_dart_vlc`
## 0.3.3
- fix loop bugs in `kplayer_with_just_audio`

## 0.3.1
- fix loop bug

## 0.2.4

- add `others` property to return all other players
  - example:
    - `player.others.forEach((player) => player.pause());`

## 0.2.3

- update README.md

## 0.2.2

fix order problem

## 0.2.1

fixed:

- PlayerBar dur bug
- Audioplayer bug see
add:
- rename PlayerMixin to PlayerMixinBase
- onLoopChanged to PlayerStateMixin
- animation for PlayerBar
- more options for Example
more:
- make kplayer_with_audioplayers package default for windows
- posiblety to use other package for player on runtime

## 0.1.18

add web preview

## 0.1.18

just UI

## 0.1.14

fix bugs:

- load from local file on windows
add new widgets:
- PlayerBar
- PlayerBuilder
- PlayerVolume
general improvements.
see the example.

## 0.1.9

update dependencies

remove ..init() from factories

## 0.0.1

- TODO: Describe initial release.
