import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/AvgWeatherDataModel.dart';
import '../utils/app_configs.dart';

class WeatherApiService {

  // GET: get current weather data by geolocation
  static Future getCurrentWeatherData() async {
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

  // GET: get average weather data
  static Future getAvgWeatherData() async {
    try {
      // get geolocation
      Position location = await getCurrentGeolocation();

      String? currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String? fromDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 30)));

      var url = Uri.parse('$AVG_WEATHER_API?latitude=${location.latitude}&longitude=${location.longitude}&start_date=$fromDate&end_date=$currentDate&hourly=temperature_2m,rain');
      final response = await http.get(url);

      final resData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        AvgWeatherDataModel data = AvgWeatherDataModel.fromJson(resData);
        final avgTemperature = calculateAvg(data.hourly!.temperature2m);
        final avgRainfall = calculateAvg(data.hourly!.rain);

        return {
          'avgTemperature': avgTemperature, 'avgRainfall': avgRainfall
        };
      } else {
        throw Exception(resData['reason'].toString());
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  // weather average calculation
  static calculateAvg(data) {
    double sum = 0.0;
    int count = 0;
    for (var value in data) {
      if (value != null) {
        sum += value;
        count++;
      }
    }
    double average = sum / count;
    return average;
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

  // get soil moisture data
  static Future getSoilMoistureData() async {
    try {
      var url = Uri.parse(SOIL_MOISTURE_API);
      final response = await http.get(url);
      return response;
    } catch (err) {
      throw Exception(err);
    }
  }
}