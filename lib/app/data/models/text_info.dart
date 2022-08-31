import 'package:flutter/material.dart';

class TextInfo {
  String text;
  Color color;
  FontWeight fontWeight;
  double fontSize;

  TextInfo({
    @required this.text,
    @required this.color,
    this.fontWeight,
    this.fontSize,
  });
}
