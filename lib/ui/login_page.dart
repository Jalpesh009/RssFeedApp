import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rss_feed_app/helper/Constants.dart';
import 'package:rss_feed_app/helper/shared_data.dart';
import 'package:rss_feed_app/helper/style.dart';
import 'package:rss_feed_app/helper/text_view.dart';
import 'package:rss_feed_app/model/user_data.dart';
import 'package:rss_feed_app/ui/home_page.dart';
import 'package:rss_feed_app/ui/registration_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool passwordVisible = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: appBackgroundColor,
      //   title: TextView(
      //     loginText,
      //     fontSize: 20,
      //     textColor: appTextMaroonColor,
      //   ),
      //   elevation: 0,
      // ),
      backgroundColor: appBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/story.png',
              height: 200,
              width: 100,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      controller: _emailController,
                      //  initialValue: socialLogin ? name[1] : null,
                      style: simpleTextStyleColor(appTextEditingColor),
                      decoration: textFieldInputDecorationColor(
                          emailText, appTextMaroonColor),
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
                      style: simpleTextStyleColor(appTextEditingColor),
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: appTextMaroonColor,
                          width: 1,
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
                            borderSide: BorderSide(
                                color: appTextMaroonColor, width: 1)),
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: appTextMaroonColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: appTextMaroonColor, width: 1)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: appTextMaroonColor, width: 1)),
                        hintText: passwordText,
                        alignLabelWithHint: true,
                        labelText: passwordText,
                        labelStyle: TextStyle(color: appTextMaroonColor),
                        border: null,
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).nextFocus();
                      },
                      validator: (value) {
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
                    SizedBox(
                      height: 16,
                    ),
                    RaisedButton(
                      elevation: 0,
                      child: TextView(
                        loginText,
                        fontSize: 18,
                        textColor: appTextMaroonColor,
                        fontFamily: 'RobotoCondensed-Bold',
                      ),
                      color: appBackgroundColor,
                      textColor: appTextMaroonColor,
                      onPressed: () {
                        FocusManager.instance.primaryFocus.unfocus();
                        if (_formKey.currentState.validate()) {
                          var data = FirebaseFirestore.instance
                              .collection('users')
                              .where('email', isEqualTo: _emailController.text)
                              .where('password',
                                  isEqualTo: _passwordController.text)
                              .getDocuments()
                              .then((value) {
                            if (value.docs.isNotEmpty) {
                              SharedData.isUserLoggedIn(true);
                              SharedData.saveUserPreferences(
                                  value.docs.first.data());
                              UserData userData =
                                  UserData.fromJson(value.docs.first.data());
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => HomePage(userData)),
                                  (Route<dynamic> route) => false);
                            } else {
                              showAlertDialogWithTwoButtonOkAndCancel(
                                  context, 'Invalid credentials.', () {
                                Navigator.pop(context);
                              });
                            }
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    /*Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Align(
                      alignment: Alignment.bottomCenter,child: Image.asset('assets/login_image.png',width: double.infinity,)),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 220),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Divider(
                                height: 1,
                                color: appTextColor,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextView(
                              alreadyRegisterText,
                              textColor: appTextColor,
                              fontSize: 20,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RegistrationPage(),
                                      ));
                                },
                                child: TextView(
                                  signUpText,
                                  textColor: appYellowColor,
                                  fontSize: 20,
                                )),
                          ],
                        ),
                      ))
                ],
              ),*/

                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegistrationPage(),
                                  ));
                            },
                            child: TextView(
                              registerText,
                              textColor: appTextRedColor,
                              fontSize: 18,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
