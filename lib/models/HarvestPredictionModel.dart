class HarvestPredictionModel {
  int? id;
  String? predictedHarvest;
  String? agroClimaticRegion;
  int? plantDensity;
  double? spacingBetweenPlants;
  String? pesticidesUsed;
  String? plantGeneration;
  String? fertilizerType;
  double? soilPH;
  String? amountOfSunlightReceived;
  String? wateringSchedule;
  int? numberOfLeaves;
  int? height;
  int? variety;
  int? user;
  String? harvest;
  TopProbabilities? topProbabilities;
  String? createdAt;
  List<PostHarvestPractices>? postHarvestPractices;

  HarvestPredictionModel({
      this.id,
      this.predictedHarvest,
      this.agroClimaticRegion,
      this.plantDensity,
      this.spacingBetweenPlants,
      this.pesticidesUsed,
      this.plantGeneration,
      this.fertilizerType,
      this.soilPH,
      this.amountOfSunlightReceived,
      this.wateringSchedule,
      this.numberOfLeaves,
      this.height,
      this.variety,
      this.user,
      this.harvest,
      this.topProbabilities,
      this.createdAt,
      this.postHarvestPractices
  });

  HarvestPredictionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    predictedHarvest = json['predicted_harvest'];
    agroClimaticRegion = json['agro_climatic_region'];
    plantDensity = json['plant_density'];
    spacingBetweenPlants = json['spacing_between_plants'];
    pesticidesUsed = json['pesticides_used'];
    plantGeneration = json['plant_generation'];
    fertilizerType = json['fertilizer_type'];
    soilPH = json['soil_pH'];
    amountOfSunlightReceived = json['amount_of_sunlight_received'];
    wateringSchedule = json['watering_schedule'];
    numberOfLeaves = json['number_of_leaves'];
    height = json['height'];
    variety = json['variety'];
    user = json['user'];
    harvest = json['harvest'];
    topProbabilities = json['top_probabilities'] != null
        ? new TopProbabilities.fromJson(json['top_probabilities'])
        : null;
    createdAt = json['created_at'];
    if (json['post_harvest_practices'] != null) {
      postHarvestPractices = <PostHarvestPractices>[];
      json['post_harvest_practices'].forEach((v) {
        postHarvestPractices!.add(new PostHarvestPractices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['predicted_harvest'] = this.predictedHarvest;
    data['agro_climatic_region'] = this.agroClimaticRegion;
    data['plant_density'] = this.plantDensity;
    data['spacing_between_plants'] = this.spacingBetweenPlants;
    data['pesticides_used'] = this.pesticidesUsed;
    data['plant_generation'] = this.plantGeneration;
    data['fertilizer_type'] = this.fertilizerType;
    data['soil_pH'] = this.soilPH;
    data['amount_of_sunlight_received'] = this.amountOfSunlightReceived;
    data['watering_schedule'] = this.wateringSchedule;
    data['number_of_leaves'] = this.numberOfLeaves;
    data['height'] = this.height;
    data['variety'] = this.variety;
    data['user'] = this.user;
    data['harvest'] = this.harvest;
    if (this.topProbabilities != null) {
      data['top_probabilities'] = this.topProbabilities!.toJson();
    }
    data['created_at'] = this.createdAt;
    if (this.postHarvestPractices != null) {
      data['post_harvest_practices'] =
          this.postHarvestPractices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TopProbabilities {
  String? s2123Kg;
  String? s2426Kg;
  String? s2729Kg;

  TopProbabilities({this.s2123Kg, this.s2426Kg, this.s2729Kg});

  TopProbabilities.fromJson(Map<String, dynamic> json) {
    s2123Kg = json['21-23 kg'];
    s2426Kg = json['24-26 kg'];
    s2729Kg = json['27-29 kg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['21-23 kg'] = this.s2123Kg;
    data['24-26 kg'] = this.s2426Kg;
    data['27-29 kg'] = this.s2729Kg;
    return data;
  }
}

class PostHarvestPractices {
  String? practiceName;
  String? description;

  PostHarvestPractices({this.practiceName, this.description});

  PostHarvestPractices.fromJson(Map<String, dynamic> json) {
    practiceName = json['practice_name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['practice_name'] = this.practiceName;
    data['description'] = this.description;
    return data;
  }
}