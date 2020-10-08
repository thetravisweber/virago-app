import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:virago/classes/Symptom.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

class Brand {
  final int id;
  final String title;
  String symptomString = "Please Select Any Side Effects";
  bool checked = false;
  bool edited = false;
  double rating = 3;
  List<Symptom> symptoms = new List<Symptom>();
  TextEditingController reviewController = new TextEditingController();
  

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

  void setStarRating(double rating) {
    this.edited = true;
    if (rating >= 0 && rating <= 5) {
      this.rating = rating;
    }
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

  bool isEdited() {
    if (this.symptoms.length > 0) {
      return true;
    }

    if (this.reviewController.text != "") {
      return true;
    }

    return this.edited;
  }

  Future<Null> leaveReview() async {

    final response = await http.post(
      DotEnv().env['API_URL'] + '/submit-review',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'brand_id': this.id,
        'review_rating': this.rating,
        'review_content': this.reviewController.text,
        'symptom_ids': this._symptomIds(),
      })
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return;

    } else {
      print("Bad Response");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  List<int> _symptomIds() {
    List<int> symptomIds = new List<int>();

    for (Symptom symptom in this.symptoms) {
      symptomIds.add(symptom.id);
    }

    return symptomIds;
  }
}