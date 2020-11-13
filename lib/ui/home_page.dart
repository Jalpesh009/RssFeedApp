import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rss_feed_app/helper/Constants.dart';
import 'package:rss_feed_app/helper/text_view.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/Butterfly-209.mp4');

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/take.png',
                            width: 40,
                            height: 40,
                          ),
                          TextView("5"),
                          Image.asset(
                            'assets/plus.png',
                            width: 40,
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ],
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
