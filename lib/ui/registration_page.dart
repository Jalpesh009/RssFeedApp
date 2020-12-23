import 'package:flutter/material.dart';
import 'package:rss_feed_app/firebase/registration_queries.dart';
import 'package:rss_feed_app/helper/Constants.dart';
import 'package:rss_feed_app/helper/shared_data.dart';
import 'package:rss_feed_app/helper/style.dart';
import 'package:rss_feed_app/helper/text_view.dart';
import 'package:rss_feed_app/model/user_data.dart';

import 'home_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _paypalIdController = TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;

  Map<String, dynamic> registrationData;
  String pass;

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    _confirmPasswordController.dispose();
    _paypalIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: appTextMaroonColor),
        backgroundColor: appBackgroundColor,
        title: TextView(
          signUpText,
          textColor: appTextMaroonColor,
          fontSize: 21.6,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoCondensed',
        ),
      ),
      backgroundColor: appBackgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Opacity(
                  opacity: 0.7,
                  child: TextFormField(
                    controller: _nameController,
                    //  initialValue: socialLogin ? name[1] : null,
                    style: simpleTextStyleColor(appTextEditingColor),
                    decoration: textFieldInputDecorationColor(
                        nameText, appTextMaroonColor),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).nextFocus();
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return nameErrorText;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Opacity(
                  opacity: 0.7,
                  child: TextFormField(
                    controller: _phoneNumberController,
                    //  initialValue: socialLogin ? name[1] : null,
                    style: simpleTextStyleColor(appTextEditingColor),
                    maxLength: 10,
                    decoration: textFieldInputDecorationColor(
                        phoneNumberText, appTextMaroonColor),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).nextFocus();
                    },
                    validator: (value) {
                      if (value.length < 10 || value.length > 10) {
                        return phoneNumberErrorText;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Opacity(
                  opacity: 0.7,
                  child: TextFormField(
                    controller: _emailController,
                    //  initialValue: socialLogin ? name[1] : null,
                    style: simpleTextStyleColor(appTextEditingColor),
                    decoration: textFieldInputDecorationColor(
                        emailHintText, appTextMaroonColor),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).nextFocus();
                    },
                    validator: (value) {
                      if (RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return null;
                      } else {
                        return emailErrorText;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Opacity(
                  opacity: 0.7,
                  child: TextFormField(
                    controller: _paypalIdController,
                    //  initialValue: socialLogin ? name[1] : null,
                    style: simpleTextStyleColor(appTextEditingColor),
                    decoration: textFieldInputDecorationColor(
                        paypalIdText, appTextMaroonColor),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).nextFocus();
                    },
                    validator: (value) {
                      if (RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return null;
                      } else {
                        return paypalErrorText;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Opacity(
                  opacity: 0.7,
                  child: TextFormField(
                    controller: _passwordController,
                    //  initialValue: socialLogin ? name[1] : null,
                    style: simpleTextStyleColor(appTextEditingColor),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: appTextMaroonColor,
                        width: 2,
                      )),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                        icon: passwordVisible
                            ? Icon(
                                Icons.visibility,
                                color: appTextMaroonColor,
                              )
                            : Icon(
                                Icons.visibility_off,
                                color: appTextMaroonColor,
                              ),
                      ),
                      errorStyle:
                          TextStyle(fontSize: 9, color: appTextMaroonColor),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: appTextMaroonColor, width: 1)),
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: appTextMaroonColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: appTextMaroonColor, width: 1)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: appTextMaroonColor, width: 1)),
                      hintText: passwordText,
                      alignLabelWithHint: true,
                      labelText: passwordText,
                      labelStyle: TextStyle(color: appTextMaroonColor),
                      border: null,
                    ),
                    obscureText: passwordVisible,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).nextFocus();
                    },
                    validator: (value) {
                      pass = value;
                      if (value.isEmpty) {
                        return passwordNotNullText;
                      } else if (RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                          .hasMatch(value)) {
                        return null;
                      } else {
                        return passwordErrorText;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Opacity(
                  opacity: 0.7,
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    //  initialValue: socialLogin ? name[1] : null,
                    style: simpleTextStyleColor(appTextEditingColor),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: appTextMaroonColor,
                        width: 2,
                      )),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            confirmPasswordVisible = !confirmPasswordVisible;
                          });
                        },
                        icon: confirmPasswordVisible
                            ? Icon(
                                Icons.visibility,
                                color: appTextMaroonColor,
                              )
                            : Icon(
                                Icons.visibility_off,
                                color: appTextMaroonColor,
                              ),
                      ),
                      errorStyle:
                          TextStyle(fontSize: 9, color: appTextMaroonColor),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: appTextMaroonColor, width: 1)),
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: appTextMaroonColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: appTextMaroonColor, width: 1)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: appTextMaroonColor, width: 1)),
                      hintText: confirmPasswordText,
                      alignLabelWithHint: true,
                      labelText: confirmPasswordText,
                      labelStyle: TextStyle(color: appTextMaroonColor),
                      border: null,
                    ),
                    obscureText: confirmPasswordVisible,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).nextFocus();
                    },
                    validator: (value) {
                      if (value == pass) {
                        return null;
                      } else {
                        return confirmPasswordErrorText;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                RaisedButton(
                  elevation: 0,
                  child: TextView(
                    loginText,
                    fontSize: 18,
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.bold,
                  ),
                  color: appBackgroundColor,
                  textColor: appTextMaroonColor,
                  onPressed: () {
                    FocusManager.instance.primaryFocus.unfocus();
                    if (_formKey.currentState.validate()) {
                      registrationData = {
                        'name': _nameController.text,
                        'email': _emailController.text,
                        'phone_number': _phoneNumberController.text,
                        'paypal_id': _paypalIdController.text,
                        'password': _passwordController.text,
                        'coinCount': 0,
                        'listen_id': ""
                      };
                      RegistrationQueries().register(registrationData, context);

                      SharedData.isUserLoggedIn(true);
                      SharedData.saveUserPreferences(registrationData);
                      UserData userData = UserData.fromJson(registrationData);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => HomePage(userData)),
                          (Route<dynamic> route) => false);
                      _nameController.clear();
                      _emailController.clear();
                      _phoneNumberController.clear();
                      _paypalIdController.clear();
                      _passwordController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
