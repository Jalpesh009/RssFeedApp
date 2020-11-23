import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rss_feed_app/helper/shared_data.dart';
import 'package:rss_feed_app/ui/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (Firebase.apps.length == 0) {
    await Firebase.initializeApp();
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
      home: GetData(),
    );
  }
}

class GetData extends StatefulWidget {
  @override
  _GetDataState createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
  bool loginKey;
  bool isLoading = true;
  loadSharedPref() async {
    try {
      loginKey = await SharedData.readUserLoggedIn();
      if(loginKey != null){
        isLoading = false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    loadSharedPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
              loginKey ? HomePage() : LoginPage())),
    );
  }
}
