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
          context, 'You registered sucessfully!!', () {});
    });
  }
}

class EditProfileQuery {
  Future<void> editRegister(
      registrationData, email, BuildContext context) async {
    String docId;
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments()
        .then((value) {
      docId = value.docs.first.documentID;
      FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
          .update(registrationData)
          .then((value) {
        showAlertDialogWithTwoButtonOkAndCancel(
            context, 'Profile edited successfully.', () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      });
    });
  }
}
