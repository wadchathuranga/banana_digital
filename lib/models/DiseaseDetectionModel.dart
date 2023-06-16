class DiseaseDetectionModel {
  List<Probabilities>? probabilities;
  String? originalImgUrl;
  String? detectedImgUrl;
  String? error;
  Disease? disease;
  String? createdAt;

  DiseaseDetectionModel({
        this.probabilities,
        this.originalImgUrl,
        this.detectedImgUrl,
        this.error,
        this.disease,
        this.createdAt});

  DiseaseDetectionModel.fromJson(Map<String, dynamic> json) {
    if (json['probabilities'] != null) {
      probabilities = <Probabilities>[];
      json['probabilities'].forEach((v) {
        probabilities!.add(Probabilities.fromJson(v));
      });
    }
    originalImgUrl = json['original_img_url'];
    detectedImgUrl = json['detected_img_url'];
    error = json['error'];
    disease = json['disease'] != null ? Disease.fromJson(json['disease']) : null;
    createdAt = json['created_at'];
  }
}

class Probabilities {
  String? diseaseName;
  String? avgConfidence;
  int? totalArea;

  Probabilities({this.diseaseName, this.avgConfidence, this.totalArea});

  Probabilities.fromJson(Map<String, dynamic> json) {
    diseaseName = json['disease_name'];
    avgConfidence = json['avg_confidence'];
    totalArea = json['total_area'];
  }
}

class Disease {
  int? id;
  List<Cures>? cures;
  String? img;
  String? nameDisplay;
  String? name;
  String? description;

  Disease(
      {this.id,
        this.cures,
        this.img,
        this.nameDisplay,
        this.name,
        this.description});

  Disease.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['cures'] != null) {
      cures = <Cures>[];
      json['cures'].forEach((v) {
        cures!.add(Cures.fromJson(v));
      });
    }
    img = json['img'];
    nameDisplay = json['name_display'];
    name = json['name'];
    description = json['description'];
  }
}

class Cures {
  int? id;
  String? name;
  String? description;
  String? img;
  int? disease;

  Cures({this.id, this.name, this.description, this.img, this.disease});

  Cures.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    img = json['img'];
    disease = json['disease'];
  }
}