import 'package:flutter/material.dart';
import 'package:virago/classes/FormofBirthControl.dart';
import 'package:virago/classes/Store.dart';


class ReviewPage extends StatefulWidget {
  ReviewPage({Key key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage>
{

  List<FormofBirthControl> _forms = [];
  int _renderKey = 0;
  bool _fetchingForms = false;

  Future<Null> _getForms(Store store) async {
    _fetchingForms = true;
    _forms = await store.getForms();
    setState(() {
      _renderKey++;
    });
  }
  
  @override
  Widget build(BuildContext context) 
  {
    final _store = Store.of(context);
    
    if (!_fetchingForms) {
      // _getForms(_store);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews")
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              'hello',
              style: Theme.of(context).textTheme.headline4,
            ),
            _buildBrandDropDowns(context, _forms)
          ]
        )
      ),
    );
  }

  Widget _buildBrandDropDowns(BuildContext context, List<FormofBirthControl> forms) 
  {
    if (forms.isEmpty) {
      return _buildWaiting(context);
    }

    List<Widget> formDropWidgets = List<Widget>();

    for (final form in forms) {
      formDropWidgets.add(_buildFormDropDown(form));
    }

    return Column(
      children: formDropWidgets,
    );
  }

  Widget _buildFormDropDown(FormofBirthControl form)
  { 
    return Text(
      form.title,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget _buildWaiting(context) {

    return Text('hi');

  }

}