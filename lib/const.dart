import 'dart:convert';

import 'package:flutter/material.dart';

const kTextAndIconColor = Color(0xFFFFFFFF);
const kPrimaryTextColor = Color(0xFF212121);
const kSecondaryTextColor = Color(0xFF757575);
const kPrimaryColor = Colors.indigo;

const kClockTextStyle = TextStyle(
  fontSize: 45,
  color: kPrimaryTextColor,
);

const kClockTextSmallStyle = TextStyle(
  fontSize: 17,
  color: kPrimaryTextColor,
);

const kClockTrailerTextStyle = TextStyle(
  fontSize: 17,
  color: kPrimaryTextColor,
);

const kMySubTileData = [
  {
    "timeStamp": '3:08 PM',
    "tideHeight": '+ 1.65 ft',
    "tideRising": true,
    "today": true
  },
  {
    "timeStamp": '8:46 PM',
    "tideHeight": '- 1.65 ft',
    "tideRising": false,
    "today": true
  },
  {
    "timeStamp": '1:46 AM',
    "tideHeight": '+ 1.65 ft',
    "tideRising": true,
    "today": false
  },
  {
    "timeStamp": '8:14 AM',
    "tideHeight": '- 1.65 ft',
    "tideRising": false,
    "today": false
  },
];
