import 'package:flutter/material.dart';

import 'Constants.dart';

TextStyle simpleTextStyle() {
  return TextStyle(
    color: appTextColor,
    fontSize: 16,
  );
}

TextStyle buttonTextStyle() {
  return TextStyle(
    color: appBodyColor,
    fontSize: 16,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
      color: appBodyColor,
      width: 2,
    )),
    filled: true,
    fillColor: appYellowColor,
    errorStyle: TextStyle(fontSize: 9,color: appTextColor),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: appLightTextColor, width: 1)),
    hintStyle: TextStyle(fontSize: 12, color: appTextColor),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: appTextColor, width: 1)),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: appTextColor, width: 1)),
    hintText: hintText,
    alignLabelWithHint: true,
    labelText: hintText,
    labelStyle: TextStyle(
      color: appTextColor
    ),

    border: null,
  );
}



InputDecoration textFeildPasswordDecoration(String hintText) {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
      color: appBodyColor,
      width: 2,
    )),

    errorStyle: TextStyle(fontSize: 9,color: appBodyColor),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: appLightTextColor, width: 1)),
    hintStyle: TextStyle(fontSize: 12, color: appBodyColor),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: appBodyColor, width: 1)),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: appBodyColor, width: 1)),
    hintText: hintText,
    alignLabelWithHint: true,
    labelText: hintText,
    labelStyle: TextStyle(
      color: appBodyColor
    ),

    border: null,
  );
}
