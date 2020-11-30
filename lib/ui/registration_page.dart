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
        title: TextView(
          'Registration',
          textColor: appWhiteColor,
          fontSize: 20,
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _nameController,
                    //  initialValue: socialLogin ? name[1] : null,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration(nameText),
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
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _phoneNumberController,
                    //  initialValue: socialLogin ? name[1] : null,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration(phoneNumberText),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).nextFocus();
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return lastNameErrorText;
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _emailController,
                    //  initialValue: socialLogin ? name[1] : null,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration(emailHintText),
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
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _paypalIdController,
                    //  initialValue: socialLogin ? name[1] : null,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration(paypalIdText),
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
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    //  initialValue: socialLogin ? name[1] : null,
                    style: simpleTextStyle(),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: appWhiteColor,
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
                                color: appWhiteColor,
                              )
                            : Icon(
                                Icons.visibility_off,
                                color: appWhiteColor,
                              ),
                      ),
                      errorStyle: TextStyle(fontSize: 9, color: appWhiteColor),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: appLightTextColor, width: 1)),
                      hintStyle: TextStyle(fontSize: 12, color: appWhiteColor),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: appWhiteColor, width: 1)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: appWhiteColor, width: 1)),
                      hintText: passwordText,
                      alignLabelWithHint: true,
                      labelText: passwordText,
                      errorText: passwordErrorText,
                      labelStyle: TextStyle(color: appWhiteColor),
                      border: null,
                    ),
                    obscureText: passwordVisible,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).nextFocus();
                    },
                    validator: (value) {
                      pass = value;
                      if (RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                          .hasMatch(value)) {
                        return null;
                      } else {
                        return passwordErrorText;
                      }
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    //  initialValue: socialLogin ? name[1] : null,
                    style: simpleTextStyle(),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: appWhiteColor,
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
                                color: appWhiteColor,
                              )
                            : Icon(
                                Icons.visibility_off,
                                color: appWhiteColor,
                              ),
                      ),
                      errorStyle: TextStyle(fontSize: 9, color: appWhiteColor),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: appLightTextColor, width: 1)),
                      hintStyle: TextStyle(fontSize: 12, color: appWhiteColor),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: appWhiteColor, width: 1)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: appWhiteColor, width: 1)),
                      hintText: confirmPasswordText,
                      alignLabelWithHint: true,
                      labelText: confirmPasswordText,
                      errorText: confirmPasswordErrorText,
                      labelStyle: TextStyle(color: appWhiteColor),
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
                  SizedBox(
                    height: 16,
                  ),
                  ButtonTheme(
                    height: 50,
                    minWidth: (width / 2) - 20,
                    buttonColor: appRedColor,
                    child: RaisedButton(
                      elevation: 0,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          registrationData = {
                            'name': _nameController.text,
                            'email': _emailController.text,
                            'phone_number': _phoneNumberController.text,
                            'paypal_id': _paypalIdController.text,
                            'password': _passwordController.text,
                            'coinCount': 0
                          };
                          RegistrationQueries()
                              .register(registrationData, context);

                          SharedData.isUserLoggedIn(true);
                          SharedData.saveUserPreferences(registrationData);
                          UserData userData =
                              UserData.fromJson(registrationData);
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
                      color: appSplashColor,
                      child: TextView(
                        registerText,
                        textColor: appWhiteColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: TextView(
                        alreadyRegisterText,
                        textColor: appWhiteColor,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
