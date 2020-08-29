import 'dart:html';

import 'package:flutter/material.dart';

class Page2 extends StatefulWidget {
  Page2({Key key}) : super(key: key);
  


  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  var checked = false;

  List<Widget> generateCheckBoxes() 
  {
    final children = <Widget>[];
    for (var i = 0; i < 5; i++) {
      children.add(Container(
        width: 400,
        child: CheckboxListTile(
          title: Text("test box" + i.toString()),
          value: checked,
          onChanged: (bool value) {
            setState(() {
              checked = value;
            });
          },
        )
      ));
    }
    return children;
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
            Column(
              children: generateCheckBoxes(),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'page9');
              },
              child: Text(
                "Next Page"
              ) 
            )
          ],
        ),
      ),
    );
  }
}