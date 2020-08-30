import 'package:flutter/material.dart';
import 'package:virago/theme.dart';
import 'package:virago/pages/home.dart';
import 'package:virago/pages/disclaimer.dart';
import 'package:virago/pages/pagec.dart';
import 'package:virago/pages/page2.dart';
import 'package:flutter_config/flutter_config.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();

  runApp(Virago());
}

class Virago extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virago',
      theme: viragoTheme(),
      home: MyHomePage(),
      routes: <String, WidgetBuilder> {
        'disclaimer' : (BuildContext context) => DisclaimerPage(),
        'pagec' : (BuildContext context) => PageC(),
        'page2' : (BuildContext context) => Page2(),
        'home' : (BuildContext context) => MyHomePage(),
      },
    );
  }
}
