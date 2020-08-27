import 'package:flutter/material.dart';

class DisclaimerPage extends StatefulWidget {
  DisclaimerPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DisclaimerPageState createState() => _DisclaimerPageState();
}

class _DisclaimerPageState extends State<DisclaimerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Virago',
              style: Theme.of(context).textTheme.headline1
            ),
            Text(
              'Welcome!',
            ),
            Text(
              'testing whats up'
            ),
          ],
        ),
      ),
    );
  }
}