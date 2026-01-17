import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class UiSoundPlayer {
  UiSoundPlayer._(); // private constructor

  static Future<void> playAsset(String assetPath, {double volume = 1.0}) async {
    try {
      final player = AudioPlayer();

      await player.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            usageType: AndroidUsageType.assistanceSonification,
            contentType: AndroidContentType.sonification,
            audioFocus: AndroidAudioFocus.none,
          ),
        ),
      );

      await player.play(AssetSource(assetPath), volume: volume);

      player.onPlayerComplete.listen((_) {
        player.dispose();
      });
    } catch (e) {
      debugPrint('UiSoundPlayer error: $e');
    }
  }
}
