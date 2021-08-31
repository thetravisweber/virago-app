import 'dart:io';

import 'package:flutter/material.dart';
import 'package:virago/WidgetClasses/PointPainter.dart';
import 'package:virago/classes/Brand.dart';
import 'package:virago/classes/Review.dart';
import 'package:virago/classes/Store.dart';
import 'package:virago/pages/page12.dart';


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
            SizedBox(
              height: 40,
              child: TextButton(
                child: Container(
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Sorted by: most popular",
                        style: Theme.of(context).textTheme.headline4
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 24.0,
                        semanticLabel: 'Select More',
                      ),
                    ]
                  ),
                ),
                onPressed: () {
                  
                }
              )
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    child: _buildBrands(context)
                  ),
                ]
              )
            ), 
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
      brandWidgets.add(_buildBrandCard(brand)); 
    });

    return Column(
      children: brandWidgets,
    );
  }

  Widget _buildBrandCard(Brand brand)
  {
    return Container(
      decoration: BoxDecoration(
        color: const Color(000000),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width:400,
        height:40,
        child: Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'home');
              },
              style: TextButton.styleFrom(
                minimumSize: Size(0, 10)
              ),
            child: Text(
                brand.title
              )
           ),
           Expanded(
            child: CustomPaint(
              painter: PointPainter(),
            ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'home');
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerRight,
                minimumSize: Size(0, 10)
              ),
              child: Row(
                children: [
                  Text(
                    brand.rating.toString()
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }

  Widget _buildWaitingLoader()
  {
    return Text("waiting", style: Theme.of(context).textTheme.headline6);
  }

  String _getPeriods(brandTitle) {
    String periods = "."*(80-(brandTitle.length*2.3).floor());
    return periods;
  }

}