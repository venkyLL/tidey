import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:tidey/const.dart';

class HourlyBellRinger {
  DateTime bellLastRungDateTime;
  int myHour;
  int myMinutes;

  init() {
    bellLastRungDateTime = DateTime.now();
  }

  double _timeOfDayToDouble(TimeOfDay tod) => tod.hour + tod.minute / 60.0;

  bool amISleeping() {
    bool _iAmSleeping = false;
    double _now = _timeOfDayToDouble(TimeOfDay.now());
    double _wakeTime =
        _timeOfDayToDouble(userSettings.wakeTime); // _startTime is a TimeOfDay
    double _sleepTime =
        _timeOfDayToDouble(userSettings.sleepTime); // _stopTime is a TimeOfDay
    if (_sleepTime < _wakeTime) {
      // we are in the same day
      if ((_now >= _sleepTime) && (_now <= _wakeTime)) _iAmSleeping = true;
    } else {
      // we are crossing the midnight boundary
      if ((_now >= _sleepTime) || (_now <= _wakeTime)) _iAmSleeping = true;
    }

    return _iAmSleeping;
  }

  void ringTheBellIfItIsTime() {
    if (amISleeping()) {
//      print(
//          "not ringing the bell because I am sleeping at ${DateTime.now()}, ${userSettings.wakeTime}, ${userSettings.sleepTime}");
      return;
    }
    if ((userSettings.chimeSelected == ChimeType.hourly) ||
        (userSettings.chimeSelected == ChimeType.single)) {
      if (DateTime.now().getMinutes == 0) {
        if (bellLastRungDateTime.addMinutes(1).isPast) {
          bellLastRungDateTime = DateTime.now();
          myHour = DateTime.now().getHours;
          if (myHour > 12) myHour = myHour - 12;
          if (myHour == 0) myHour = 12;
          ringMyBell(myHour);
        } //has the bell already rung for this hour
      } // are we at the top of the hour
    } // global chime hourly

    if (userSettings.chimeSelected == ChimeType.nautical) {
      myHour = DateTime.now().getHours;
      myMinutes = DateTime.now().getMinutes;
      if ((myMinutes == 0) || (myMinutes == 30)) {
        if (bellLastRungDateTime.addMinutes(1).isPast) {
          bellLastRungDateTime = DateTime.now();
          if (myHour > 12) myHour = myHour - 12;
          if (myHour == 0) myHour = 12;
          myMinutes = DateTime.now().getMinutes;
          ringMyNauticalBell(myHour, myMinutes);
        } //has the bell already rung for this hour
      } // are we at the top of the hour
    } // global chime hourly
  }

  void ringMyBell(myHour) {
    switch (userSettings.chimeSelected) {
      case ChimeType.hourly:
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
      case ChimeType.single:
        AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell1.mp3'));
        break;
      case ChimeType.nautical:
        AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell1.mp3'));
        break;
      default:
        AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell1.mp3'));
        break;
    }
  }

  void ringMyNauticalBell(myHour, myMinutes) {
    switch (userSettings.chimeSelected) {
      case ChimeType.nautical:
        switch (myHour) {
          case 1:
            if (myMinutes == 0)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell2.mp3'));
            if (myMinutes == 30)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell3.mp3'));
            break;
          case 2:
            if (myMinutes == 0)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell4.mp3'));
            if (myMinutes == 30)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell5.mp3'));
            break;
          case 3:
            if (myMinutes == 0)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell6.mp3'));
            if (myMinutes == 30)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell7.mp3'));
            break;
          case 4:
            if (myMinutes == 0)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell8.mp3'));
            if (myMinutes == 30)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell1.mp3'));
            break;
          case 5:
            if (myMinutes == 0)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell2.mp3'));
            if (myMinutes == 30)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell3.mp3'));
            break;
          case 6:
            if (myMinutes == 0)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell4.mp3'));
            if (myMinutes == 30)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell5.mp3'));
            break;
          case 7:
            if (myMinutes == 0)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell6.mp3'));
            if (myMinutes == 30)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell7.mp3'));
            break;
          case 8:
            if (myMinutes == 0)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell8.mp3'));
            if (myMinutes == 30)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell1.mp3'));
            break;
          case 9:
            if (myMinutes == 0)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell2.mp3'));
            if (myMinutes == 30)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell3.mp3'));
            break;
          case 10:
            if (myMinutes == 0)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell4.mp3'));
            if (myMinutes == 30)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell5.mp3'));
            break;
          case 11:
            if (myMinutes == 0)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell6.mp3'));
            if (myMinutes == 30)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell7.mp3'));
            break;
          case 12:
            if (myMinutes == 0)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell8.mp3'));
            if (myMinutes == 30)
              AssetsAudioPlayer.playAndForget(
                  Audio('assets/audio/navBell1.mp3'));
            break;
          default:
            AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell1.mp3'));
            break;
        } // switch my hour
        break;
      default:
        AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell1.mp3'));
        break;
    }
  }
}
