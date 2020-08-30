import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';


class Page2 extends StatefulWidget {
  Page2({Key key}) : super(key: key);
  


  @override
  _Page2State createState() => _Page2State();
}

class FormofBirthControl {
  final int id;
  final String title;

  FormofBirthControl({this.id, this.title});

  factory FormofBirthControl.fromJson(Map<String, dynamic> json) {
    return FormofBirthControl(
      id: json['id'],
      title: json['name'],
    );
  }
}

class _Page2State extends State<Page2> {
  var checked = false;

  Future<List<FormofBirthControl>> fetchForms() async {
    final response = await http.get(FlutterConfig.get('API_URL') + '/list-forms');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = json.decode(response.body);
      var list = new List(data.length);
      for (var i = 0; i < list.length; i++) {
        list[i] = FormofBirthControl.fromJson(data[i]);
      }

      return list;

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  Widget[] generateCheckBoxes() async
  {
    final forms = await fetchForms();

    final children = List<Widget>();

    for (var form in forms) {
      children.add(Container(
        width: 400,
        child: CheckboxListTile(
          title: Text("test box"),
          value: checked,
          onChanged: (bool value) {
            setState(() {
              checked = value;
            });
          },
        )
      ));
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Use')
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 400,
              child: Text(
                'Which Form(s) have you used?',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 400,
              margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: Text(
                'Select one or more',
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: generateCheckBoxes(),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'page9');
              },
              child: Text(
                "Next Page"
              ) 
            )
          ],
        ),
      ),
    );
  }
}