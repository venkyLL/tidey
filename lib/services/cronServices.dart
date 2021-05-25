import 'package:cron/cron.dart';
import 'package:tidey/const.dart';
import 'package:tidey/services/localWeather.dart';
import 'package:tidey/services/locationServices.dart';
import 'package:tidey/services/marineWeather.dart';
import 'package:tidey/services/tideServices.dart';

bool pollingError = false;

class CronJobs {
  final cron = Cron();
  init() {
    WeatherService weatherService = WeatherService();
    LocalWeatherService localWeatherService = LocalWeatherService();

    cron.schedule(Schedule.parse('0 0 * * *'), () async {
      //this will run each midnight
      Location location = Location();
      await location.getCurrentLocation();
      WeatherService weatherService = WeatherService();
      await weatherService.getMarineData();
      LocalWeatherService localWeatherService = LocalWeatherService();
      await localWeatherService.getLocalWeatherData();

      if (!globalWeather.localWeatherExists) {
        print("No Tide Data Existed");
        pollingError = true;
        globalWeather.tideAPIError =
            true; // if no weather data who cares about tide
        print("Di is $di days left is " +
            globalWeather.dailyWeather.length.toString());
        if (di < globalWeather.dailyWeather.length - 1) {
          //there is still data in array
          print("We still have data");
          globalWeather.weatherAPIError = false;

          di += 1;
        } else {
          print("At the end of the array");
          globalWeather.weatherAPIError = true;
        }
      } else if (!globalWeather.tideDataExists) {
        ("Print all is good");
        pollingError = false;
        globalWeather.tideAPIError = true;
        globalWeather.weatherAPIError = false;
        di = 0;
      } else {
        // All is good
        globalWeather.tideAPIError = false;
        globalWeather.weatherAPIError = false;
        pollingError = false;
        di = 0;
        mySineWaveData msw = mySineWaveData();
        await msw.computeTidesForPainting();
      }
    });

//    cron.schedule(Schedule.parse('*/15 * * * *'), () async {
//      //   if ((globalWeather.tideAPIError) || (globalWeather.weatherAPIError)) {
//      if (pollingError) {
//        Location location = Location();
//        await location.getCurrentLocation();
//        WeatherService weatherService = WeatherService();
//        await weatherService.getMarineData();
//        LocalWeatherService localWeatherService = LocalWeatherService();
//        await localWeatherService.getLocalWeatherData();
//
//        if (!globalWeather.localWeatherExists) {
//          pollingError = true;
//          globalWeather.tideAPIError =
//              true; // if no weather data who cares about tide
//
//        } else if (!globalWeather.tideDataExists) {
//          pollingError = false;
//          globalWeather.tideAPIError = true;
//          globalWeather.weatherAPIError = false;
//          di = 0;
//        } else {
//          // All is good
//          globalWeather.tideAPIError = false;
//          globalWeather.weatherAPIError = false;
//          pollingError = false;
//          di = 0;
//          mySineWaveData msw = mySineWaveData();
//          await msw.computeTidesForPainting();
//        }
//      }
//    });
  }
}
