// To parse this JSON data, do
//
//     final localWeather = localWeatherFromJson(jsonString);

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:tidey/const.dart';

class LocalWeather {
  LocalWeather({
    this.data,
  });

  Data data;

  factory LocalWeather.fromRawJson(String str) =>
      LocalWeather.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocalWeather.fromJson(Map<String, dynamic> json) => LocalWeather(
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
    this.currentCondition,
    this.weather,
    this.climateAverages,
    this.alerts,
  });

  List<Request> request;
  List<NearestArea> nearestArea;
  List<CurrentCondition> currentCondition;
  List<Weather> weather;
  List<ClimateAverage> climateAverages;
  Alerts alerts;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        request:
            List<Request>.from(json["request"].map((x) => Request.fromJson(x))),
        nearestArea: List<NearestArea>.from(
            json["nearest_area"].map((x) => NearestArea.fromJson(x))),
        currentCondition: List<CurrentCondition>.from(
            json["current_condition"].map((x) => CurrentCondition.fromJson(x))),
        weather:
            List<Weather>.from(json["weather"].map((x) => Weather.fromJson(x))),
        climateAverages: List<ClimateAverage>.from(
            json["ClimateAverages"].map((x) => ClimateAverage.fromJson(x))),
        alerts: Alerts.fromJson(json["alerts"]),
      );

  Map<String, dynamic> toJson() => {
        "request": List<dynamic>.from(request.map((x) => x.toJson())),
        "nearest_area": List<dynamic>.from(nearestArea.map((x) => x.toJson())),
        "current_condition":
            List<dynamic>.from(currentCondition.map((x) => x.toJson())),
        "weather": List<dynamic>.from(weather.map((x) => x.toJson())),
        "ClimateAverages":
            List<dynamic>.from(climateAverages.map((x) => x.toJson())),
        "alerts": alerts.toJson(),
      };
}

class Alerts {
  Alerts({
    this.alert,
  });

  List<dynamic> alert;

  factory Alerts.fromRawJson(String str) => Alerts.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Alerts.fromJson(Map<String, dynamic> json) => Alerts(
        alert: List<dynamic>.from(json["alert"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "alert": List<dynamic>.from(alert.map((x) => x)),
      };
}

class ClimateAverage {
  ClimateAverage({
    this.month,
  });

  List<Month> month;

  factory ClimateAverage.fromRawJson(String str) =>
      ClimateAverage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClimateAverage.fromJson(Map<String, dynamic> json) => ClimateAverage(
        month: List<Month>.from(json["month"].map((x) => Month.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "month": List<dynamic>.from(month.map((x) => x.toJson())),
      };
}

class Month {
  Month({
    this.index,
    this.name,
    this.avgMinTemp,
    this.avgMinTempF,
    this.absMaxTemp,
    this.absMaxTempF,
    this.avgDailyRainfall,
  });

  String index;
  String name;
  String avgMinTemp;
  String avgMinTempF;
  String absMaxTemp;
  String absMaxTempF;
  String avgDailyRainfall;

  factory Month.fromRawJson(String str) => Month.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Month.fromJson(Map<String, dynamic> json) => Month(
        index: json["index"],
        name: json["name"],
        avgMinTemp: json["avgMinTemp"],
        avgMinTempF: json["avgMinTemp_F"],
        absMaxTemp: json["absMaxTemp"],
        absMaxTempF: json["absMaxTemp_F"],
        avgDailyRainfall: json["avgDailyRainfall"],
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "name": name,
        "avgMinTemp": avgMinTemp,
        "avgMinTemp_F": avgMinTempF,
        "absMaxTemp": absMaxTemp,
        "absMaxTemp_F": absMaxTempF,
        "avgDailyRainfall": avgDailyRainfall,
      };
}

class CurrentCondition {
  CurrentCondition({
    this.observationTime,
    this.tempC,
    this.tempF,
    this.weatherCode,
    this.weatherIconUrl,
    this.weatherDesc,
    this.windspeedMiles,
    this.windspeedKmph,
    this.winddirDegree,
    this.winddir16Point,
    this.precipMm,
    this.precipInches,
    this.humidity,
    this.visibility,
    this.visibilityMiles,
    this.pressure,
    this.pressureInches,
    this.cloudcover,
    this.feelsLikeC,
    this.feelsLikeF,
    this.uvIndex,
    this.airQuality,
  });

  String observationTime;
  String tempC;
  String tempF;
  String weatherCode;
  List<WeatherDesc> weatherIconUrl;
  List<WeatherDesc> weatherDesc;
  String windspeedMiles;
  String windspeedKmph;
  String winddirDegree;
  String winddir16Point;
  String precipMm;
  String precipInches;
  String humidity;
  String visibility;
  String visibilityMiles;
  String pressure;
  String pressureInches;
  String cloudcover;
  String feelsLikeC;
  String feelsLikeF;
  String uvIndex;
  AirQuality airQuality;

  factory CurrentCondition.fromRawJson(String str) =>
      CurrentCondition.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrentCondition.fromJson(Map<String, dynamic> json) =>
      CurrentCondition(
        observationTime: json["observation_time"],
        tempC: json["temp_C"],
        tempF: json["temp_F"],
        weatherCode: json["weatherCode"],
        weatherIconUrl: List<WeatherDesc>.from(
            json["weatherIconUrl"].map((x) => WeatherDesc.fromJson(x))),
        weatherDesc: List<WeatherDesc>.from(
            json["weatherDesc"].map((x) => WeatherDesc.fromJson(x))),
        windspeedMiles: json["windspeedMiles"],
        windspeedKmph: json["windspeedKmph"],
        winddirDegree: json["winddirDegree"],
        winddir16Point: json["winddir16Point"],
        precipMm: json["precipMM"],
        precipInches: json["precipInches"],
        humidity: json["humidity"],
        visibility: json["visibility"],
        visibilityMiles: json["visibilityMiles"],
        pressure: json["pressure"],
        pressureInches: json["pressureInches"],
        cloudcover: json["cloudcover"],
        feelsLikeC: json["FeelsLikeC"],
        feelsLikeF: json["FeelsLikeF"],
        uvIndex: json["uvIndex"],
        airQuality: AirQuality.fromJson(json["air_quality"]),
      );

  Map<String, dynamic> toJson() => {
        "observation_time": observationTime,
        "temp_C": tempC,
        "temp_F": tempF,
        "weatherCode": weatherCode,
        "weatherIconUrl":
            List<dynamic>.from(weatherIconUrl.map((x) => x.toJson())),
        "weatherDesc": List<dynamic>.from(weatherDesc.map((x) => x.toJson())),
        "windspeedMiles": windspeedMiles,
        "windspeedKmph": windspeedKmph,
        "winddirDegree": winddirDegree,
        "winddir16Point": winddir16Point,
        "precipMM": precipMm,
        "precipInches": precipInches,
        "humidity": humidity,
        "visibility": visibility,
        "visibilityMiles": visibilityMiles,
        "pressure": pressure,
        "pressureInches": pressureInches,
        "cloudcover": cloudcover,
        "FeelsLikeC": feelsLikeC,
        "FeelsLikeF": feelsLikeF,
        "uvIndex": uvIndex,
        "air_quality": airQuality.toJson(),
      };
}

class AirQuality {
  AirQuality({
    this.co,
    this.no2,
    this.o3,
    this.so2,
    this.pm25,
    this.pm10,
    this.usEpaIndex,
    this.gbDefraIndex,
  });

  String co;
  String no2;
  String o3;
  String so2;
  String pm25;
  String pm10;
  String usEpaIndex;
  String gbDefraIndex;

  factory AirQuality.fromRawJson(String str) =>
      AirQuality.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AirQuality.fromJson(Map<String, dynamic> json) => AirQuality(
        co: json["co"] == null ? null : json["co"],
        no2: json["no2"] == null ? null : json["no2"],
        o3: json["o3"] == null ? null : json["o3"],
        so2: json["so2"] == null ? null : json["so2"],
        pm25: json["pm2_5"] == null ? null : json["pm2_5"],
        pm10: json["pm10"] == null ? null : json["pm10"],
        usEpaIndex: json["us-epa-index"] == null ? null : json["us-epa-index"],
        gbDefraIndex:
            json["gb-defra-index"] == null ? null : json["gb-defra-index"],
      );

  Map<String, dynamic> toJson() => {
        "co": co == null ? null : co,
        "no2": no2 == null ? null : no2,
        "o3": o3 == null ? null : o3,
        "so2": so2 == null ? null : so2,
        "pm2_5": pm25 == null ? null : pm25,
        "pm10": pm10 == null ? null : pm10,
        "us-epa-index": usEpaIndex == null ? null : usEpaIndex,
        "gb-defra-index": gbDefraIndex == null ? null : gbDefraIndex,
      };
}

class WeatherDesc {
  WeatherDesc({
    this.value,
  });

  String value;

  factory WeatherDesc.fromRawJson(String str) =>
      WeatherDesc.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeatherDesc.fromJson(Map<String, dynamic> json) => WeatherDesc(
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}

class NearestArea {
  NearestArea({
    this.areaName,
    this.country,
    this.region,
    this.latitude,
    this.longitude,
    this.population,
    this.weatherUrl,
  });

  List<WeatherDesc> areaName;
  List<WeatherDesc> country;
  List<WeatherDesc> region;
  String latitude;
  String longitude;
  String population;
  List<WeatherDesc> weatherUrl;

  factory NearestArea.fromRawJson(String str) =>
      NearestArea.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NearestArea.fromJson(Map<String, dynamic> json) => NearestArea(
        areaName: List<WeatherDesc>.from(
            json["areaName"].map((x) => WeatherDesc.fromJson(x))),
        country: List<WeatherDesc>.from(
            json["country"].map((x) => WeatherDesc.fromJson(x))),
        region: List<WeatherDesc>.from(
            json["region"].map((x) => WeatherDesc.fromJson(x))),
        latitude: json["latitude"],
        longitude: json["longitude"],
        population: json["population"],
        weatherUrl: List<WeatherDesc>.from(
            json["weatherUrl"].map((x) => WeatherDesc.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "areaName": List<dynamic>.from(areaName.map((x) => x.toJson())),
        "country": List<dynamic>.from(country.map((x) => x.toJson())),
        "region": List<dynamic>.from(region.map((x) => x.toJson())),
        "latitude": latitude,
        "longitude": longitude,
        "population": population,
        "weatherUrl": List<dynamic>.from(weatherUrl.map((x) => x.toJson())),
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

class Weather {
  Weather({
    this.date,
    this.astronomy,
    this.maxtempC,
    this.maxtempF,
    this.mintempC,
    this.mintempF,
    this.avgtempC,
    this.avgtempF,
    this.totalSnowCm,
    this.sunHour,
    this.uvIndex,
    this.airQuality,
    this.hourly,
  });

  DateTime date;
  List<Astronomy> astronomy;
  String maxtempC;
  String maxtempF;
  String mintempC;
  String mintempF;
  String avgtempC;
  String avgtempF;
  String totalSnowCm;
  String sunHour;
  String uvIndex;
  AirQuality airQuality;
  List<Hourly> hourly;

  factory Weather.fromRawJson(String str) => Weather.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        date: DateTime.parse(json["date"]),
        astronomy: List<Astronomy>.from(
            json["astronomy"].map((x) => Astronomy.fromJson(x))),
        maxtempC: json["maxtempC"],
        maxtempF: json["maxtempF"],
        mintempC: json["mintempC"],
        mintempF: json["mintempF"],
        avgtempC: json["avgtempC"],
        avgtempF: json["avgtempF"],
        totalSnowCm: json["totalSnow_cm"],
        sunHour: json["sunHour"],
        uvIndex: json["uvIndex"],
        airQuality: AirQuality.fromJson(json["air_quality"]),
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
        "avgtempC": avgtempC,
        "avgtempF": avgtempF,
        "totalSnow_cm": totalSnowCm,
        "sunHour": sunHour,
        "uvIndex": uvIndex,
        "air_quality": airQuality.toJson(),
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

  factory Astronomy.fromRawJson(String str) =>
      Astronomy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
    this.chanceofrain,
    this.chanceofremdry,
    this.chanceofwindy,
    this.chanceofovercast,
    this.chanceofsunshine,
    this.chanceoffrost,
    this.chanceofhightemp,
    this.chanceoffog,
    this.chanceofsnow,
    this.chanceofthunder,
    this.uvIndex,
    this.airQuality,
  });

  String time;
  String tempC;
  String tempF;
  String windspeedMiles;
  String windspeedKmph;
  String winddirDegree;
  String winddir16Point;
  String weatherCode;
  List<WeatherDesc> weatherIconUrl;
  List<WeatherDesc> weatherDesc;
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
  String chanceofrain;
  String chanceofremdry;
  String chanceofwindy;
  String chanceofovercast;
  String chanceofsunshine;
  String chanceoffrost;
  String chanceofhightemp;
  String chanceoffog;
  String chanceofsnow;
  String chanceofthunder;
  String uvIndex;
  AirQuality airQuality;

  factory Hourly.fromRawJson(String str) => Hourly.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
        time: json["time"],
        tempC: json["tempC"],
        tempF: json["tempF"],
        windspeedMiles: json["windspeedMiles"],
        windspeedKmph: json["windspeedKmph"],
        winddirDegree: json["winddirDegree"],
        winddir16Point: json["winddir16Point"],
        weatherCode: json["weatherCode"],
        weatherIconUrl: List<WeatherDesc>.from(
            json["weatherIconUrl"].map((x) => WeatherDesc.fromJson(x))),
        weatherDesc: List<WeatherDesc>.from(
            json["weatherDesc"].map((x) => WeatherDesc.fromJson(x))),
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
        chanceofrain: json["chanceofrain"],
        chanceofremdry: json["chanceofremdry"],
        chanceofwindy: json["chanceofwindy"],
        chanceofovercast: json["chanceofovercast"],
        chanceofsunshine: json["chanceofsunshine"],
        chanceoffrost: json["chanceoffrost"],
        chanceofhightemp: json["chanceofhightemp"],
        chanceoffog: json["chanceoffog"],
        chanceofsnow: json["chanceofsnow"],
        chanceofthunder: json["chanceofthunder"],
        uvIndex: json["uvIndex"],
        airQuality: AirQuality.fromJson(json["air_quality"]),
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
        "chanceofrain": chanceofrain,
        "chanceofremdry": chanceofremdry,
        "chanceofwindy": chanceofwindy,
        "chanceofovercast": chanceofovercast,
        "chanceofsunshine": chanceofsunshine,
        "chanceoffrost": chanceoffrost,
        "chanceofhightemp": chanceofhightemp,
        "chanceoffog": chanceoffog,
        "chanceofsnow": chanceofsnow,
        "chanceofthunder": chanceofthunder,
        "uvIndex": uvIndex,
        "air_quality": airQuality.toJson(),
      };
}

class LocalWeatherService {
  String latLong = '26.7747,-77.3296';
  String testLatLong = "29.6516, -82.3248";
  getLocalWeatherData() async {
    globalWeather.weatherAPIError = false;
    print("Hello Local Weather, $globalLatitude, $globalLongitude");
    if ((globalLatitude != null) && (globalLongitude != null)) {
      latLong = '$globalLatitude, $globalLongitude';
    }

    /*
    https://api.worldweatheronline.com/premium/v1/weather.ashx
    ?key=51503debb4b34526a33181926211204&q=26.69 ,-77.29&
    format=json&
    num_of_days=5&mca=yes&fx24=yes&includelocation=yes&
    tp=3&alerts=yes&aqi=yes
     */

// https://api.worldweatheronline.com/premium/v1/weather.ashx?
// key=51503debb4b34526a33181926211204&q=26.7747,-77.3296
// &format=json&
// num_of_days=5&mca=yes&fx24=yes&includelocation=yes
// &tp=3&alerts=yes&aqi=yes
    try {
      Response response =
          await Dio().get(weatherServerURL + 'weather.ashx', queryParameters: {
        'key': '51503debb4b34526a33181926211204',
        'q': latLong,
        'format': 'json',
        'tp': '3',
        'num_of_days': '5',
        "mca": "yes",
        "fx24": "yes",
        "includeLocation": "yes",
        "alerts": "yes",
        "aqi": "yes"
      });

      // Map nearbyLocationsMap = response.data;
      print("Response found");
      print(response.data);

//      Map weatherMap = response.data;
//      print(weatherMap['data']['weather'][0]['date']);
//      var x = weatherMap['data']['weather'][0]['tides'][0]['tide_data'][0]
//      ['tideTime'];
      //   MarineWeather weatherData = MarineWeather();
      localWeather = LocalWeather.fromJson(response.data);
      // weatherData = MarineWeather.fromJson(weatherMap);
      print("Map Complete");
      globalWeather.localWeatherExists = false;
      globalWeather.localHourlyExists = false;

      if (localWeather.data.weather.length != 0) {
        globalWeather.localWeatherExists = true;
        populateGlobalWeather();

        if (localWeather.data.weather[0].hourly.length != 0) {
          globalWeather.localHourlyExists = true;
        }
      }
      print("Map complete");
//      print(localWeather.data.weather[0]);
//      for (var weatherDesc
//          in localWeather.data.weather[0].weatherDesc) {
//        print("About to print");
//        print(weatherDesc.toJson());
//      }

      return;
    } catch (e) {
      globalWeather.localWeatherExists = false;
      globalWeather.localHourlyExists = false;
      globalWeather.weatherAPIError = true;
      marqueeString =
          "Weather Data Not Loaded Please Check Network Settings or Change Location";
      print("error found");
      print(e);
    }
  }

  populateGlobalWeather() {
    globalWeather.dailyWeather = [];
    globalWeather.loadDate = DateTime.now();
    globalWeather.city = localWeather.data.nearestArea[0].areaName[0].value;
    globalWeather.country = localWeather.data.nearestArea[0].country[0].value;
    globalWeather.loadDateString =
        DateFormat('MMMd').format(localWeather.data.weather[0].date);

    //  String start = "Today\s";
    for (var i = 0; i < localWeather.data.weather.length; i++) {
      print("About to add weather $i");
      globalWeather.dailyWeather.add(WeatherDay());
      if (i != 0) {
        globalWeather.dailyWeather[i].dayString =
            DateFormat('EEEE').format(localWeather.data.weather[i].date);
      } else {
        globalWeather.dailyWeather[i].dayString = "Today";
      }
      globalWeather.dailyWeather[i].date = localWeather.data.weather[i].date;
      if (localWeather.data.weather[i].astronomy.length != 0) {
        globalWeather.dailyWeather[i].sunrise =
            localWeather.data.weather[i].astronomy[0].sunrise;
        globalWeather.dailyWeather[i].sunset =
            localWeather.data.weather[i].astronomy[0].sunrise;
        globalWeather.dailyWeather[i].moonrise =
            localWeather.data.weather[i].astronomy[0].sunrise;
        globalWeather.dailyWeather[i].moonset =
            localWeather.data.weather[i].astronomy[0].sunrise;
        globalWeather.dailyWeather[i].moonPhase =
            localWeather.data.weather[i].astronomy[0].moonPhase;
        globalWeather.dailyWeather[i].moonIllumination =
            localWeather.data.weather[i].astronomy[0].moonIllumination;
      }
      if (globalWeather.marineHourlyExists && i == 0) {
        globalWeather.dailyWeather[i].waterTemp =
            weatherData.data.weather[0].hourly[0].waterTempF;
        globalWeather.dailyWeather[i].waveHt =
            weatherData.data.weather[0].hourly[0].swellHeightFt;
        globalWeather.dailyWeather[i]
          ..waveDirection =
              weatherData.data.weather[0].hourly[0].swellDir16Point;
        print("Zee Waves " +
            globalWeather.dailyWeather[i].waveHt +
            globalWeather.dailyWeather[i].waveDirection);
      }
      if (globalWeather.tideDataExists && i == 0) {
        globalWeather.dailyWeather[i].tideMarquee = "";

        for (var k = 0;
            k < weatherData.data.weather[0].tides[0].tideData.length;
            k++) {
          print("TideAdd $k");
          globalWeather.dailyWeather[i].tides.add(TideElement());
          globalWeather.dailyWeather[i].tides[k].tideType =
              weatherData.data.weather[0].tides[0].tideData[k].tideType;
          globalWeather.dailyWeather[i].tides[k].tideDateTime = (DateTime.parse(
              weatherData.data.weather[0].tides[0].tideData[k].tideDateTime));

          globalWeather.dailyWeather[i].tides[k].tideHeightFt = (double.parse(
                      weatherData
                          .data.weather[0].tides[0].tideData[k].tideHeightMt) /
                  3.28084)
              .toStringAsFixed(2);
          globalWeather.dailyWeather[i].tides[k].tideHeight = (double.parse(
                  weatherData
                      .data.weather[0].tides[0].tideData[k].tideHeightMt) /
              3.28084);
          globalWeather.dailyWeather[i].tides[k].tideTime =
              weatherData.data.weather[0].tides[0].tideData[k].tideDateTime;

          String StartString = "Tides: First ";
          if (k > 1) {
            StartString = "Tides: Second ";
          }
          globalWeather.dailyWeather[i].tideMarquee =
              globalWeather.dailyWeather[i].tideMarquee +
                  StartString +
                  weatherData.data.weather[0].tides[0].tideData[k].tideType
                      .toLowerCase() +
                  " tide " +
                  (double.parse(weatherData.data.weather[0].tides[0].tideData[k]
                              .tideHeightMt) /
                          3.28084)
                      .toStringAsFixed(2) +
                  "ft@ " +
                  DateFormat('hh:mma').format(DateTime.parse(weatherData
                      .data.weather[0].tides[0].tideData[k].tideDateTime)) +
                  marqueeSpacer;
        }
      }
      globalWeather.dailyWeather[i].highTemp =
          localWeather.data.weather[i].maxtempF;
      globalWeather.dailyWeather[i].lowTemp =
          localWeather.data.weather[i].mintempF;

      if (localWeather.data.weather[i].hourly.length != 0) {
        globalWeather.dailyWeather[i].pressure =
            localWeather.data.weather[i].hourly[0].pressureInches;
        globalWeather.dailyWeather[i].windSpeed =
            localWeather.data.weather[i].hourly[0].windspeedMiles;
        globalWeather.dailyWeather[i].windDirection =
            localWeather.data.weather[i].hourly[0].winddir16Point;
        print("ZeeWind" +
            globalWeather.dailyWeather[i].windSpeed +
            " " +
            globalWeather.dailyWeather[i].windDirection);
        globalWeather.dailyWeather[i].windGust =
            localWeather.data.weather[i].hourly[0].windGustMiles;

        globalWeather.dailyWeather[i].airQuality = airQuality[
            localWeather.data.weather[i].hourly[0].airQuality.usEpaIndex];
        globalWeather.dailyWeather[i].humidity =
            localWeather.data.weather[i].hourly[0].visibilityMiles;
//        globalWeather.dailyWeather[i].currentWeatherIcon = getWeatherIconBox(
//            time: "0900",
//            code: localWeather.data.weather[i].hourly[0].weatherCode);
        globalWeather.dailyWeather[i].weatherCode =
            localWeather.data.weather[i].hourly[0].weatherCode;
        globalWeather.dailyWeather[i].weatherConditionDesc =
            localWeather.data.weather[i].hourly[0].weatherDesc[0].value;
        globalWeather.dailyWeather[i].chanceOfRain =
            localWeather.data.weather[i].hourly[0].chanceofrain;
        globalWeather.dailyWeather[i].cloudCover =
            localWeather.data.weather[i].hourly[0].cloudcover;
        globalWeather.dailyWeather[i].visibility =
            localWeather.data.weather[i].hourly[0].visibilityMiles;
        globalWeather.dailyWeather[i].marquee =
            getWeatherLine(globalWeather.dailyWeather[i].dayString, i);
        //   print("MadeAMarquee =\n$globalWeather.dailyWeather[i].marquee");
      } //  The 0 element in hourly array is dayly summary
      for (var j = 1; j < localWeather.data.weather[i].hourly.length; j++) {
        print("HourAdd $j");
        globalWeather.dailyWeather[i].hourly.add(HourlyWeather());
        globalWeather.dailyWeather[i].hourly[j - 1].timeofDay =
            timeMap[localWeather.data.weather[i].hourly[j].time];

        globalWeather.dailyWeather[i].hourly[j - 1].timeString =
            hourFmt[localWeather.data.weather[i].hourly[j].time];
        globalWeather.dailyWeather[i].hourly[j - 1].temp =
            localWeather.data.weather[i].hourly[j].tempF;
        globalWeather.dailyWeather[i].hourly[j - 1].pressure =
            localWeather.data.weather[i].hourly[j].pressureInches;
        globalWeather.dailyWeather[i].hourly[j - 1].windSpeed =
            localWeather.data.weather[i].hourly[j].windspeedMiles;
        globalWeather.dailyWeather[i].hourly[j - 1].windDirection =
            localWeather.data.weather[i].hourly[j].winddir16Point;
        globalWeather.dailyWeather[i].hourly[j - 1].windGust =
            localWeather.data.weather[i].hourly[j].windGustMiles;

        globalWeather.dailyWeather[i].hourly[j - 1].airQuality = airQuality[
            localWeather.data.weather[i].hourly[j].airQuality.usEpaIndex];
        globalWeather.dailyWeather[i].hourly[j - 1].humidity =
            localWeather.data.weather[i].hourly[j].visibilityMiles;
//        globalWeather.dailyWeather[i].hourly[j - 1].currentWeatherIcon =
//            getWeatherIconBox(
//                time: localWeather.data.weather[i].hourly[j].time,
//                code: localWeather.data.weather[i].hourly[0].weatherCode);
        globalWeather.dailyWeather[i].hourly[j - 1].weatherCode =
            localWeather.data.weather[i].hourly[j].weatherCode;
        globalWeather.dailyWeather[i].hourly[j - 1].weatherConditionDesc =
            localWeather.data.weather[i].hourly[j].weatherDesc[0].value;
        globalWeather.dailyWeather[i].hourly[j - 1].chanceOfRain =
            localWeather.data.weather[i].hourly[j].chanceofrain;
        globalWeather.dailyWeather[i].hourly[j - 1].cloudCover =
            localWeather.data.weather[i].hourly[j].cloudcover;
        globalWeather.dailyWeather[i].hourly[j - 1].visibility =
            localWeather.data.weather[i].hourly[j].visibilityMiles;

        if (globalWeather.marineHourlyExists && i == 0) {
          globalWeather.dailyWeather[0].hourly[j - 1].waveHt =
              weatherData.data.weather[0].hourly[j - 1].swellHeightFt;
          globalWeather.dailyWeather[i].hourly[j - 1].waveDirection =
              weatherData.data.weather[0].hourly[j - 1].swellDir16Point;
        }
      }
    }
    String tides = "";
    if (globalWeather.tideDataExists) {
      tides = globalWeather.dailyWeather[0].tideMarquee;

      String weather = "";
      for (var i = 0; i < globalWeather.dailyWeather.length && i < 5; i++) {
        print("Yea Yo");
        weather = weather = globalWeather.dailyWeather[i].marquee;
      }
      marqueeString =
          "                                                                     " +
              "                                                             " +
              tides +
              weather +
              "  ";
    }
  }

  getWeatherLine(String stringDay, int day) {
    return ("     " +
        stringDay +
        " Weather:    " +
        localWeather.data.weather[day].hourly[0].weatherDesc[0].value +
        marqueeSpacer +
        "Lo " +
        localWeather.data.weather[day].mintempF +
        "\u00B0F" + //\u2109
        marqueeSpacer +
        "High " +
        weatherData.data.weather[day].maxtempF +
        "\u00B0F" +
        marqueeSpacer +
        "Humidity " +
        localWeather.data.weather[day].hourly[0].humidity +
        "%" +
        marqueeSpacer +
        "Barometric Pressure " +
        localWeather.data.weather[day].hourly[0].pressureInches +
        "in" +
        marqueeSpacer +
        "Chance of Rain " +
        localWeather.data.weather[day].hourly[0].chanceofrain +
        "%" +
        marqueeSpacer +
        "Cloud Cover " +
        localWeather.data.weather[day].hourly[0].cloudcover +
        "%" +
        marqueeSpacer +
        "Wind Speed " +
        localWeather.data.weather[day].hourly[0].windspeedMiles +
        "(mph) gusting to " +
        localWeather.data.weather[day].hourly[0].windGustMiles +
        marqueeSpacer +
        "Visibility " +
        localWeather.data.weather[day].hourly[0].visibilityMiles +
        " miles" +
        marqueeSpacer +
        "Air Quality  " +
        airQuality[
            localWeather.data.weather[day].hourly[0].airQuality.usEpaIndex] +
        marqueeSpacer +
        "           ");
  }
}
