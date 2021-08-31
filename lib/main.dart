import 'package:flutter/material.dart';
import 'package:virago/theme.dart';
import 'package:virago/pages/home.dart';
import 'package:virago/pages/disclaimer.dart';
import 'package:virago/pages/pagec.dart';
import 'package:virago/pages/page2.dart';
import 'package:virago/pages/page11.dart';
import 'package:virago/pages/page12.dart';
import 'package:virago/pages/ReviewPage.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:scoped_model/scoped_model.dart';
import 'package:virago/classes/Store.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DotEnv.load(fileName: '.env');

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
          home: ReviewPage(),
          routes: <String, WidgetBuilder> {
            'home' : (BuildContext context) => MyHomePage(),
            'disclaimer' : (BuildContext context) => DisclaimerPage(),
            'pagec' : (BuildContext context) => PageC(),
            'page2' : (BuildContext context) => Page2(),
            'page11' : (BuildContext context) => Page11(),
            'page12' : (BuildContext context) => Page12(),
            
            'reviews' : (BuildContext context) => ReviewPage(),
          },
        )
      );
  }
}
