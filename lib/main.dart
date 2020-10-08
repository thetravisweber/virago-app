import 'package:flutter/material.dart';
import 'package:virago/theme.dart';
import 'package:virago/pages/home.dart';
import 'package:virago/pages/disclaimer.dart';
import 'package:virago/pages/pagec.dart';
import 'package:virago/pages/page2.dart';
import 'package:virago/pages/page11.dart';
import 'package:virago/pages/page12.dart';
import 'package:virago/pages/brands.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virago/classes/Store.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("Loading dotenv file");
  await DotEnv().load('.env');
  print("Done Loading Env Variables");

  runApp(Virago());
}

class Virago extends StatelessWidget {
  // This widget is the root of your application.

  Widget build(BuildContext context) {
    final Store _model = Store();

    return ScopedModel<Store>(
        model: _model,
        child: MaterialApp(
          title: 'Virago',
          theme: viragoTheme(),
          home: MyHomePage(),
          routes: <String, WidgetBuilder> {
            'disclaimer' : (BuildContext context) => DisclaimerPage(),
            'pagec' : (BuildContext context) => PageC(),
            'page2' : (BuildContext context) => Page2(),
            'page11' : (BuildContext context) => Page11(),
            'page12' : (BuildContext context) => Page12(),
            'home' : (BuildContext context) => MyHomePage(),
            'reviews' : (BuildContext context) => BrandsPage(),
          },
        )
      );
  }

  // @override
  // Widget build(BuildContext context) {

  //   return MaterialApp(
  //     title: 'Virago',
  //     theme: viragoTheme(),
  //     home: MyHomePage(),
  //     routes: <String, WidgetBuilder> {
  //       'disclaimer' : (BuildContext context) => DisclaimerPage(),
  //       'pagec' : (BuildContext context) => PageC(),
  //       'page2' : (BuildContext context) => Page2(),
  //       'home' : (BuildContext context) => MyHomePage(),
  //     },
  //   );
  // }
}
