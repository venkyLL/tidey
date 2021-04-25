import 'dart:math';
import 'package:flutter/material.dart';

class DrawingTools {
  void drawRing(
      centerX, centerY, inputRadius, borderThickness, myPaint, canvas) {
    double radius = inputRadius;
    print("myRingRadius is $radius, $inputRadius");
    double width = borderThickness;
    double radius1 = radius - width;
    var myPath = Path();
    int startAngle = 0;
    int myAngle = 0;
    int i;
    num degToRad(num deg) => deg * (3.14159 / 180.0);
    print(
        "in draw ring with $centerX,$centerY,$radius,$borderThickness $myPaint, $canvas");
    myPath.moveTo(sin(degToRad(startAngle)) * radius + centerX,
        centerY - cos(degToRad(startAngle)) * radius);
    for (i = 0; i <= 360; i++) {
      myAngle = i;
      myPath.lineTo(sin(degToRad(myAngle)) * radius + centerX,
          centerY - cos(degToRad(myAngle)) * radius);
    }
    myPath.moveTo(sin(degToRad(myAngle)) * radius1 + centerX,
        centerY - cos(degToRad(myAngle)) * radius1);
    for (i = 0; i <= 360; i++) {
      myAngle = 360 - i;
      myPath.lineTo(sin(degToRad(myAngle)) * radius1 + centerX,
          centerY - cos(degToRad(myAngle)) * radius1);
    }
    myPath.lineTo(sin(degToRad(startAngle)) * radius + centerX,
        centerY - cos(degToRad(startAngle)) * radius);
    canvas.drawPath(myPath, myPaint);
  }

  void drawFilledCircle(centerX, centerY, radius, paint, canvas) {
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);
  }
}
