import 'package:flutter/material.dart';

class ImageGauge extends StatelessWidget {
  final String imageName;
  final String textLabel;
  final Color textColor;
  final Color textBackgroundColor;
  final double fontSize;
  final int textPosition;
  ImageGauge(
      {this.imageName,
      this.textLabel,
      this.textColor = Colors.white,
      this.textBackgroundColor = Colors.white30,
      this.fontSize = 24,
      this.textPosition = 67});
  static const double myWidth = 300;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: myWidth,
        height: myWidth,
        child: Stack(
          children: <Widget>[
            Image.asset(
              "assets/images/" + imageName,
//            width: MediaQuery.of(context).size.width / 2.5,
//            height: MediaQuery.of(context).size.width / 2.5,
            ),
            Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(height: myWidth * (textPosition / 100)),
                    Text(
                      textLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: textColor,
                          backgroundColor: textBackgroundColor,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
