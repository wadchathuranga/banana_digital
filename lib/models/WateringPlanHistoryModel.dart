class WateringPlanHistoryModel {
  WateringPlan? wateringPlan;
  String? soilPh;
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
  String? variety;
  String? waterSource;
  String? irrigationMethod;
  String? fertilizerUsedLastSeason;
  String? cropRotation;
  String? pestDiseaseInfestation;
  String? slope;
  String? stage;
  List<TopProbabilities>? topProbabilities;
  String? createdAt;

  WateringPlanHistoryModel(
      {this.wateringPlan,
        this.soilPh,
        this.organicMatterContent,
        this.soilType,
        this.soilMoisture,
        this.avgTemperature,
        this.avgRainfall,
        this.plantHeight,
        this.leafColor,
        this.stemDiameter,
        this.plantDensity,
        this.variety,
        this.stage,
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
        this.createdAt});

  WateringPlanHistoryModel.fromJson(Map<String, dynamic> json) {
    wateringPlan = json['watering_plan'] != null
        ? WateringPlan.fromJson(json['watering_plan'])
        : null;
    soilPh = json['pH'];
    organicMatterContent = json['organic_matter_content'];
    soilType = json['soil_type'];
    soilMoisture = json['soil_moisture'];
    avgTemperature = json['avg_temperature'];
    avgRainfall = json['avg_rainfall'];
    plantHeight = json['plant_height'];
    leafColor = json['leaf_color'];
    variety = json['variety'];
    stage = json['stage'];
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
  }
}

class WateringPlan {
  String? wateringPlan;
  String? variety;
  String? description;

  WateringPlan({this.wateringPlan, this.variety, this.description});

  WateringPlan.fromJson(Map<String, dynamic> json) {
    wateringPlan = json['watering_plan'];
    variety = json['variety'];
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
