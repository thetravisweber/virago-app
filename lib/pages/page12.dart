import 'dart:async';
import 'dart:ui';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart'; 
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:virago/classes/Brand.dart';
import 'package:virago/classes/Symptom.dart';
import 'package:virago/classes/Review.dart';


class Page12 extends StatefulWidget {
  Page12({Key key}) : super(key: key);
  
  @override
  _Page12State createState() => _Page12State();
}

class _Page12State extends State<Page12> {

  List<Widget> reviewCards;
  int renderKey = 0;

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments;
    final List<Brand> brands = arguments['used_brands'];
    final List<Symptom> symptoms = arguments['symptoms'];
    bool confirmedSubmit = false;

    Future<List<Review>> fetchReviews() async {
      final response = await http.get(DotEnv().env['API_URL'] + '/list-reviews');

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        List<Review> reviews = new List<Review>();

        var data = json.decode(response.body);
        for (var i = 0; i < data.length; i++) {
          reviews.add(Review.fromJson(data[i]));
        }

        return reviews;

      } else {
        print("Bad Response");
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load data');
      }
    }
    
    Future<Null> nextPage() async {

      List<Brand> editedBrands = new List<Brand>();

      for (Brand brand in brands) {
        if (brand.isEdited()) {
          editedBrands.add(brand);
        }
      }
      
      if (editedBrands.length == brands.length) {
        confirmedSubmit = true;
      }

      if (!confirmedSubmit) {
        showDialog(
          context: context, 
          builder: (_) => new AlertDialog(
            title: Text('You have not reviewed all the brands you have used.'),
            content: Column(
              children: <Widget>[
                Text("are you sure you want to proceed?")
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Continue'),
                onPressed: () {
                  confirmedSubmit = true;
                  Navigator.of(context).pop();
                  nextPage();
                },
              ),
            ],
          ),
          barrierDismissible: false
        );
      } else {
        for (Brand brand in editedBrands) {
          await brand.leaveReview();
        }

        List<Review> reviews = await fetchReviews();

        Map pageData = {
          'reviews': reviews
        };

        print(reviews);

        Navigator.pushNamed(
          context, 
          'reviews',
          arguments: pageData
        );
      }
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
                      child: _buildUsageList(context, brands, symptoms)
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

  Widget _buildUsageList(BuildContext context, List<Brand> brands, List<Symptom> symptoms) {
    final reviewCards = List<Widget>();
    
    for (Brand brand in brands) {
      reviewCards.add(_reviewCard(context, brand, symptoms));
    }

    return Column(
       children: reviewCards
    );
  }

  Widget _reviewCard(BuildContext context, Brand brand, List<Symptom> symptomsList) {

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
              brand.setStarRating(v);
            },
            starCount: 5,
            rating: brand.rating,
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
              controller: brand.reviewController,
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