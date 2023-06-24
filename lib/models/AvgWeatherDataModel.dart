class AvgWeatherDataModel {
  Hourly? hourly;

  AvgWeatherDataModel({this.hourly});

  AvgWeatherDataModel.fromJson(Map<String, dynamic> json) {
    hourly =
    json['hourly'] != null ? Hourly.fromJson(json['hourly']) : null;
  }
}

class Hourly {
  List<dynamic>? temperature2m;
  List<dynamic>? rain;

  Hourly({required this.temperature2m, required this.rain});

  Hourly.fromJson(Map<String, dynamic> json) {
    temperature2m = json['temperature_2m'];
    rain = json['rain'];
  }
}
