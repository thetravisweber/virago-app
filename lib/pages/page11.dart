import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:virago/classes/Store.dart';
import 'package:virago/classes/FormofBirthControl.dart';
import 'package:virago/classes/Brand.dart';
import 'package:virago/classes/Symptom.dart';



class Page11 extends StatefulWidget {
  Page11({Key key}) : super(key: key);
  
  @override
  _Page11State createState() => _Page11State();
}

class _Page11State extends State<Page11> {


  @override
  Widget build(BuildContext context) {
    final _store = Store.of(context);
    final List<FormofBirthControl> forms = _store.usedFormsOfBirthControl;

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
    
    Future<Null> nextPage() async {
      for (FormofBirthControl form in forms) {
        _store.addUsedBrands(form.usedBrands());
      }

      _store.symptoms = await fetchSymptoms();

      Navigator.pushNamed(
        context, 
        'page12'
      );
    }

    

    return Scaffold(
      appBar: AppBar(
        title: Text('Please Select The Brands You have used before')
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      child: _buildBrandList(context, forms)
                    ),
                  ]
                )
              ),
              RaisedButton(
                onPressed: () {
                  nextPage();
                },
                child: Text(
                  "Next Page"
                ) 
              )
            ],
          ),
        )
      );
  } // Widget

  Widget _buildBrandList(BuildContext context, List<FormofBirthControl> forms) {
    final checkBoxChildren = List<Widget>();

    for (FormofBirthControl form in forms) {
      checkBoxChildren.add(Container(
        width: 400,
        child: Text(
            form.title,
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
        )
      );

      checkBoxChildren.add(
        Container(
          width: 400,
          margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
          child: Text(
            'Select Every brand of ' + form.title + ' that you have used',
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center,
          ),
        ),
      );


      for (Brand brand in form.brands) {
        checkBoxChildren.add(Container(
          width: 400,
          child: CheckboxListTile(
              title: Text(brand.title),
              value: brand.checked,
              onChanged: (bool value) {
                setState(() {
                  brand.checked = value;
                });
              },
            )
          )
        ); // add
      }
    }

    return Column(
        children: checkBoxChildren
      );
  }
}