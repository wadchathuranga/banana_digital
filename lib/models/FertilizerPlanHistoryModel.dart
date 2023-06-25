class FertilizerPlanHistoryModel {
  FertilizerPlan? fertilizerPlan;
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
  String? waterSource;
  String? irrigationMethod;
  String? fertilizerUsedLastSeason;
  String? cropRotation;
  String? pestDiseaseInfestation;
  String? slope;
  String? dose;
  List<TopProbabilities>? topProbabilities;
  String? createdAt;

  FertilizerPlanHistoryModel(
      {this.dose,
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
        this.fertilizerPlan,
        this.topProbabilities,
        this.createdAt});

  FertilizerPlanHistoryModel.fromJson(Map<String, dynamic> json) {
    fertilizerPlan = json['fertilizer_plan'] != null
        ? FertilizerPlan.fromJson(json['fertilizer_plan'])
        : null;
    soilPh = json['pH'];
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
    dose = json['dose'];
    if (json['top_probabilities'] != null) {
      topProbabilities = <TopProbabilities>[];
      json['top_probabilities'].forEach((v) {
        topProbabilities!.add(TopProbabilities.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }
}

class FertilizerPlan {
  String? fertilizerType;
  String? variety;
  String? stage;
  String? description;

  FertilizerPlan(
      {this.fertilizerType, this.variety, this.stage, this.description});

  FertilizerPlan.fromJson(Map<String, dynamic> json) {
    fertilizerType = json['fertilizer_type'];
    variety = json['variety'];
    stage = json['stage'];
    description = json['description'];
  }
}

class TopProbabilities {
  String? dose;
  String? probability;

  TopProbabilities({this.dose, this.probability});

  TopProbabilities.fromJson(Map<String, dynamic> json) {
    dose = json['dose'];
    probability = json['probability'];
  }
}
