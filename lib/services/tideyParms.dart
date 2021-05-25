import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tidey/const.dart';

class TideyParmModel {
  TideyParmModel({
    this.currentRelease,
    this.retiredRelease,
    this.apiKey,
  });

  String currentRelease;
  String retiredRelease;
  String apiKey;

  factory TideyParmModel.fromRawJson(String str) =>
      TideyParmModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TideyParmModel.fromJson(Map<String, dynamic> json) => TideyParmModel(
        currentRelease: json["currentRelease"],
        retiredRelease: json["retiredRelease"],
        apiKey: json["apiKey"],
      );

  Map<String, dynamic> toJson() => {
        "currentRelease": currentRelease,
        "retiredRelease": retiredRelease,
        "apiKey": apiKey,
      };
}

class TideyParmsService {
  static String funcName = 'TideyParms ';
  TideyParmModel tideyParmData = TideyParmModel();

  Future<bool> getTideyParmData() async {
    try {
      Response response = await dio.get(tideyParmsURL, queryParameters: {
        'deviceID': '1234' // userSettings.deviceID,
      });

      // Map nearbyLocationsMap = response.data;
      print("$funcName response found");
      print(response.data);

      tideyParmData = TideyParmModel.fromJson(response.data);

      print("$funcName Map complete");

      return (true);
    } catch (e) {
      print("$funcName Error found");
      print(e);
      return (false);
    }
  }

  bool get needsUpdate {
    final List<int> currentVersion = packageInfo.version
        .split('.')
        .map((String number) => int.parse(number))
        .toList();
    final List<int> enforcedVersion = tideyParmData.retiredRelease
        .split('.')
        .map((String number) => int.parse(number))
        .toList();
    for (int i = 0; i < 3; i++) {
      if (enforcedVersion[i] > currentVersion[i]) return true;
    }
    return false;
  }

  bool get updateAvailable {
    final List<int> currentVersion = packageInfo.version
        .split('.')
        .map((String number) => int.parse(number))
        .toList();
    final List<int> enforcedVersion = tideyParmData.currentRelease
        .split('.')
        .map((String number) => int.parse(number))
        .toList();
    for (int i = 0; i < 3; i++) {
      if (enforcedVersion[i] > currentVersion[i]) return true;
    }
    return false;
  }
}
