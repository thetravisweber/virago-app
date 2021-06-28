import 'package:flutter/material.dart';
import 'package:virago/classes/Review.dart';


class ReviewPage extends StatefulWidget {
  ReviewPage({Key key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}



class _ReviewPageState extends State<ReviewPage>
{

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
            _buildReviews()
          ]
        )
      )
    );
  }

  Widget _buildReviews()
  {
    // List<Review> _reviews = 
    return Text("uncomment the thing above");
  }
}