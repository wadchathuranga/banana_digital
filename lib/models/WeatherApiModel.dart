class WeatherApiModel {
  Location? location;
  Current? current;

  WeatherApiModel({this.location, this.current});

  WeatherApiModel.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    current =
    json['current'] != null ? Current.fromJson(json['current']) : null;
  }
}

class Location {
  String? name;
  String? region;
  String? country;
  String? tzId;
  String? localtime;

  Location({this.name, this.region, this.country, this.tzId, this.localtime});

  Location.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    region = json['region'];
    country = json['country'];
    tzId = json['tz_id'];
    localtime = json['localtime'];
  }
}

class Current {
  double? tempC;
  double? tempF;
  double? precipMm;
  double? precipIn;
  int? humidity;

  Current(
      {this.tempC, this.tempF, this.precipMm, this.precipIn, this.humidity});

  Current.fromJson(Map<String, dynamic> json) {
    tempC = json['temp_c'];
    tempF = json['temp_f'];
    precipMm = json['precip_mm'];
    precipIn = json['precip_in'];
    humidity = json['humidity'];
  }
}