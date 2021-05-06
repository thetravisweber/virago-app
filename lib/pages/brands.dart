import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart'; 

import 'package:virago/classes/Store.dart';
import 'package:virago/classes/Brand.dart';
import 'package:virago/classes/FormofBirthControl.dart';
// import 'package:virago/classes/Symptom.dart';
// import 'package:virago/classes/Review.dart';

class BrandsPage extends StatefulWidget {
  BrandsPage({Key key}) : super(key: key);

  @override
  _BrandsPageState createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  List<Brand> brands = new List<Brand>();
  List<FormofBirthControl> forms = new List<FormofBirthControl>();
  int renderKey = 0;

  Future<Null> fetchBrands() async {
    final response = await http.get(DotEnv().env['API_URL'] + '/list-brands');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = json.decode(response.body);
      for (var i = 0; i < data.length; i++) {
        brands.add(Brand.fromJson(data[i]));
      }

      setState(() {
        renderKey++;
      });

    } else {
      print("Bad Response");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  Future<Null> fetchForms() async {
    final _store = Store.of(context);
    if (forms.isEmpty) {
      forms = await _store.getForms();
      setState(() {
        renderKey++;
      });
    }
  }

  Future<Null> fetchBrandsByType() async {
    final response = await http.get(DotEnv().env['API_URL'] + '/list-brands');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = json.decode(response.body);
      for (var i = 0; i < data.length; i++) {
        brands.add(Brand.fromJson(data[i]));
      }

      setState(() {
        renderKey++;
      });

    } else {
      print("Bad Response");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check out our Data!')
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //_buildFormDropDown(context, forms),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      child: _buildBrandList(context, brands)
                    ),
                  ]
                )
              ),
            ],
          ),
        )
      );
  }

  Widget _buildBrandList(context, brands) {
    
    if (brands.length == 0) {
      fetchBrands();
      
      print('no data');

      return _buildWaiting(context);

    }


    List<Widget> _brandWidgets = new List<Widget>();

    for (var i = 0; i < brands.length; i++) {
      _brandWidgets.add(_buildBrand(context, brands[i]));
    }


    return Column(children: _brandWidgets,);
  }

  Widget _buildWaiting(context) {

    AnimationController _animatorController = new AnimationController();

    final _colorTween = _animatorController.drive(
      ColorTween(
        begin: Colors.yellow,
        end: Colors.blue
      )
    );

    return CircularProgressIndicator(
      valueColor: _colorTween
    );

  }

  Widget _buildBrand(context, Brand brand) {
    return Container(
      height: 300,
      width: 600,
      child: Column(
        children: <Widget>[
          Text(
            brand.title,
            style: Theme.of(context).textTheme.headline4,
          ),
          SmoothStarRating(
            allowHalfRating: true,
            starCount: 5,
            rating: brand.rating,
            size: 55.0,
            isReadOnly: true,
            color: Colors.yellow,
            borderColor: Colors.black,
            spacing:0.0
          ),
          FlatButton(
            onPressed: () => {
              Navigator.pushNamed(
                context, 
                'brand',
                arguments: {
                  'brand_id': brand.id
                }
              )
            },
            child: Text('Learn more')
          )
        ],
      ),
    );
  }

  Widget _buildFormDropDown(BuildContext context, List<FormofBirthControl> forms) {
    int _selectedFormId = 0;
    if (forms.isEmpty) {
      fetchForms();
      return _buildWaiting(context);
    } else {
      return DropdownButton<int>(
        value: _selectedFormId,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (int newValue) {
          setState(() {
            _selectedFormId = newValue.toInt();
          });
        },
        items: <int>[1, 2, 3, 4]
            .map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
      );
    }
    
  }
}