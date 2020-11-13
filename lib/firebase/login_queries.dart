import 'package:cloud_firestore/cloud_firestore.dart';

class LoginQueries {
  Future<void> login(String email, String password) async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email',isEqualTo: email)
        .where('password', isEqualTo: password)
        .getDocuments();
  }
}