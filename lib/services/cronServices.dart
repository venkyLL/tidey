import 'package:cron/cron.dart';
import 'package:tidey/const.dart';
import 'package:tidey/services/localWeather.dart';
import 'package:tidey/services/locationServices.dart';
import 'package:tidey/services/marineWeather.dart';
import 'package:tidey/services/tideServices.dart';

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

      if (globalWeather.tideAPIError) {
        di += 1;
        print(
            'getting nightly weather data failed - checking again every 15 minutes');
      } else {
        mySineWaveData msw = mySineWaveData();
        await msw.computeTidesForPainting();
        print('nightly weather data updated successfully');
        di = 0;
      }
    });
    cron.schedule(Schedule.parse('*/15 * * * *'), () async {
      if ((globalWeather.tideAPIError) || (globalWeather.weatherAPIError)) {
        Location location = Location();
        await location.getCurrentLocation();
        WeatherService weatherService = WeatherService();
        await weatherService.getMarineData();
        LocalWeatherService localWeatherService = LocalWeatherService();
        await localWeatherService.getLocalWeatherData();
        if (globalWeather.tideAPIError) {
          print(
              'getting nightly weather data failed - checking again every 15 minutes');
        } else {
          di = 0;
          mySineWaveData msw = mySineWaveData();
          await msw.computeTidesForPainting();
          print('nightly weather data updated successfully');
        }
      }
    });
  }
}
