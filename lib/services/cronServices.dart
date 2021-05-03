import 'package:cron/cron.dart';
import 'package:tidey/services/marineWeather.dart';
import 'package:tidey/services/localWeather.dart';
import 'package:tidey/const.dart';

class CronJobs {
  final cron = Cron();
  init() {
    WeatherService weatherService = WeatherService();
    LocalWeatherService localWeatherService = LocalWeatherService();

    cron.schedule(Schedule.parse('0 0 * * *'), () async {
      //this will run each midnight
      await weatherService.getMarineData();
      await localWeatherService.getLocalWeatherData();
      if (globalWeather.tideAPIError) {
        print(
            'getting nightly weather data failed - checking again every 15 minutes');
      } else {
        print('nightly weather data updated successfully');
      }
    });
    cron.schedule(Schedule.parse('*/15 * * * *'), () async {
      if (globalWeather.tideAPIError) {
        await weatherService.getMarineData();
        await localWeatherService.getLocalWeatherData();
      }
      if (globalWeather.weatherAPIError) {
        await localWeatherService.getLocalWeatherData();
      }
    });
  }
}
