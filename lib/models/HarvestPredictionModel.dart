class HarvestPredictionModel {
  String? prediction;
  Map<String, dynamic>? topProbabilities;
  List<PostHarvestPractices>? postHarvestPractices;
  String? error;

  HarvestPredictionModel(
      {this.prediction, this.topProbabilities, this.postHarvestPractices, this.error});

  HarvestPredictionModel.fromJson(Map<String, dynamic> json) {
    prediction = json['prediction'];
    topProbabilities = json['top_probabilities'];
    if (json['post_harvest_practices'] != null) {
      postHarvestPractices = <PostHarvestPractices>[];
      json['post_harvest_practices'].forEach((v) {
        postHarvestPractices!.add(PostHarvestPractices.fromJson(v));
      });
    }
    error = json['error'];
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
}