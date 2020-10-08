import 'dart:async';

import 'package:flutter/material.dart';

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
    final List<FormofBirthControl> forms = ModalRoute.of(context).settings.arguments;
    
    Future<Null> nextPage() async {
      List<Brand> usedBrands = new List<Brand>();
      for (FormofBirthControl form in forms) {
        usedBrands.addAll(form.usedBrands());
      }

      List<Symptom> symptoms = await _store.getSymptoms();

      Map arguments = {
          'symptoms': symptoms,
          'used_brands': usedBrands
        };

      Navigator.pushNamed(
        context, 
        'page12',
        arguments: arguments
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