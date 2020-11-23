import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rss_feed_app/helper/Constants.dart';
import 'package:rss_feed_app/helper/shared_data.dart';
import 'package:rss_feed_app/helper/text_view.dart';
import 'package:rss_feed_app/model/podcast.dart';
import 'package:rss_feed_app/model/user_data.dart';
import 'package:rss_feed_app/ui/edit_profile.dart';
import 'package:rss_feed_app/ui/login_page.dart';
import 'package:rss_feed_app/ui/spalsh.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  UserData userData;

  HomePage(this.userData);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final databaseRef = FirebaseDatabase.instance.reference();
  VideoPlayerController _controller;
  List<PodcastData> podcastDataList;
  var viewDataCount;
  Map<dynamic, dynamic> map;
  bool isLoading = true;
  bool isPlaying = false;
  bool isOverData = false;
  bool isLimitReached = false;
  int count;
  int skipCount = 0;
  int time = 0;
  UserData data;

  loadSharedPref() async {
    try {
      data = await UserData.fromJson(await SharedData.readUserPreferences());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> initState() {
    loadSharedPref();
    super.initState();

    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: widget.userData.email)
        .getDocuments()
        .then((value) {
      var map = value.docs.first.data();
      setState(() {
        count = map['coinCount'];
      });
    });

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
      podcastData.title = dataSnapshot[i]['title'];
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
                width: 90,
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
                    TextView(
                      count.toString(),
                      textColor: appTextColor,
                    ),
                    SizedBox(
                      width: 15,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      title: TextView(
        homeText,
        textColor: appWhiteColor,
        fontSize: 20,
      ),
    );
  }

  void playPodcast(int position) {
    _controller = VideoPlayerController.network(podcastDataList[position].link);
    _controller.initialize().then((_) => setState(() {
          isLimitReached = false;
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
            drawer: Drawer(
              child: Container(
                color: Theme.of(context).backgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DrawerHeader(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.amberAccent,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(
                                child: TextView(
                                  widget.userData.name[0].toUpperCase(),
                                  fontSize: 80,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: TextView(
                                widget.userData.name,
                                fontSize: 20,
                                textColor: appWhiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    createDrawerItem(
                        icon: Icon(
                          Icons.edit,
                          color: appWhiteColor,
                        ),
                        text: editProfileText,
                        onTap: () {
                          _controller.pause();
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfile(widget.userData),
                              ));
                        }),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    createDrawerItem(
                        icon: Icon(
                          Icons.logout,
                          color: appWhiteColor,
                        ),
                        text: logOutText,
                        onTap: () {
                          _controller.pause();
                          SharedData.removeAllPrefs();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => LoginPage()),
                              (Route<dynamic> route) => false);
                        }),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: TextView(
                      podcastDataList[skipCount].title,
                      textColor: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                podcastDataList[skipCount].type == 'audio'
                    ? Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            'assets/placeholder.jpg',
                            width: 200,
                            height: 300,
                          ),
                        ),
                      )
                    : Center(
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
                          timeRemainingText,
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
                                        if (isLimitReached) {
                                          count++;
                                        }
                                        String docId;
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .where('email',
                                                isEqualTo:
                                                    widget.userData.email)
                                            .getDocuments()
                                            .then((value) {
                                          docId = value.docs.first.documentID;
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(docId)
                                              .update({
                                            'coinCount': count
                                          }).catchError((e) {
                                            print(e.toString());
                                          });
                                        });

                                        playPodcast(skipCount);
                                        print("title " +
                                            podcastDataList[skipCount].title);
                                      } else {
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
    if (lowerLimit > diff && upperLimit < diff) {
      isLimitReached = true;
      print("player has reached safe zone");
    } else if (lowerLimit < diff) {
      isLimitReached = false;
      print('Player is lower bound');
    } else if (diff < upperLimit) {
      isLimitReached = true;
      print('Player is upper bound');
    }
  }
}
