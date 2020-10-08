import 'package:flutter/material.dart';
import 'package:virago/classes/Store.dart';
import 'package:virago/classes/FormofBirthControl.dart';

class PageC extends StatefulWidget {
  PageC({Key key}) : super(key: key);


  @override
  _PageCState createState() => _PageCState();
}

class _PageCState extends State<PageC> {

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
                var _store = Store.of(context);
                List<FormofBirthControl> forms = await _store.getForms();
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