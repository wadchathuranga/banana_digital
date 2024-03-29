import 'HarvestPredictionModel.dart';

class HarvestPredictionHistoryModel {
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
  double? height;
  String? variety;
  String? harvest;
  Map<String, dynamic>? topProbabilities;
  String? createdAt;
  List<PostHarvestPractices>? postHarvestPractices;

  HarvestPredictionHistoryModel({
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
        this.harvest,
        this.topProbabilities,
        this.createdAt,
        this.postHarvestPractices});

  HarvestPredictionHistoryModel.fromJson(Map<String, dynamic> json) {
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
    harvest = json['harvest'];
    topProbabilities = json['top_probabilities'];
    createdAt = json['created_at'];
    if (json['post_harvest_practices'] != null) {
      postHarvestPractices = <PostHarvestPractices>[];
      json['post_harvest_practices'].forEach((v) {
        postHarvestPractices!.add(PostHarvestPractices.fromJson(v));
      });
    }
  }
}

// class PostHarvestPractices {
//   String? practiceName;
//   String? description;
//
//   PostHarvestPractices({this.practiceName, this.description});
//
//   PostHarvestPractices.fromJson(Map<String, dynamic> json) {
//     practiceName = json['practice_name'];
//     description = json['description'];
//   }
// }