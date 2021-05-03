import 'package:assets_audio_player/assets_audio_player.dart';

class AlarmSounder {
  init() {}
  void soundAlarm() {
    AssetsAudioPlayer.playAndForget(
        Audio('assets/audio/doubleScotlandfoghorn.mp3'));
  }
}
