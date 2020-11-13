import 'package:flutter/material.dart';
import 'package:rss_feed_app/helper/Constants.dart';
import 'package:rss_feed_app/helper/text_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: Icon(
                  Icons.add,
                  color: appGreyColor,
                  size: 20.0,
                ),
              ),
            ),
          ),
        ],
        title: TextView(
          homeText,
          textColor: appTextColor,
          fontSize: 20,
        ),
      ),
    );
  }
}
