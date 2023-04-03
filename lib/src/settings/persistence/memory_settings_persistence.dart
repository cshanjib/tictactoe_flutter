

import 'settings_persistence.dart';

/// An in-memory implementation of [SettingsPersistence].
/// Useful for testing.
class MemoryOnlySettingsPersistence implements SettingsPersistence {
  bool musicOn = true;

  bool soundsOn = true;

  bool muted = false;

  String playerName1 = 'Player1';
  String playerName2 = 'Player2';

  @override
  Future<bool> getMusicOn() async => musicOn;

  @override
  Future<bool> getMuted({required bool defaultValue}) async => muted;

  @override
  Future<String> getPlayerName1() async => playerName1;

  @override
  Future<String> getPlayerName2() async => playerName2;

  @override
  Future<bool> getSoundsOn() async => soundsOn;

  @override
  Future<void> saveMusicOn(bool value) async => musicOn = value;

  @override
  Future<void> saveMuted(bool value) async => muted = value;

  @override
  Future<void> savePlayerName1(String value) async => playerName1 = value;

  @override
  Future<void> savePlayerName2(String value) async => playerName2 = value;

  @override
  Future<void> saveSoundsOn(bool value) async => soundsOn = value;
}
