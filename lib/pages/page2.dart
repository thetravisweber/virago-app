import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:virago/classes/FormofBirthControl.dart';
import 'package:virago/classes/Store.dart';


class Page2 extends StatefulWidget {
  Page2({Key key}) : super(key: key);
  
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {


  @override
  Widget build(BuildContext context) {
    final List<FormofBirthControl> forms = ModalRoute.of(context).settings.arguments;
    Store _store = Store.of(context);
    
    Future<Null> nextPage() async {
      int checkedCount = 0;
      for (FormofBirthControl form in forms) {
        if (form.checked) {
          checkedCount++;

          await form.fetchBrands();

          _store.addUsedForm(form);
        }
      }

      if (checkedCount == 0) {
        return;
      }

      Navigator.pushNamed(
        context, 
        'page11'
      );

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