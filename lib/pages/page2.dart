import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:virago/classes/FormofBirthControl.dart';


class Page2 extends StatefulWidget {
  Page2({Key key}) : super(key: key);
  
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {


  @override
  Widget build(BuildContext context) {
    final List<FormofBirthControl> forms = ModalRoute.of(context).settings.arguments;
    
    Future<Null> nextPage() async {
      List formIds = new List();
      forms.forEach((form) => {
        if (form.checked) {
          formIds.add(form.id)
        }
      });

      if (formIds.length == 0) {
        return;
      }

      final response = await http.post(
        DotEnv().env['API_URL'] + '/list-forms',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(formIds)
      );

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
            Container(
              child: _buildCheckBoxList(context, forms)
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
      ),
    );
  } // Widget

  Widget _buildCheckBoxList(BuildContext context, List<FormofBirthControl> forms) {
    final checkBoxChildren = List<Widget>();

    for (FormofBirthControl form in forms) {
      checkBoxChildren.add(Container(
        width: 400,
        child: CheckboxListTile(
          title: Text(form.title),
          value: form.checked,
          onChanged: (bool value) {
            setState(() {
              form.checked = value;
            });
          },
        )
      ));
    }

    return Column(
      children: checkBoxChildren
    );
  }
}