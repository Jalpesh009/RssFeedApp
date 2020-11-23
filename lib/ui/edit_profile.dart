import 'package:flutter/material.dart';
import 'package:rss_feed_app/firebase/registration_queries.dart';
import 'package:rss_feed_app/helper/Constants.dart';
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
  TextEditingController _nameController = TextEditingController();
  TextEditingController _paypalIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  GlobalKey<FormState> _editProfile = new GlobalKey<FormState>();
  Map<String, dynamic> registrationData;
  String pass;

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
      body: Form(
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
                controller: _passwordController,
                //  initialValue: socialLogin ? name[1] : null,
                style: simpleTextStyle(),
                decoration: textFieldInputDecoration(passwordText),
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
                decoration: textFieldInputDecoration(confirmPasswordText),
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
                        'password' : _passwordController.text,
                      };
                      RegistrationQueries().register(registrationData, context);
                      _nameController.clear();
                      _paypalIdController.clear();
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
            ],
          ),
        ),
      ),
    );
  }
}
