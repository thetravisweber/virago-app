import 'package:flutter/material.dart';
import 'package:virago/classes/Brand.dart';
import 'package:virago/classes/Review.dart';
import 'package:virago/classes/Store.dart';


class ReviewPage extends StatefulWidget {
  ReviewPage({Key key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}



class _ReviewPageState extends State<ReviewPage>
{
  List<Brand> _brands = [];

  Future<Null> _getBrands(BuildContext context)
  {
    final Store _store = Store.of(context);
    _brands = await _store.getBrands();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews")
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              "Here is where the reviews go",
              style: Theme.of(context).textTheme.headline4
            ),
            _buildBrands(context)
          ]
        )
      )
    );
  }

  Widget _buildBrands(BuildContext context)
  {
    if (_brands.isEmpty) {
      _getBrands(context);
      return _buildWaitingLoader();
    }

    // going to have to actually render the brands later
    return Text("got Brands!!!");
  }

  Widget _buildWaitingLoader()
  {
    return Text("waiting", style: Theme.of(context).textTheme.headline6);
  }
}