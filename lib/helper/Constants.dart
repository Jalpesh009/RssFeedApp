import 'package:flutter/material.dart';
import 'package:rss_feed_app/helper/text_view.dart';


Color appYellowColor = Color(0xffd2961e);

Color appTextColor = Colors.white;
Color appBackgroundColor = Color(0xffffff);
Color appBodyColor = Color(0xff0000);
Color appLightTextColor = Color.fromRGBO(170, 170, 170, 1);




// Strings
const rssFeedText = "Rss Feed";
const emailText = "Email";
const passwordText = "Password";
const nameText = "Name";
const phoneNumberText = "Phone Number";
const emailHintText = "Email";
const paypalIdText = "PayPal Email";
const confirmPasswordText = "Confirm Password";
const passwordErrorText =
    "Make combination password of 1 Upper case, 1 lowercase, 1 Numeric Number, 1 Special Character ";
const loginText = "LOGIN";
const signUpText = "SIGNUP";
const registerText = "R";
const signText = "Don't have an account ? Register";
const alreadyRegisterText = "Already have an account?";
const lastNameErrorText = "Please enter last name";
const nameErrorText = "Please enter first name";
const passwordNotNullText = "Please enter password";
const phoneNumberErrorText = "Phone number must be at least 10 numbers";
const emailErrorText = "Please enter valid email";
const paypalErrorText = "Please enter valid PayPal email";
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
const subjectText = 'RSS FEED Payment';
const adminEmailText = 'storydutyfirebase@gmail.com';
const adminEmailPassword = '3%6um%SEuz';
const mailSuccusefully = "Email Successufully send to Admin for your payment.";
const logOutDialogueText = 'Are you sure you want to logout?';

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
  return Container(
    color: appYellowColor,
    child: ListTile(
      focusColor: appYellowColor,
      selectedTileColor: appYellowColor,
      leading: icon,
      title: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: TextView(
              text,
              fontSize: 16,
              textColor: appTextColor,
            ),
          )
        ],
      ),
      onTap: onTap,
    ),
  );
}


showAlertDialogWithTwoButton(BuildContext context, String message,
    String okButtonText, VoidCallback ontap) {
  // set up the button
  Widget okButton = FlatButton(child: TextView(okButtonText), onPressed: ontap);
  Widget cancelButton = FlatButton(
      child: TextView(noText),
      onPressed: () {
        Navigator.pop(context);
      });

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: TextView(appTitle),
    content: TextView(message),
    actions: [okButton, cancelButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
