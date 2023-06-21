class WateringPlanModel {
  String? prediction;
  List<TopProbabilities>? topProbabilities;
  List<WateringPlan>? wateringPlan;

  WateringPlanModel({this.prediction, this.topProbabilities, this.wateringPlan});

  WateringPlanModel.fromJson(Map<String, dynamic> json) {
    prediction = json['prediction'];
    if (json['top_probabilities'] != null) {
      topProbabilities = <TopProbabilities>[];
      json['top_probabilities'].forEach((v) {
        topProbabilities!.add(TopProbabilities.fromJson(v));
      });
    }
    if (json['watering_plan'] != null) {
      wateringPlan = <WateringPlan>[];
      json['watering_plan'].forEach((v) {
        wateringPlan!.add(WateringPlan.fromJson(v));
      });
    }
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
