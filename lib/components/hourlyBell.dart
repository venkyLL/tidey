import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dart_date/dart_date.dart';
import 'package:tidey/const.dart';

class HourlyBellRinger {
  DateTime bellLastRungDateTime;
  int myHour;
  // int test_bell_has_rung_counter = 12;

  init() {
    bellLastRungDateTime = DateTime.now();
  }

  void ringTheBellIfItIsTime() {
//    int test = DateTime.now().getMinutes;
//    print("arrived in ringTheBellIfItIsTime $test");
    if (DateTime.now().getMinutes == 0) {
      if (bellLastRungDateTime.addMinutes(1).isPast) {
        bellLastRungDateTime = DateTime.now();
        myHour = DateTime.now().getHours;
        if (myHour > 12) myHour = myHour - 12;
        if (myHour == 0) myHour = 12;
        ringMyBell(myHour);
      }
    } else {
//      print("not ringing the bell @ ${DateTime.now()}");
      //   test_bell_has_rung_counter++;
      //   if (test_bell_has_rung_counter < 10)
      //     AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell1.mp3'));
    }
  }

  void ringMyBell(myHour) {
    switch (globalChimeType) {
      case globalChime.hourly:
        switch (myHour) {
          case 1:
            AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell1.mp3'));
            break;
          case 2:
            AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell2.mp3'));
            break;
          case 3:
            AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell3.mp3'));
            break;
          case 4:
            AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell4.mp3'));
            break;
          case 5:
            AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell5.mp3'));
            break;
          case 6:
            AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell6.mp3'));
            break;
          case 7:
            AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell7.mp3'));
            break;
          case 8:
            AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell8.mp3'));
            break;
          case 9:
            AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell9.mp3'));
            break;
          case 10:
            AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell10.mp3'));
            break;
          case 11:
            AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell11.mp3'));
            break;
          case 12:
            AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell12.mp3'));
            break;
          default:
            AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell1.mp3'));
            break;
        } // switch my hour
        break;
      case globalChime.single:
        AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell1.mp3'));
        break;
      case globalChime.nautical:
        AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell1.mp3'));
        break;
      default:
        AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell1.mp3'));
        break;
    }
  }
}
