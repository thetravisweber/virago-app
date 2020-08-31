import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:virago/classes/FormofBirthControl.dart';

class PageC extends StatefulWidget {
  PageC({Key key}) : super(key: key);


  @override
  _PageCState createState() => _PageCState();
}

class _PageCState extends State<PageC> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Previous Use")
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 400,
              child: Text(
                'First, have you used any form of contraceptive'
                ' (birth control) before?',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
            ),
            RaisedButton(
              onPressed: () async {
                List<FormofBirthControl> forms = await fetchForms();
                Navigator.pushNamed(
                  context, 
                  'page2',
                  arguments: forms
                );
              },
              child: Text(
                "YES"
              ) 
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: Text(
                "NO"
              ) 
            )
          ],
        ),
      ),
    );
  }
}