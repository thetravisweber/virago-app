import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
              style: Theme.of(context).textTheme.caption
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'disclaimer');
              },
              child: Text(
                "Get Started"
              ) 
            )
          ],
        ),
      ),
    );
  }
}