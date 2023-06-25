class WateringPlanModel {
  String? prediction;
  List<TopProbabilities>? topProbabilities;
  WateringPlan? wateringPlan;

  WateringPlanModel({this.prediction, this.topProbabilities, this.wateringPlan});

  WateringPlanModel.fromJson(Map<String, dynamic> json) {
    prediction = json['prediction'];
    if (json['top_probabilities'] != null) {
      topProbabilities = <TopProbabilities>[];
      json['top_probabilities'].forEach((v) {
        topProbabilities!.add(TopProbabilities.fromJson(v));
      });
    }
    wateringPlan = json['watering_plan'] != null
        ? WateringPlan.fromJson(json['watering_plan'])
        : null;
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
  String? wateringPlan;
  String? variety;
  String? stage;
  String? description;

  WateringPlan({this.wateringPlan, this.variety, this.stage, this.description});

  WateringPlan.fromJson(Map<String, dynamic> json) {
    wateringPlan = json['watering_plan'];
    variety = json['variety'];
    stage = json['stage'];
    description = json['description'];
  }
}
