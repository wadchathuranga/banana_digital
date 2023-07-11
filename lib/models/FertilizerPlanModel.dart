class FertilizerPlanModel {
  String? dose;
  List<TopProbabilities>? topProbabilities;
  FertilizerPlan? fertilizerPlan;
  String? error;

  FertilizerPlanModel({this.dose, this.error, this.topProbabilities, this.fertilizerPlan});

  FertilizerPlanModel.fromJson(Map<String, dynamic> json) {
    dose = json['dose'];
    error = json['error'];
    fertilizerPlan = json['fertilizer_plan'] != null
        ? FertilizerPlan.fromJson(json['fertilizer_plan'])
        : null;
    if (json['top_probabilities'] != null) {
      topProbabilities = <TopProbabilities>[];
      json['top_probabilities'].forEach((v) {
        topProbabilities!.add(TopProbabilities.fromJson(v));
      });
    }
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

class FertilizerPlan {
  String? fertilizerType;
  String? variety;
  String? stage;
  String? description;

  FertilizerPlan({this.fertilizerType, this.variety, this.stage, this.description});

  FertilizerPlan.fromJson(Map<String, dynamic> json) {
    fertilizerType = json['fertilizer_type'];
    variety = json['variety'];
    stage = json['stage'];
    description = json['description'];
  }
}
