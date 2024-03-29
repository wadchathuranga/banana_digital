class BananaChatModel {
  int? chatIndex;
  dynamic response;
  bool? toCures;
  String? language;
  String? tag;
  List<Diseases>? diseases;

  BananaChatModel({this.chatIndex, this.toCures, this.response, this.language, this.tag, this.diseases});

  BananaChatModel.fromJson(Map<String, dynamic> json) {
    chatIndex = 1;
    toCures = json['toCures'];
    response = json['response'];
    language = json['language'];
    tag = json['tag'];
    if (json['diseases'] != null) {
      diseases = <Diseases>[];
      json['diseases'].forEach((v) {
        diseases!.add(Diseases.fromJson(v));
      });
    }
  }
}

class Diseases {
  int? id;
  String? nameDisplay;
  String? name;
  String? description;
  double? confidence;
  String? symptomDescriptionSinhala;
  String? symptomDescriptionEnglish;
  String? img;

  Diseases(
      {this.id,
        this.nameDisplay,
        this.name,
        this.description,
        this.confidence,
        this.symptomDescriptionSinhala,
        this.symptomDescriptionEnglish,
        this.img});

  Diseases.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameDisplay = json['name_display'];
    name = json['name'];
    description = json['description'];
    confidence = json['confidence'];
    symptomDescriptionSinhala = json['symptom_description_sinhala'];
    symptomDescriptionEnglish = json['symptom_description_english'];
    img = json['img'];
  }
}
