import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart'; 

import 'package:virago/classes/Store.dart';
import 'package:virago/classes/Brand.dart';
import 'package:virago/classes/Symptom.dart';


class Page12 extends StatefulWidget {
  Page12({Key key}) : super(key: key);
  
  @override
  _Page12State createState() => _Page12State();
}

class _Page12State extends State<Page12> {


  @override
  Widget build(BuildContext context) {
    final _store = Store.of(context);
    final List<Brand> brands = _store.usedBrands;
    
    Future<Null> nextPage() async {

      Navigator.pushNamed(
        context, 
        'pagec'
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tell us how you felt about them')
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
                      child: _buildUsageList(context, brands)
                    ),
                  ]
                )
              ),
              RaisedButton(
                onPressed: () {
                  nextPage();
                },
                child: Text(
                  "Submit"
                ) 
              )
            ],
          ),
        )
      );
  } // Widget

  Widget _buildUsageList(BuildContext context, List<Brand> brands) {
    final reviewCards = List<Widget>();
    
    for (Brand brand in brands) {
      reviewCards.add(_reviewCard(context, brand));
    }

    return Column(
       children: reviewCards
    );
  }

  Widget _reviewCard(BuildContext context, Brand brand) {
    final _store = Store.of(context);
    final symptomsList = _store.symptoms;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 5,
        ),
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: 600,
      height: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            brand.title,
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
          _buildSymptomsInput(brand, symptomsList),
          SmoothStarRating(
            allowHalfRating: true,
            onRated: (v) {
            },
            starCount: 5,
            rating: 3,
            size: 55.0,
            isReadOnly: false,
            color: Colors.yellow,
            borderColor: Colors.black,
            spacing:0.0
          ),
          Container(
            width: 350,
            child: TextField(
              enableSuggestions: true,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                hintText: 'Leave A Review For ' + brand.title,
              ),
            )
          )
        ]
      )
    );
  }

  Widget _buildSymptomsInput(Brand brand, List<Symptom> symptomsList) {
    

    void _showMultiSelect(BuildContext context) async {
      await showDialog<Set<int>>(
        context: context,
        builder: (BuildContext context) {
          return MultiSelectDialog(
            symptoms: symptomsList,
            brand: brand
          );
        },
      );
    }

    return Column(
      children: <Widget>[
        RaisedButton(
          child: Text(brand.symptomString),
          onPressed: () {
            _showMultiSelect(context);
          }
        )
      ]
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  MultiSelectDialog({Key key, this.symptoms, this.brand}) : super(key: key);

  final List<Symptom> symptoms;
  final Brand brand;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {

  void _onItemCheckedChange(Brand brand, Symptom symptom, bool checked) {
    setState(() {
      if (checked) {
        brand.symptoms.add(symptom);
      } else {
        brand.symptoms.remove(symptom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> symptomSelectList = new List<Widget>();

    for (Symptom symptom in widget.symptoms) {
      symptomSelectList.add(_buildItem(widget.brand, symptom)); // add
    }


    return AlertDialog(
      title: Text('Select Side Effects'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: symptomSelectList,
          ),
        ),
      )
    );
  }

  Widget _buildItem(Brand brand, Symptom symptom) {
    final checked = brand.symptoms.contains(symptom);
    return CheckboxListTile(
      value: checked,
      title: Text(symptom.title),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(brand, symptom, checked),
    );
  }
}