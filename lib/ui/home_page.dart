import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:rss_feed_app/helper/Constants.dart';
import 'package:rss_feed_app/helper/text_view.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VideoPlayerController _controller;
  int time = 0;

  @override
  Future<void> initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4');
    _controller.initialize().then((_) => setState(() {
      time = _controller.value.duration.inSeconds;
    }));
    _controller.play();
    timer(_controller);
  }

  timer(VideoPlayerController _controller) async {
    time = await _controller.value.duration.inSeconds;
    print(time);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget appBar() {
    return AppBar(
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/take.png',
                      width: 30,
                      height: 30,
                    ),
                    TextView("5"),
                    Image.asset(
                      'assets/plus.png',
                      width: 30,
                      height: 30,
                    ),
                  ],
                ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBar(),
      body: Stack(
        children: [
          Center(
            child: _controller.value.initialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, VideoPlayerValue value, child) {
                  //Do Something with the value.
                  return Text(value.position.toString());
                },
              ),
                  CountdownTimer(
                    endTime: time,
                    textStyle: TextStyle(color: appWhiteColor),emptyWidget: SizedBox(),
                  ),
                  /*TextView(
                    _controller.value.duration.inSeconds.toString(),
                    fontSize: 50,
                    textColor: appWhiteColor,
                  ),*/
                  TextView(
                    'Time remaining',
                    fontSize: 16,
                    textColor: appWhiteColor,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () {},
                          child: TextView(
                            skipText,
                            textColor: appWhiteColor,
                            fontSize: 24,
                          )),
                      InkWell(
                          onTap: () {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          },
                          child: _controller.value.isPlaying ? TextView(
                             pauseText ,
                            textColor: appWhiteColor,
                            fontSize: 24,
                          ) :TextView(
                              playText,
                            textColor: appWhiteColor,
                            fontSize: 24,
                          ))
                    ],
                  ),
                ],
              ),
            ),
          )


        ],
      ),
    );
  }
}
