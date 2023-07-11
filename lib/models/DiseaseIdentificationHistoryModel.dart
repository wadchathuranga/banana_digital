class DiseaseIdentificationHistoryModel {
  Disease? disease;
  String? leafColor;
  String? leafSpots;
  String? leafWilting;
  String? leafCurling;
  String? stuntedGrowth;
  String? stemColor;
  String? rootRot;
  String? abnormalFruiting;
  String? presenceOfPests;
  Object? probabilities;
  String? createdAt;

  DiseaseIdentificationHistoryModel(
      {this.disease,
        this.leafColor,
        this.leafSpots,
        this.leafWilting,
        this.leafCurling,
        this.stuntedGrowth,
        this.stemColor,
        this.rootRot,
        this.abnormalFruiting,
        this.presenceOfPests,
        this.probabilities,
        this.createdAt});

  DiseaseIdentificationHistoryModel.fromJson(Map<String, dynamic> json) {
    disease =
    json['disease'] != null ? Disease.fromJson(json['disease']) : null;
    leafColor = json['leaf_color'];
    leafSpots = json['leaf_spots'];
    leafWilting = json['leaf_wilting'];
    leafCurling = json['leaf_curling'];
    stuntedGrowth = json['stunted_growth'];
    stemColor = json['stem_color'];
    rootRot = json['root_rot'];
    abnormalFruiting = json['abnormal_fruiting'];
    presenceOfPests = json['presence_of_pests'];
    probabilities = json['probabilities'];
    createdAt = json['created_at'];
  }
}

class Disease {
  String? name;
  String? nameDisplay;
  String? img;
  String? description;
  String? symptomDescription;
  List<Cures>? cures;

  Disease(
      { this.name,
        this.nameDisplay,
        this.img,
        this.description,
        this.symptomDescription,
        this.cures});

  Disease.fromJson(Map<String, dynamic> json) {
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