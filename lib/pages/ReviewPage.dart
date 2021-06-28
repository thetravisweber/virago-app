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

  Future<Null> _getBrands(BuildContext context) async
  {
    final Store _store = Store.of(context);
    List<Brand> brands = await _store.getBrands();
    setState(() {
      _brands = brands;
    });
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

    List<Widget> brandWidgets = [];
    _brands.forEach((brand) { 
      brandWidgets.add(_buildBrand(brand)); 
    });
    return Column(
      children: brandWidgets,
    );
  }

  Widget _buildBrand(Brand brand)
  {
    return Text(brand.title);
  }

  Widget _buildWaitingLoader()
  {
    return Text("waiting", style: Theme.of(context).textTheme.headline6);
  }
}