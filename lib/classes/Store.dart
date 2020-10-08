import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:virago/classes/FormofBirthControl.dart';
import 'package:virago/classes/Symptom.dart';


class Store extends Model {
  List<FormofBirthControl> _forms = new List<FormofBirthControl>();
  List<Symptom> _symptoms = new List<Symptom>();

  static Store of(BuildContext context) => 
      ScopedModel.of<Store>(context);

  Future<List<Symptom>> getSymptoms() async {
    if (this._symptoms.length > 0) {
      return this._symptoms;
    }

    this._symptoms = await this.fetchSymptoms();
    return this._symptoms;
  }

  Future<List<FormofBirthControl>> getForms() async {
    if (this._forms.length > 0) {
      return this._forms;
    }

    this._forms = await this.fetchForms();
    return this._forms;
  }

  Future<List<Symptom>> fetchSymptoms() async {
    final response = await http.get(DotEnv().env['API_URL'] + '/list-symptoms');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<Symptom> symptoms = new List<Symptom>();

      var data = json.decode(response.body);
      for (var i = 0; i < data.length; i++) {
        symptoms.add(Symptom.fromJson(data[i]));
      }

      return symptoms;

    } else {
      print("Bad Response");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  Future<List<FormofBirthControl>> fetchForms() async {
    final response = await http.get(DotEnv().env['API_URL'] + '/list-forms');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = json.decode(response.body);
      var list = List<FormofBirthControl>();
      for (var i = 0; i < data.length; i++) {
        list.add(FormofBirthControl.fromJson(data[i]));
      }

      return list;

    } else {
      print("Bad Response");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

}