import 'dart:convert';

// To parse this JSON data, do
//
//     final person = personFromJson(jsonString);
import 'package:dio/dio.dart';
import 'package:tidey/const.dart';

MarineWeather marineWeatherFromJson(String str) =>
    MarineWeather.fromJson(json.decode(str));

String marineWeatherToJson(MarineWeather data) => json.encode(data.toJson());

class MarineWeather {
  MarineWeather({
    this.data,
  });

  Data data;

  factory MarineWeather.fromJson(Map<String, dynamic> json) => MarineWeather(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.request,
    this.weather,
  });

  List<Request> request;
  List<Weather> weather;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        request:
            List<Request>.from(json["request"].map((x) => Request.fromJson(x))),
        weather:
            List<Weather>.from(json["weather"].map((x) => Weather.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "request": List<dynamic>.from(request.map((x) => x.toJson())),
        "weather": List<dynamic>.from(weather.map((x) => x.toJson())),
      };
}

class Request {
  Request({
    this.type,
    this.query,
  });

  String type;
  String query;

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        type: json["type"],
        query: json["query"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "query": query,
      };
}

class Weather {
  Weather({
    this.date,
    this.astronomy,
    this.maxtempC,
    this.maxtempF,
    this.mintempC,
    this.mintempF,
    this.tides,
    this.uvIndex,
    this.hourly,
  });

  DateTime date;
  List<Astronomy> astronomy;
  String maxtempC;
  String maxtempF;
  String mintempC;
  String mintempF;
  List<Tide> tides;
  String uvIndex;
  List<Hourly> hourly;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        date: DateTime.parse(json["date"]),
        astronomy: List<Astronomy>.from(
            json["astronomy"].map((x) => Astronomy.fromJson(x))),
        maxtempC: json["maxtempC"],
        maxtempF: json["maxtempF"],
        mintempC: json["mintempC"],
        mintempF: json["mintempF"],
        tides: List<Tide>.from(json["tides"].map((x) => Tide.fromJson(x))),
        uvIndex: json["uvIndex"],
        hourly:
            List<Hourly>.from(json["hourly"].map((x) => Hourly.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "astronomy": List<dynamic>.from(astronomy.map((x) => x.toJson())),
        "maxtempC": maxtempC,
        "maxtempF": maxtempF,
        "mintempC": mintempC,
        "mintempF": mintempF,
        "tides": List<dynamic>.from(tides.map((x) => x.toJson())),
        "uvIndex": uvIndex,
        "hourly": List<dynamic>.from(hourly.map((x) => x.toJson())),
      };
}

class Astronomy {
  Astronomy({
    this.sunrise,
    this.sunset,
    this.moonrise,
    this.moonset,
    this.moonPhase,
    this.moonIllumination,
  });

  String sunrise;
  String sunset;
  String moonrise;
  String moonset;
  String moonPhase;
  String moonIllumination;

  factory Astronomy.fromJson(Map<String, dynamic> json) => Astronomy(
        sunrise: json["sunrise"],
        sunset: json["sunset"],
        moonrise: json["moonrise"],
        moonset: json["moonset"],
        moonPhase: json["moon_phase"],
        moonIllumination: json["moon_illumination"],
      );

  Map<String, dynamic> toJson() => {
        "sunrise": sunrise,
        "sunset": sunset,
        "moonrise": moonrise,
        "moonset": moonset,
        "moon_phase": moonPhase,
        "moon_illumination": moonIllumination,
      };
}

class Hourly {
  Hourly({
    this.time,
    this.tempC,
    this.tempF,
    this.windspeedMiles,
    this.windspeedKmph,
    this.winddirDegree,
    this.winddir16Point,
    this.weatherCode,
    this.weatherIconUrl,
    this.weatherDesc,
    this.precipMm,
    this.precipInches,
    this.humidity,
    this.visibility,
    this.visibilityMiles,
    this.pressure,
    this.pressureInches,
    this.cloudcover,
    this.heatIndexC,
    this.heatIndexF,
    this.dewPointC,
    this.dewPointF,
    this.windChillC,
    this.windChillF,
    this.windGustMiles,
    this.windGustKmph,
    this.feelsLikeC,
    this.feelsLikeF,
    this.sigHeightM,
    this.swellHeightM,
    this.swellHeightFt,
    this.swellDir,
    this.swellDir16Point,
    this.swellPeriodSecs,
    this.waterTempC,
    this.waterTempF,
    this.uvIndex,
  });

  String time;
  String tempC;
  String tempF;
  String windspeedMiles;
  String windspeedKmph;
  String winddirDegree;
  String winddir16Point;
  String weatherCode;
  List<WeatherDescElement> weatherIconUrl;
  List<WeatherDescElement> weatherDesc;
  String precipMm;
  String precipInches;
  String humidity;
  String visibility;
  String visibilityMiles;
  String pressure;
  String pressureInches;
  String cloudcover;
  String heatIndexC;
  String heatIndexF;
  String dewPointC;
  String dewPointF;
  String windChillC;
  String windChillF;
  String windGustMiles;
  String windGustKmph;
  String feelsLikeC;
  String feelsLikeF;
  String sigHeightM;
  String swellHeightM;
  String swellHeightFt;
  String swellDir;
  SwellDir16Point swellDir16Point;
  String swellPeriodSecs;
  String waterTempC;
  String waterTempF;
  String uvIndex;

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
        time: json["time"],
        tempC: json["tempC"],
        tempF: json["tempF"],
        windspeedMiles: json["windspeedMiles"],
        windspeedKmph: json["windspeedKmph"],
        winddirDegree: json["winddirDegree"],
        winddir16Point: json["winddir16Point"],
        weatherCode: json["weatherCode"],
        weatherIconUrl: List<WeatherDescElement>.from(
            json["weatherIconUrl"].map((x) => WeatherDescElement.fromJson(x))),
        weatherDesc: List<WeatherDescElement>.from(
            json["weatherDesc"].map((x) => WeatherDescElement.fromJson(x))),
        precipMm: json["precipMM"],
        precipInches: json["precipInches"],
        humidity: json["humidity"],
        visibility: json["visibility"],
        visibilityMiles: json["visibilityMiles"],
        pressure: json["pressure"],
        pressureInches: json["pressureInches"],
        cloudcover: json["cloudcover"],
        heatIndexC: json["HeatIndexC"],
        heatIndexF: json["HeatIndexF"],
        dewPointC: json["DewPointC"],
        dewPointF: json["DewPointF"],
        windChillC: json["WindChillC"],
        windChillF: json["WindChillF"],
        windGustMiles: json["WindGustMiles"],
        windGustKmph: json["WindGustKmph"],
        feelsLikeC: json["FeelsLikeC"],
        feelsLikeF: json["FeelsLikeF"],
        sigHeightM: json["sigHeight_m"],
        swellHeightM: json["swellHeight_m"],
        swellHeightFt: json["swellHeight_ft"],
        swellDir: json["swellDir"],
        swellDir16Point: swellDir16PointValues.map[json["swellDir16Point"]],
        swellPeriodSecs: json["swellPeriod_secs"],
        waterTempC: json["waterTemp_C"],
        waterTempF: json["waterTemp_F"],
        uvIndex: json["uvIndex"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "tempC": tempC,
        "tempF": tempF,
        "windspeedMiles": windspeedMiles,
        "windspeedKmph": windspeedKmph,
        "winddirDegree": winddirDegree,
        "winddir16Point": winddir16Point,
        "weatherCode": weatherCode,
        "weatherIconUrl":
            List<dynamic>.from(weatherIconUrl.map((x) => x.toJson())),
        "weatherDesc": List<dynamic>.from(weatherDesc.map((x) => x.toJson())),
        "precipMM": precipMm,
        "precipInches": precipInches,
        "humidity": humidity,
        "visibility": visibility,
        "visibilityMiles": visibilityMiles,
        "pressure": pressure,
        "pressureInches": pressureInches,
        "cloudcover": cloudcover,
        "HeatIndexC": heatIndexC,
        "HeatIndexF": heatIndexF,
        "DewPointC": dewPointC,
        "DewPointF": dewPointF,
        "WindChillC": windChillC,
        "WindChillF": windChillF,
        "WindGustMiles": windGustMiles,
        "WindGustKmph": windGustKmph,
        "FeelsLikeC": feelsLikeC,
        "FeelsLikeF": feelsLikeF,
        "sigHeight_m": sigHeightM,
        "swellHeight_m": swellHeightM,
        "swellHeight_ft": swellHeightFt,
        "swellDir": swellDir,
        "swellDir16Point": swellDir16PointValues.reverse[swellDir16Point],
        "swellPeriod_secs": swellPeriodSecs,
        "waterTemp_C": waterTempC,
        "waterTemp_F": waterTempF,
        "uvIndex": uvIndex,
      };
}

enum SwellDir16Point {
  N,
  NNE,
  NE,
  ENE,
  E,
  ESE,
  SE,
  SSE,
  S,
  SSW,
  SW,
  WSW,
  W,
  WNW,
  NW,
  NNW,
}

final swellDir16PointValues = EnumValues({
  "N": SwellDir16Point.N,
  "NNE": SwellDir16Point.NNE,
  "NE": SwellDir16Point.NE,
  "ENE": SwellDir16Point.ENE,
  "E": SwellDir16Point.E,
  "ESE": SwellDir16Point.ESE,
  "SE": SwellDir16Point.SE,
  "SSE": SwellDir16Point.SSE,
  "S": SwellDir16Point.S,
  "SSW": SwellDir16Point.SSW,
  "SW": SwellDir16Point.SW,
  "WSW": SwellDir16Point.WSW,
  "W": SwellDir16Point.W,
  "WNW": SwellDir16Point.WNW,
  "NW": SwellDir16Point.NW,
  "NNW": SwellDir16Point.NNW
});

class WeatherDescElement {
  WeatherDescElement({
    this.value,
  });

  String value;

  factory WeatherDescElement.fromJson(Map<String, dynamic> json) =>
      WeatherDescElement(
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}

class Tide {
  Tide({
    this.tideData,
  });

  List<TideDatum> tideData;

  factory Tide.fromJson(Map<String, dynamic> json) => Tide(
        tideData: List<TideDatum>.from(
            json["tide_data"].map((x) => TideDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tide_data": List<dynamic>.from(tideData.map((x) => x.toJson())),
      };
}

class TideDatum {
  TideDatum({
    this.tideTime,
    this.tideHeightMt,
    this.tideDateTime,
    this.tideType,
  });

  String tideTime;
  String tideHeightMt;
  String tideDateTime;
  TideType tideType;

  factory TideDatum.fromJson(Map<String, dynamic> json) => TideDatum(
        tideTime: json["tideTime"],
        tideHeightMt: json["tideHeight_mt"],
        tideDateTime: json["tideDateTime"],
        tideType: tideTypeValues.map[json["tide_type"]],
      );

  Map<String, dynamic> toJson() => {
        "tideTime": tideTime,
        "tideHeight_mt": tideHeightMt,
        "tideDateTime": tideDateTime,
        "tide_type": tideTypeValues.reverse[tideType],
      };
}

enum TideType { LOW, HIGH }

final tideTypeValues = EnumValues({"HIGH": TideType.HIGH, "LOW": TideType.LOW});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

//  http://api.worldweatheronline.com/premium/v1/marine.ashx?key=51503debb4b34526a33181926211204&q=26.7747,-77.3296&format=json&tide=yes&tp=3
//const weatherServerURL

class WeatherService {
  // lat = '26.7747',-77.3296
  // Future<List<NearbyLocations>
  //
  getMarineData() async {
    print("Hello Weather");
    try {
      Response response =
          await Dio().get(weatherServerURL + 'marine.ashx', queryParameters: {
        'key': '51503debb4b34526a33181926211204',
        'q': '26.7747,-77.3296',
        'format': 'json',
        'tide': 'yes',
        'tp': '3'
      });

      // Map nearbyLocationsMap = response.data;
      print("Response found");
      print(response.data);

//      Map weatherMap = response.data;
//      print(weatherMap['data']['weather'][0]['date']);
//      var x = weatherMap['data']['weather'][0]['tides'][0]['tide_data'][0]
//      ['tideTime'];
      //   MarineWeather weatherData = MarineWeather();
      MarineWeather weatherData = MarineWeather.fromJson(response.data);
      // weatherData = MarineWeather.fromJson(weatherMap);

      print("Hello Map");

//   //   final locations = (response.data)
//          .cast<Map<String, dynamic>>()
//          .map((e) => Weather.fromJson(e));
      //  MarineWeather marineWeatherFromJson(String str) => MarineWeather.fromJson(json.decode(weatherMap));

      print("Map complete");
      print(weatherData.data.weather[0].tides[0].tideData[0].tideTime);
      for (var myTide in weatherData.data.weather[0].tides[0].tideData) {
        print("About to print");
        print(myTide.toJson());
      }

      return;
    } catch (e) {
      print("error found");
      print(e);
    }
  }
}
