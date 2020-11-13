import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationQueries {
  Future<void> register(registrationData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .add(registrationData)
        .catchError((e) {
      print(e.toString());
    });
  }
}
