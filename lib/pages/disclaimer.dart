import 'package:flutter/material.dart';

class DisclaimerPage extends StatefulWidget {
  DisclaimerPage({Key key}) : super(key: key);

  @override
  _DisclaimerPageState createState() => _DisclaimerPageState();
}

class _DisclaimerPageState extends State<DisclaimerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disclaimer")
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                'This is not medical advice and you should consult'
                ' your health care physician with any concerns or '
                ' questions, as well as before changing medication',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              width: 400,
              margin: const EdgeInsets.only(bottom: 20.0),
            ),
            RaisedButton(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              onPressed: () {
                Navigator.pushNamed(context, 'pagec');
              },
              child: Text(
                "I agree"
              ) 
            )
          ],
        ),
      ),
    );
  }
}