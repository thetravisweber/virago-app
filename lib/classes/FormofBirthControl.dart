import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:virago/classes/Brand.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FormofBirthControl {
  final int id;
  final String title;
  final int identifier;
  bool checked = false;
  List<Brand> brands = new List<Brand>();

  FormofBirthControl({this.id, this.title, this.identifier});

  factory FormofBirthControl.fromJson(Map<String, dynamic> json) {
    var rng = new Random();
    return FormofBirthControl(
      id: json['id'],
      title: json['name'],
      identifier: rng.nextInt(100)
    );
  }

  Future<Null> fetchBrands() async {
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

  List<Brand> usedBrands() {
    List<Brand> checkedBrands = new List<Brand>();
    for (Brand brand in this.brands) {
      if (brand.checked) {
        checkedBrands.add(brand);
      }
    }
    return checkedBrands;
  }
}