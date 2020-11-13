import 'package:flutter/material.dart';

class TextView extends StatelessWidget {
  String data;
  TextAlign textAlign;
  TextOverflow textOverflow;
  int maxLines;
  Color textColor;
  Color backgroundColor;
  double fontSize;
  FontWeight fontWeight;
  FontStyle fontStyle;
  double letterSpacing;
  double wordSpacing;
  List<Shadow> shadows;
  TextDecoration textDecoration;
  String fontFamily;

  TextView(this.data,
      {this.textAlign,
      this.textOverflow,
      this.maxLines,
      this.textColor,
      this.backgroundColor,
      this.fontSize = 14.0,
      this.fontWeight,
      this.fontStyle,
      this.letterSpacing,
      this.wordSpacing,
      this.shadows,
      this.textDecoration,
      this.fontFamily = 'Poppins-Regular'});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: maxLines,
      style: TextStyle(
        color: textColor,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        shadows: shadows,
        decoration: textDecoration,
        fontFamily: fontFamily,
      ),
    );
  }
}
