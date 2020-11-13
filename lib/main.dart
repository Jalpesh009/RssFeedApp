import 'package:flutter/material.dart';
import 'package:rss_feed_app/ui/login_page.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.amberAccent,
      theme: ThemeData(
          primaryColor: Colors.amberAccent,
          primarySwatch: Colors.amber,
          backgroundColor: Colors.black
      ),
      home: LoginPage(),
    );
  }
}
