import 'dart:convert';

// To parse this JSON data, do
//
//     final person = personFromJson(jsonString);
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidey/const.dart';

class WeatherLocation {
  WeatherLocation({
    this.data,
  });

  Data data;

  factory WeatherLocation.fromRawJson(String str) =>
      WeatherLocation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeatherLocation.fromJson(Map<String, dynamic> json) =>
      WeatherLocation(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.request,
    this.nearestArea,
    this.timeZone,
  });

  List<Request> request;
  List<NearestArea> nearestArea;
  List<TimeZone> timeZone;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        request:
            List<Request>.from(json["request"].map((x) => Request.fromJson(x))),
        nearestArea: List<NearestArea>.from(
            json["nearest_area"].map((x) => NearestArea.fromJson(x))),
        timeZone: List<TimeZone>.from(
            json["time_zone"].map((x) => TimeZone.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "request": List<dynamic>.from(request.map((x) => x.toJson())),
        "nearest_area": List<dynamic>.from(nearestArea.map((x) => x.toJson())),
        "time_zone": List<dynamic>.from(timeZone.map((x) => x.toJson())),
      };
}

class NearestArea {
  NearestArea({
    this.areaName,
    this.country,
    this.region,
    this.latitude,
    this.longitude,
//    this.population,
//    this.weatherUrl,
  });

  List<AreaName> areaName;
  List<AreaName> country;
  List<AreaName> region;
  String latitude;
  String longitude;
//  String population;
//  List<AreaName> weatherUrl;

  factory NearestArea.fromRawJson(String str) =>
      NearestArea.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NearestArea.fromJson(Map<String, dynamic> json) => NearestArea(
        areaName: List<AreaName>.from(
            json["areaName"].map((x) => AreaName.fromJson(x))),
        country: List<AreaName>.from(
            json["country"].map((x) => AreaName.fromJson(x))),
        region: List<AreaName>.from(
            json["region"].map((x) => AreaName.fromJson(x))),
        latitude: json["latitude"],
        longitude: json["longitude"],
//        population: json["population"],
//        weatherUrl: List<AreaName>.from(
//            json["weatherUrl"].map((x) => AreaName.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "areaName": List<dynamic>.from(areaName.map((x) => x.toJson())),
        "country": List<dynamic>.from(country.map((x) => x.toJson())),
        "region": List<dynamic>.from(region.map((x) => x.toJson())),
        "latitude": latitude,
        "longitude": longitude,
//        "population": population,
//        "weatherUrl": List<dynamic>.from(weatherUrl.map((x) => x.toJson())),
      };
}

class AreaName {
  AreaName({
    this.value,
  });

  String value;

  factory AreaName.fromRawJson(String str) =>
      AreaName.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AreaName.fromJson(Map<String, dynamic> json) => AreaName(
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}

class Request {
  Request({
    this.type,
    this.query,
  });

  String type;
  String query;

  factory Request.fromRawJson(String str) => Request.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        type: json["type"],
        query: json["query"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "query": query,
      };
}

class TimeZone {
  TimeZone({
    this.localtime,
    this.utcOffset,
    this.zone,
  });

  String localtime;
  String utcOffset;
  String zone;

  factory TimeZone.fromRawJson(String str) =>
      TimeZone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TimeZone.fromJson(Map<String, dynamic> json) => TimeZone(
        localtime: json["localtime"],
        utcOffset: json["utcOffset"],
        zone: json["zone"],
      );

  Map<String, dynamic> toJson() => {
        "localtime": localtime,
        "utcOffset": utcOffset,
        "zone": zone,
      };
}

class WeatherLocationService {
  String latLong = '26.7747,-77.3296';
  SharedPreferences prefs;

  getWeatherLocation() async {
    prefs = await SharedPreferences.getInstance();
    String q = userSettings.useCity ? userSettings.cityString : latLong;
    print("Location q is $q");
    try {
      Response response =
          await Dio().get(weatherServerURL + 'tz.ashx', queryParameters: {
        'key': '51503debb4b34526a33181926211204',
        'q': q,
        'format': 'json',
        'includeLocation': 'yes'
      });

      // Map nearbyLocationsMap = response.data;
      print("Response found");
      print(response.data);

      weatherLocation = WeatherLocation.fromJson(response.data);
      // weatherData = MarineWeather.fromJson(weatherMap);

      print("Map complete");
      globalLatitude = weatherLocation.data.nearestArea[0].latitude;
      globalLongitude = weatherLocation.data.nearestArea[0].longitude;
      print("Double convert start");
      userSettings.manualLat =
          double.parse(weatherLocation.data.nearestArea[0].latitude);
      userSettings.manualLong =
          double.parse(weatherLocation.data.nearestArea[0].longitude);
      print("Double Convert End");
      prefs.setDouble(userSettings.keyManualLat, userSettings.manualLat);
      prefs.setDouble(userSettings.keyManualLong, userSettings.manualLong);
      print("DDDouble Convert End");
      return;
    } catch (e) {
      globalLongitude = "0";
      globalLatitude = "0";
      print("error found");

      print(e);
    }
  }
}
