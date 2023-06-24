class CurrentWeatherModel {
  Location? location;
  Current? current;

  CurrentWeatherModel({this.location, this.current});

  CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
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


  Location({this.name, this.region});

  Location.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    region = json['region'];
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