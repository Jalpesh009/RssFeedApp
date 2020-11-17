import 'package:flutter/material.dart';
import 'package:rss_feed_app/firebase/registration_queries.dart';
import 'package:rss_feed_app/helper/Constants.dart';
import 'package:rss_feed_app/helper/style.dart';
import 'package:rss_feed_app/helper/text_view.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController= TextEditingController();
  TextEditingController _emailController= TextEditingController();
  TextEditingController _phoneNumberController= TextEditingController();
  TextEditingController _confirmPasswordController= TextEditingController();
  TextEditingController _paypalIdController= TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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
      backgroundColor: Colors.black,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  //  initialValue: socialLogin ? name[1] : null,
                  style: simpleTextStyle(),
                  decoration: textFieldInputDecoration(nameText),
                  textCapitalization: TextCapitalization.sentences,
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
                  textCapitalization: TextCapitalization.sentences,

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
                  textCapitalization: TextCapitalization.sentences,

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
                  textCapitalization: TextCapitalization.sentences,

                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).nextFocus();
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return payPalErrorText;
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
                  textCapitalization: TextCapitalization.sentences,

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
                  textCapitalization: TextCapitalization.sentences,

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
                     if( _formKey.currentState.validate()){
                       registrationData = {
                         'name' : _nameController.text,
                          'email' : _emailController.text,
                         'phone_number' : _phoneNumberController.text,
                         'paypal_id' : _paypalIdController.text,
                         'password' : _passwordController.text,
                       };
                       RegistrationQueries().register(registrationData, context);
                       _nameController.clear();
                       _emailController.clear();
                       _phoneNumberController.clear();
                       _paypalIdController.clear();
                       _passwordController.clear();
                     }
                    },
                    color: Colors.amber,
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
                      signUpText,
                      textColor: appWhiteColor,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
