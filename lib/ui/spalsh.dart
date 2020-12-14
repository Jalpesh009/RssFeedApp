import 'package:flutter/material.dart';
import 'package:rss_feed_app/helper/Constants.dart';
import 'package:rss_feed_app/helper/shared_data.dart';
import 'package:rss_feed_app/model/user_data.dart';
import 'package:rss_feed_app/ui/home_page.dart';

import 'login_page.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool loginKey;
  UserData data;

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
                builder: (context) => loginKey ? HomePage(data) : LoginPage()));
      });
    });
  }

  loadSharedPref() async {
    try {
      loginKey = await SharedData.readUserLoggedIn();
      data = await UserData.fromJson(await SharedData.readUserPreferences());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTextMaroonColor,
      body: Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(appOffWhiteColor),
        ),
      )
      /*Stack(
        children: <Widget>[
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: appBodyColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/splash.png',
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/logo.png',
              height: 150,
              width: 150,
            ),
          )
        ],
      ),*/
    );
  }
}
