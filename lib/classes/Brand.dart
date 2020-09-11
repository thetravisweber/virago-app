import 'dart:math';
import 'dart:convert';

import 'package:virago/classes/Symptom.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  void removeSymptom(Symptom symptom) {
    this.symptoms.remove(symptom);
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

  void reportToServer() async {
    final response = await http.post(
      DotEnv().env['API_URL'] + '/list-brands-by-type',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'type_id': this.id
      })
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = json.decode(response.body);
      for (var i = 0; i < data.length; i++) {
        this.brands.add(Brand.fromJson(data[i]));
      }

    } else {
      print("Bad Response");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }
}