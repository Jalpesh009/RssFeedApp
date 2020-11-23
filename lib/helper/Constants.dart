import 'package:flutter/material.dart';
import 'package:rss_feed_app/helper/text_view.dart';

Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);
Color appGreyColor = Color.fromRGBO(64, 75, 96, .9);
Color appYellowColor = Color(0xffff6666);
Color appOrangeColor = Color(0xFFF55616);
Color appRedColor = Color(0xffe22323);
Color appWhiteColor = Color(0xffffffff);
Color appBlueColor = Color(0xff3366ff);
Color appOffWhiteColor = Colors.white54;
Color appTextColor = Color.fromRGBO(87, 87, 87, 1);
Color appLightTextColor = Color.fromRGBO(170, 170, 170, 1);
Color appGreenColor = Color(0xff4ba72b);
Color appBackgroundColor = Color(0xfff9f9f9);
Color lightTextColor = Color(0xffbbbaba);
Color lightGreyColor = Color(0xffb8b8b8);
Color appSplashWhiteColor = Color(0xfff2f2f2);
Color appSplashColor = Color(0xff4c2b36);

// Strings
const rssFeedText = "Rss Feed";
const emailText = "Email";
const passwordText = "Password";
const nameText = "Name";
const phoneNumberText = "Phone number";
const emailHintText = "email";
const paypalIdText = "Pay pal ID";
const confirmPasswordText = "Confirm Password";
const passwordErrorText =
    "Make combination password of 1 Upper case, 1 lowercase, 1 Numeric Number, 1 Special Character ";
const loginText = "Login";
const registerText = "Register";
const signUpText = "Don't have an account ? Sign up";
const lastNameErrorText = "Please enter last name";
const nameErrorText = "Please enter first name";
const emailErrorText = "Please enter valid email";
const payPalErrorText = "Please enter valid paypal ID";
const confirmPasswordErrorText =
    "Your confirm password is not match with password";
const cashOutText = "Cash Out";
const timeRemainingText = "Time Remaining";
const skipText = "Skip";
const pauseText = "Pause";
const playText = "Play";
const homeText = "Home";
const yesText = "Yes";
const okText = "Ok";
const noText = "No";
const appTitle = "Rss Feed App";
const lastPodCast = "This is last podcast";
const editProfileText = 'Edit Profile';
const logOutText = 'Log out';

// Chat username string
class Const {
  static String userId = "";
}

// SHARED PREFERENCE KEY
const userKey = "USER";
const isUserLoginKey = "LOGIN";
const loginTypeKey = "LOGINTYPE";

// Sizes
const bigRadius = 66.0;
const buttonHeight = 24.0;

// Half Screen Width
double screenWidth;

// Images
Image appLogo = Image.asset(
  'assets/slicing/logo.png',
  height: 100,
  width: 200,
);
Image appCountryFlag = Image.asset(
  'assets/slicing/uk_flag.jpg',
  height: 25,
  width: 41,
);

showAlertDialogWithTwoButtonOkAndCancel(
    BuildContext context, String message, VoidCallback ontap) {
  // set up the button
  Widget okButton = FlatButton(child: TextView(okText), onPressed: ontap);


  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Center(child: TextView(appTitle,fontSize: 20,)),
    content: TextView(message,fontSize: 16,),
    actions: [okButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Widget createDrawerItem(
    {Widget icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    leading: icon,
    title: Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: TextView(
            text,
            textColor: appWhiteColor,
          ),
        )
      ],
    ),
    onTap: onTap,
  );
}