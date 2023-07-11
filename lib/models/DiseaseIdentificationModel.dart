class DiseaseIdentificationModel {
  String? topPrediction;
  Map<String, dynamic>? probabilities;
  Disease? disease;

  DiseaseIdentificationModel({this.topPrediction, this.probabilities, this.disease});

  DiseaseIdentificationModel.fromJson(Map<String, dynamic> json) {
    topPrediction = json['top_prediction'];
    probabilities = json['probabilities'];
    disease =
    json['disease'] != null ? Disease.fromJson(json['disease']) : null;
  }
}

class Disease {
  int? id;
  String? name;
  String? nameDisplay;
  String? img;
  String? description;
  String? symptomDescription;
  List<Cures>? cures;

  Disease(
      {this.id,
        this.name,
        this.nameDisplay,
        this.img,
        this.description,
        this.symptomDescription,
        this.cures});

  Disease.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameDisplay = json['name_display'];
    img = json['img'];
    description = json['description'];
    symptomDescription = json['symptom_description'];
    if (json['cures'] != null) {
      cures = <Cures>[];
      json['cures'].forEach((v) {
        cures!.add(Cures.fromJson(v));
      });
    }
  }
}

class Cures {
  String? nameDisplay;
  String? description;
  String? img;

  Cures({this.nameDisplay, this.description, this.img});

  Cures.fromJson(Map<String, dynamic> json) {
    nameDisplay = json['name_display'];
    description = json['description'];
    img = json['img'];
  }
}
