import 'package:flutter/material.dart';
import 'package:rss_feed_app/helper/Constants.dart';
import 'package:rss_feed_app/helper/style.dart';
import 'package:rss_feed_app/helper/text_view.dart';
import 'package:rss_feed_app/ui/registration_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black26,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Form(
          key: _formKey,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    //  initialValue: socialLogin ? name[1] : null,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration(emailText),
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
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
                    controller: _passwordController,
                    //  initialValue: socialLogin ? name[1] : null,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration(passwordText),
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).nextFocus();
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return passwordErrorText;
                      } else {
                        return null;
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
                      onPressed: () {},
                      color: Colors.amber,
                      child: TextView(
                        loginText,
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationPage(),
                            ));
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
      ),
    );
  }
}
