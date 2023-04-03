import 'package:flutter/foundation.dart';

import 'persistence/settings_persistence.dart';

/// An class that holds settings like [playerName] or [musicOn],
/// and saves them to an injected persistence store.
class SettingsController {
  final SettingsPersistence _persistence;

  /// Whether or not the sound is on at all. This overrides both music
  /// and sound.
  ValueNotifier<bool> muted = ValueNotifier(false);

  ValueNotifier<String> playerName1 = ValueNotifier('Player1');
  ValueNotifier<String> playerName2 = ValueNotifier('Player2');

  ValueNotifier<bool> soundsOn = ValueNotifier(false);

  ValueNotifier<bool> musicOn = ValueNotifier(false);

  /// Creates a new instance of [SettingsController] backed by [persistence].
  SettingsController({required SettingsPersistence persistence})
      : _persistence = persistence;

  /// Asynchronously loads values from the injected persistence store.
  Future<void> loadStateFromPersistence() async {
    await Future.wait([
      _persistence
          // On the web, sound can only start after user interaction, so
          // we start muted there.
          // On any other platform, we start unmuted.
          .getMuted(defaultValue: kIsWeb)
          .then((value) => muted.value = value),
      _persistence.getSoundsOn().then((value) => soundsOn.value = value),
      _persistence.getMusicOn().then((value) => musicOn.value = value),
      _persistence.getPlayerName1().then((value) => playerName1.value = value),
      _persistence.getPlayerName2().then((value) => playerName2.value = value),
    ]);
  }

  void setPlayerName1(String name) {
    playerName1.value = name;
    _persistence.savePlayerName1(playerName1.value);
  }

  void setPlayerName2(String name) {
    playerName2.value = name;
    _persistence.savePlayerName2(playerName2.value);
  }

  void toggleMusicOn() {
    musicOn.value = !musicOn.value;
    _persistence.saveMusicOn(musicOn.value);
  }

  void toggleMuted() {
    muted.value = !muted.value;
    _persistence.saveMuted(muted.value);
  }

  void toggleSoundsOn() {
    soundsOn.value = !soundsOn.value;
    _persistence.saveSoundsOn(soundsOn.value);
  }
}
