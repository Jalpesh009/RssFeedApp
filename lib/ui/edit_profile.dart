import 'package:flutter/material.dart';
import 'package:rss_feed_app/firebase/registration_queries.dart';
import 'package:rss_feed_app/helper/Constants.dart';
import 'package:rss_feed_app/helper/shared_data.dart';
import 'package:rss_feed_app/helper/style.dart';
import 'package:rss_feed_app/helper/text_view.dart';
import 'package:rss_feed_app/model/user_data.dart';

class EditProfile extends StatefulWidget {
  UserData userData;
  EditProfile(this.userData);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _nameController;
  TextEditingController _paypalIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  GlobalKey<FormState> _editProfile = new GlobalKey<FormState>();
  bool confirmPasswordVisible = true;
  bool passwordVisible = true;
  Map<String, dynamic> registrationData;
  String pass;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.userData.name);
    _paypalIdController =
        TextEditingController(text: widget.userData.paypal_id);
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _paypalIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: TextView(
          editProfileText,
          textColor: appWhiteColor,
          fontSize: 20,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _editProfile,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                        return paypalErrorText;
                      }
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    //  initialValue: socialLogin ? name[1] : null,
                    obscureText: passwordVisible,
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
                      labelStyle: TextStyle(color: appWhiteColor),
                      border: null,
                    ),
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
                    obscureText: confirmPasswordVisible,
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
                      labelStyle: TextStyle(color: appWhiteColor),
                      border: null,
                    ),
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
                    child: RaisedButton(
                      elevation: 0,
                      onPressed: () {
                        if (_editProfile.currentState.validate()) {
                          registrationData = {
                            'name': _nameController.text,
                            'paypal_id': _paypalIdController.text,
                            'password': _passwordController.text,
                          };

                          SharedData.isUserLoggedIn(true);
                          SharedData.saveUserPreferences(registrationData);
                          UserData userData = UserData.fromJson(registrationData);
                          EditProfileQuery().editRegister(
                              registrationData, widget.userData.email, context);
                          _nameController.clear();
                          _passwordController.clear();
                          _confirmPasswordController.clear();
                          _paypalIdController.clear();
                        }
                      },
                      color: appSplashColor,
                      child: TextView(
                        editProfileText,
                        textColor: appWhiteColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
