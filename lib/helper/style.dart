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
    color: appWhiteColor,
    fontSize: 16,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
      color: appLightTextColor,
      width: 2,
    )),
    errorStyle: TextStyle(fontSize: 9),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: appLightTextColor, width: 1)),
    hintStyle: TextStyle(fontSize: 12, color: appWhiteColor),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: appLightTextColor, width: 1)),
    hintText: hintText,
    alignLabelWithHint: true,
    labelText: hintText,
    labelStyle: TextStyle(
      color: appWhiteColor
    ),
    border: null,
  );
}
