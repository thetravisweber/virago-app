import 'package:virago/classes/Symptom.dart';

class Brand {
  final int id;
  final String title;
  String symptomString = "Please Select Any Side Effects";
  bool checked = false;
  List<Symptom> symptoms = new List<Symptom>();

  Brand({this.id, this.title});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      title: json['name'],
    );
  }

  void addSymptom(Symptom symptom) {
    this.symptoms.add(symptom);
    this.symptomString = this._makeSymptomString();
  }

  String _makeSymptomString() {
    String results = "";

    for (Symptom symptom in this.symptoms) {
      results+=symptom.title + " ";
    }

    if (results == "") {
      results = "Please Select Any Side Effects";
    }

    return results;
  }
}