class FertilizerPlanModel {
  String? prediction;
  List<TopProbabilities>? topProbabilities;
  List<FertilizerPlan>? fertilizerPlan;

  FertilizerPlanModel({this.prediction, this.topProbabilities, this.fertilizerPlan});

  FertilizerPlanModel.fromJson(Map<String, dynamic> json) {
    prediction = json['prediction'];
    if (json['top_probabilities'] != null) {
      topProbabilities = <TopProbabilities>[];
      json['top_probabilities'].forEach((v) {
        topProbabilities!.add(TopProbabilities.fromJson(v));
      });
    }
    if (json['fertilizer_plan'] != null) {
      fertilizerPlan = <FertilizerPlan>[];
      json['fertilizer_plan'].forEach((v) {
        fertilizerPlan!.add(FertilizerPlan.fromJson(v));
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

class FertilizerPlan {
  int? id;
  String? fertilizerType;
  String? variety;
  String? description;

  FertilizerPlan({this.id, this.fertilizerType, this.variety, this.description});

  FertilizerPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fertilizerType = json['fertilizer_type'];
    variety = json['variety'];
    description = json['description'];
  }
}
