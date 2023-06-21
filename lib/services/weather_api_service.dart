import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../utils/app_configs.dart';

class WeatherApiService {

  // GET: get current weather data by geolocation
  static Future getWeatherData() async {
    try {
      // get geolocation
      Position location = await getCurrentGeolocation();

      var url = Uri.parse('$WEATHER_API?q=${location.latitude},${location.longitude}');
      final response = await http.get(
          url,
          headers: {
            "X-RapidAPI-Key": X_API_KEY,
            "X-RapidAPI-Host": X_API_HOST,
          });
      return response;
    } catch (err) {
      throw Exception(err);
    }
  }

  // get device geolocation
  static Future<Position> getCurrentGeolocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled!');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied!');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permission!');
    }

    return await Geolocator.getCurrentPosition();
  }
}