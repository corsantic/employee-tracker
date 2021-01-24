import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({Key key}) : super(key: key);

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    // print(Offset(0.0, -1.0).distanceSquared - Offset(0.0, 0.0).distanceSquared);
    final logoWidth = MediaQuery.of(context).size.width / 3;
    //// print("ARINTEL LOGO SIZE $logoWidth");
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GlowingProgressIndicator(
              child: IconButton(
                // onPressed: () {},
                tooltip: "Hey There!",
                iconSize: logoWidth,
                icon: Icon(Icons.ac_unit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
