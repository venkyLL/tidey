import 'package:geolocator/geolocator.dart';
import 'package:tidey/const.dart';

class Location {
  double latitude;
  double longitude;

  Future<bool> getCurrentLocation() async {
    print("in getCurrentLocation , useCurrent Location = " +
        userSettings.useCurrentPosition.toString());
    if (userSettings.useCurrentPosition) {
      try {
//      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
        print("before await getCurrentLocation");

        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low);

        print(" after getCurrentLocation");

        globalLatitude = position.latitude.toString();
        globalLongitude = position.longitude.toString();
        print("returning latitude is $globalLatitude");
        return (true);
      } catch (e) {
        return (false);
        print("my getCurrentLocation error is $e");
      }
    } else {
      return (true);
    }
  }
}
