import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rss_feed_app/helper/Constants.dart';

class RegistrationQueries {
  Future<void> register(registrationData, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .add(registrationData)
        .then((value) {
      showAlertDialogWithTwoButtonOkAndCancel(
          context, 'You registered sucessfully!! Now login with your credentials.', () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    });

  }
}


class EditProfileQuery{
  Future<void> editRegister(registrationData, email, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .catchError((e){
       print(e.toString());
    });
  }
}