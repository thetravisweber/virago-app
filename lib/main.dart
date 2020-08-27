import 'package:flutter/material.dart';
import 'package:virago/theme.dart';
import 'package:virago/pages/home.dart';
import 'package:virago/pages/disclaimer.dart';


void main() {
  runApp(Virago());
}

class Virago extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virago',
      theme: ViragoTheme(),
      home: MyHomePage(nextPage: 'Virago©'),
      routes: <String, WidgetBuilder> {
        'disclaimer' : (BuildContext context) => DisclaimerPage(title: 'second page')
      },
    );
  }
}
