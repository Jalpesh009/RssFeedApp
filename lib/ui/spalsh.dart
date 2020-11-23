import 'package:flutter/material.dart';
import 'package:rss_feed_app/helper/Constants.dart';
import 'package:rss_feed_app/helper/shared_data.dart';
import 'package:rss_feed_app/ui/home_page.dart';

import 'login_page.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool loginKey;

  @override
  void initState() {
    // TODO: implement initState
    loadSharedPref();
    super.initState();
    time();
  }

  void time() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => loginKey ? HomePage() : LoginPage()));
      });
    });
  }

  loadSharedPref() async {
    try {
      loginKey = await SharedData.readUserLoggedIn();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: appSplashColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/background.png'),
                    // fit: BoxFit.none,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  CircularProgressIndicator()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}