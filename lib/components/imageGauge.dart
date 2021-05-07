import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tidey/const.dart';

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
                      style: GoogleFonts.notoSans(
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

class ImageGaugeNew extends StatelessWidget {
  final String imageName;
  final String textLabel;
  final Color textColor;
  final Color textBackgroundColor;
  final double fontSize;
  final int textPosition;
  final Color backgroundColor;
  final Color bezelColor;
  final double bezelWidth;
  final double imageInset;
  final Color innerLineColor;

  ImageGaugeNew(
      {this.imageName,
      this.textLabel = "",
      this.textColor = Colors.white,
      this.textBackgroundColor = Colors.transparent,
      this.fontSize = 24,
      this.textPosition = 67,
      this.backgroundColor = Colors.black,
      this.bezelColor = kBezelColor, // = Color(0xFF999999),
      this.bezelWidth = 5,
      this.imageInset = 30,
      this.innerLineColor = const Color(0xFF999999)});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
//          width: ScreenSize.gaugeSize,
//          height: ScreenSize.gaugeSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bezelColor,
          ),
        ),
        Positioned.fill(
          top: bezelWidth,
          right: bezelWidth,
          left: bezelWidth,
          bottom: bezelWidth,
          child: Container(
//            width: ScreenSize.gaugeSize,
//            height: ScreenSize.gaugeSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
          ),
        ),
        Positioned.fill(
          top: imageInset,
          right: imageInset,
          left: imageInset,
          bottom: imageInset,
          child: Container(
//            width: ScreenSize.gaugeSize,
//            height: ScreenSize.gaugeSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: innerLineColor,
            ),
          ),
        ),
        Positioned.fill(
          top: imageInset + 2,
          right: imageInset + 2,
          bottom: imageInset + 2,
          left: imageInset + 2,
          child: Container(
//            width: ScreenSize.gaugeSize,
//            height: ScreenSize.gaugeSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  //  image: NetworkImage('https://googleflutter.com/sample_image.jpg'),
                  image: AssetImage(
                    "assets/images/" + imageName,
                  ),
                  fit: (imageName == "sunset1.gif")
                      ? BoxFit.fill
                      : BoxFit.fitHeight),
            ),
          ),
        ),
        Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                    height: (ScreenSize.small)
                        ? (MediaQuery.of(context).orientation ==
                                Orientation.landscape)
                            ? ScreenSize.gaugeSize * (textPosition / 100)
                            : ScreenSize.gaugeSize *
                                (textPosition / 100) *
                                ScreenSize.fs
                        : (MediaQuery.of(context).orientation ==
                                Orientation.landscape)
                            ? ScreenSize.gaugeSize * (textPosition / 100)
                            : ScreenSize.gaugeSize * (textPosition / 100) * .8),
                Text(
                  textLabel,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSans(
                      color: textColor,
                      backgroundColor: textBackgroundColor,
                      fontWeight: FontWeight.w700,
                      fontSize: fontSize * ScreenSize.fs),
                ),
              ],
            ))
      ],
    );
  }
}
