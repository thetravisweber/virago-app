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

  String testText = 'asdasdasdfafas';
  List<Widget> reviewCards;
  int renderKey = 0;

  @override
  Widget build(BuildContext context) {
    final _store = Store.of(context);
    final List<Brand> brands = _store.usedBrands;
    
    Future<Null> nextPage() async {

      for (Brand brand in brands) {
        brand.reportToServer();
      }


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

    void _showMultiSelect(BuildContext context) async {
      await showDialog<Set<int>>(
        context: context,
        builder: (BuildContext context) {
          return MultiSelectDialog(
            parentState: this,
            context: context,
            symptoms: symptomsList,
            brand: brand
          );
        },
      );

      setState(() {
        this.renderKey++;
      });
    }

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
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            brand.title,
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
          Column(
            children: <Widget>[
              OutlineButton(
                color: Colors.grey[50],
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                child: Container(
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildSymptomCards(context, brand),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 24.0,
                        semanticLabel: 'Select More',
                      ),
                    ]
                  ),
                ),
                onPressed: () {
                  _showMultiSelect(context);
                  setState(() {
                    renderKey++;
                  });
                }
              )
            ]
          ),
          
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
            width: 400,
            height: 200,
            child: TextField(
              maxLines: 10,
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

  Widget _buildSymptomCards(BuildContext context, Brand brand) {
    List<Widget> symptomCards = new List<Widget>();

    for (Symptom symptom in brand.symptoms) {
      symptomCards.add(_buildSymptomCard(context, brand, symptom));
    }

    if (symptomCards.length != 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 350,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: symptomCards
              )
            )
          )
        ]
      );
    } else {
      return Text('Pick Any Side Effects Experienced');
    }
  }

  Widget _buildSymptomCard(BuildContext context, Brand brand, Symptom symptom) {
    return Card(
      color: Colors.blue,
      child: Row(
        children: <Widget>[
          Text(
            symptom.title,
            style: TextStyle(
              color: Colors.black
            ),
            textAlign: TextAlign.center,
          ),
          ButtonTheme(
            minWidth: 20.0,
            child:
              FlatButton(
                onPressed: () {
                  brand.removeSymptom(symptom);
                  setState(() {
                    renderKey++;
                  });
                }, 
                child: Icon(
                Icons.clear,
                size: 24.0,
                semanticLabel: 'Delete Symptom',
              ),
            )
          )
        ]
      )
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  MultiSelectDialog({Key key, this.parentState, this.context, this.symptoms, this.brand}) : super(key: key);

  final _Page12State parentState;
  final BuildContext context;
  final List<Symptom> symptoms;
  final Brand brand;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState(parentState);

  bool updateShouldNotify(MultiSelectDialog dialog) => true;
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {

  _Page12State parent;
  _MultiSelectDialogState(this.parent);

  void onItemCheckedChange(BuildContext context, Brand brand, Symptom symptom, bool checked) {
    setState(() {
      if (checked) {
        brand.addSymptom(symptom);
      } else {
        brand.removeSymptom(symptom);
      }
    });

    parent.setState(() {
      parent.renderKey++;
    });
  }
  

  @override
  Widget build(BuildContext context) {

    List<Widget> symptomSelectList = new List<Widget>();

    for (Symptom symptom in widget.symptoms) {
      symptomSelectList.add(_buildItem(widget.context, widget.brand, symptom)); // add
    }

    void _onSubmitTap() {
      Navigator.pop(context);
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
      ),
      actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: _onSubmitTap,
          )
        ],
    );
  }

  Widget _buildItem(BuildContext context, Brand brand, Symptom symptom) {
    final checked = brand.symptoms.contains(symptom);
    return CheckboxListTile(
      value: checked,
      title: Text(symptom.title),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => onItemCheckedChange(context, brand, symptom, checked),
    );
  }
}