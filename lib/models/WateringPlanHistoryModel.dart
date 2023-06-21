class WateringPlanHistoryModel {
  int? id;
  WateringPlan? wateringPlan;
  String? pH;
  String? organicMatterContent;
  String? soilType;
  String? soilMoisture;
  int? avgTemperature;
  int? avgRainfall;
  int? plantHeight;
  String? leafColor;
  int? stemDiameter;
  int? plantDensity;
  String? soilTexture;
  String? soilColor;
  int? temperature;
  int? humidity;
  int? rainfall;
  String? waterSource;
  String? irrigationMethod;
  String? fertilizerUsedLastSeason;
  String? cropRotation;
  String? pestDiseaseInfestation;
  String? slope;
  List<TopProbabilities>? topProbabilities;
  String? createdAt;
  int? user;

  WateringPlanHistoryModel(
      {this.id,
        this.wateringPlan,
        this.pH,
        this.organicMatterContent,
        this.soilType,
        this.soilMoisture,
        this.avgTemperature,
        this.avgRainfall,
        this.plantHeight,
        this.leafColor,
        this.stemDiameter,
        this.plantDensity,
        this.soilTexture,
        this.soilColor,
        this.temperature,
        this.humidity,
        this.rainfall,
        this.waterSource,
        this.irrigationMethod,
        this.fertilizerUsedLastSeason,
        this.cropRotation,
        this.pestDiseaseInfestation,
        this.slope,
        this.topProbabilities,
        this.createdAt,
        this.user});

  WateringPlanHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wateringPlan = json['watering_plan'] != null
        ? WateringPlan.fromJson(json['watering_plan'])
        : null;
    pH = json['pH'];
    organicMatterContent = json['organic_matter_content'];
    soilType = json['soil_type'];
    soilMoisture = json['soil_moisture'];
    avgTemperature = json['avg_temperature'];
    avgRainfall = json['avg_rainfall'];
    plantHeight = json['plant_height'];
    leafColor = json['leaf_color'];
    stemDiameter = json['stem_diameter'];
    plantDensity = json['plant_density'];
    soilTexture = json['soil_texture'];
    soilColor = json['soil_color'];
    temperature = json['temperature'];
    humidity = json['humidity'];
    rainfall = json['rainfall'];
    waterSource = json['water_source'];
    irrigationMethod = json['irrigation_method'];
    fertilizerUsedLastSeason = json['fertilizer_used_last_season'];
    cropRotation = json['crop_rotation'];
    pestDiseaseInfestation = json['pest_disease_infestation'];
    slope = json['slope'];
    if (json['top_probabilities'] != null) {
      topProbabilities = <TopProbabilities>[];
      json['top_probabilities'].forEach((v) {
        topProbabilities!.add(TopProbabilities.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    user = json['user'];
  }
}

class WateringPlan {
  int? id;
  String? wateringPlan;
  String? stage;
  String? description;

  WateringPlan({this.id, this.wateringPlan, this.stage, this.description});

  WateringPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wateringPlan = json['watering_plan'];
    stage = json['stage'];
    description = json['description'];
  }
}

class TopProbabilities {
  String? plan;
  String? probability;

  TopProbabilities({this.plan, this.probability});

  TopProbabilities.fromJson(Map<String, dynamic> json) {
    plan = json['plan'];
    probability = json['probability'];
  }
}
