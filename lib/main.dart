import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rss_feed_app/ui/home_page.dart';
import 'package:rss_feed_app/ui/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.length == 0) {
    Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.amberAccent,
      theme: ThemeData(
          primaryColor: Colors.amberAccent,
          primarySwatch: Colors.amber,
          backgroundColor: Colors.black),
      home: HomePage('uOiW2CxjXj2eR5sEotTf'),
    );
  }
}
