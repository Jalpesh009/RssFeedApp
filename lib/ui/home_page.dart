import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rss_feed_app/helper/Constants.dart';
import 'package:rss_feed_app/helper/text_view.dart';
import 'package:rss_feed_app/model/podcast.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final databaseRef = FirebaseDatabase.instance.reference();
  VideoPlayerController _controller;
  List<PodcastData> podcastDataList;
  Map<dynamic, dynamic> map;
  bool isLoading = true;
  bool isPlaying = false;
  bool isOverData = false;
  int count = 0;
  int skipCount = 0;
  int time = 0;

  @override
  Future<void> initState() {
    super.initState();

    databaseRef.child('data').once().then((value) {
      setState(() {
        podcastDataList = new List();
        fetchData(value.value);
      });
    });
  }

  void fetchData(List<dynamic> dataSnapshot) {
    for (int i = 0; i < dataSnapshot.length; i++) {
      PodcastData podcastData = new PodcastData();
      podcastData.podId = dataSnapshot[i]['pod_id'];
      podcastData.type = dataSnapshot[i]['type'];
      podcastData.link = dataSnapshot[i]['link'];
      podcastDataList.add(podcastData);
    }

    if (podcastDataList.length != 0) {
      playPodcast(skipCount);
    }
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
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    TextView(count.toString()),
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

  void playPodcast(int position) {
    _controller = VideoPlayerController.network(
        podcastDataList[position].link);
    _controller.initialize().then((_) =>
        setState(() {
          time = _controller.value.duration.inSeconds;
          print(time);
          isLoading = false;
        }));
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
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
                        ValueListenableBuilder(
                          valueListenable: _controller,
                          builder: (context, VideoPlayerValue value, child) {
                            var pos = value.position;
                            var dur = value.duration;
                            var difference = dur - pos;

                            percenttime(
                                value.duration.inSeconds * 0.7,
                                value.duration.inSeconds * 0.97,
                                value.duration.inSeconds -
                                    value.position.inSeconds);

                            var remaining =
                                difference.toString().lastIndexOf('.');
                            String result = (pos != -1)
                                ? difference.toString().substring(0, remaining)
                                : difference;
                            print(result);

                            return TextView(
                              result,
                              fontSize: 50,
                              textColor: appWhiteColor,
                            );
                          },
                        ),
                        TextView(
                          'Time remaining',
                          fontSize: 16,
                          textColor: appWhiteColor,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ButtonTheme(
                              minWidth: 80,
                              child: RaisedButton(
                                  color: Colors.black,
                                  onPressed: () {
                                    double val = time * 0.6;
                                    print(val.toString());
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      if (skipCount <= podcastDataList.length) {
                                        isOverData = false;
                                        skipCount++;
                                        playPodcast(skipCount);
                                      }
                                      else {
                                        showAlertDialogWithTwoButtonOkAndCancel(
                                            context, lastPodCast, () {
                                          Navigator.pop(context);
                                        });
                                      }
                                    },
                                    child: TextView(
                                      skipText,
                                      textColor: isOverData
                                          ? appGreyColor
                                          : appWhiteColor,
                                      fontSize: 24,
                                    ),
                                  )),
                            ),
                            ButtonTheme(
                              minWidth: 80,
                              child: RaisedButton(
                                color: Colors.black,
                                onPressed: () {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                  _controller.value.isPlaying
                                      ? isPlaying = true
                                      : isPlaying = false;
                                },
                                child: ValueListenableBuilder(
                                  valueListenable: _controller,
                                  builder:
                                      (context, VideoPlayerValue value, child) {
                                    return value.isPlaying
                                        ? TextView(
                                            pauseText,
                                            textColor: appWhiteColor,
                                            fontSize: 24,
                                          )
                                        : TextView(
                                            playText,
                                            textColor: appWhiteColor,
                                            fontSize: 24,
                                          );
                                  },
                                ),
                              ),
                            )
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

  void percenttime(double upperLimit, double lowerLimit, int diff) {
    print(upperLimit);
    print(lowerLimit);
    print(diff);
    if (lowerLimit > diff &&  upperLimit < diff) {
      print("player has reached safe zone");
    } else if(lowerLimit < diff){
      print('Player is lower bound');
    } else if(diff < upperLimit){
      print('Player is upper bound');
    }
  }
}
