import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:rss_feed_app/helper/Constants.dart';
import 'package:rss_feed_app/helper/shared_data.dart';
import 'package:rss_feed_app/helper/text_view.dart';
import 'package:rss_feed_app/model/podcast.dart';
import 'package:rss_feed_app/model/user_data.dart';
import 'package:rss_feed_app/ui/edit_profile.dart';
import 'package:rss_feed_app/ui/login_page.dart';
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
  bool isSkipAuto = false;
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
      podcastData.skipValue = getRandonValueRange();
      podcastDataList.add(podcastData);
    }

    if (podcastDataList.length != 0) {
      playPodcast(skipCount);
    }
  }

  getRandonValueRange() {
    Random random = new Random();
    double range = 0.97 - 0.3;
    double scaled = random.nextDouble() * range;
    double shifted = scaled + 0.3;
    print("shifted " + shifted.toString().substring(0, 4));
    return double.parse(shifted.toString().substring(0, 4));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  sendAgain() {
    // ignore: deprecated_member_use
    var options = new GmailSmtpOptions()
      ..username = adminEmailText
      ..password =
          adminEmailPassword; // Note: if you have Google's "app specific passwords" enabled,
    // you need to use one of those here.

    // How you use and store passwords is up to you. Beware of storing passwords in plain.

    // Create our email transport.
    // ignore: deprecated_member_use
    var emailTransport = new SmtpTransport(options);

    // Create our mail/envelope.
    // ignore: deprecated_member_use
    var bodymessage =
        '''<h4><strong>Hello Admin,</strong>&nbsp;</h4><p>I've to inform you that I've listened&nbsp;<strong>{{podcastNo}} podcasts</strong>. I'm requesting you to process&nbsp; payment on my Paypal email:&nbsp;<strong>{{payPalEmail}}</strong>.<br /><br />Below are my User Information:<br /><strong><br />Name:</strong>&nbsp;{{username}}<br /><strong>Email:&nbsp;</strong>{{email}}<br /><strong>Phone:</strong>&nbsp;{{mobileNO}}<br /><strong><br /></strong><strong>Thank you&nbsp;</strong><strong><br /></strong></p>''';

    var envelope = new Envelope()
      ..from = adminEmailText
      ..recipients.add(adminEmailText)
      ..subject = subjectText
      ..html = bodymessage
          .replaceAll("{{podcastNo}}", widget.userData.coinCount.toString())
          .replaceAll("{{payPalEmail}}", widget.userData.paypal_id)
          .replaceAll("{{username}}", widget.userData.name)
          .replaceAll("{{email}}", widget.userData.email)
          .replaceAll("{{mobileNO}}", widget.userData.phone_number);

    // Email it.
    emailTransport
        .send(envelope)
        .then((envelope) => showAlertDialogWithTwoButtonOkAndCancel(
                context, mailSuccusefully, () {
              Navigator.pop(context);
            }))
        .catchError((e) => print('Error occurred: $e'));
  }

  void playPodcast(int position) {
    _controller = VideoPlayerController.network(podcastDataList[position].link);
    _controller.initialize().then((_) => setState(() {
          isLimitReached = false;
          time = _controller.value.duration.inSeconds;
          print("time " + time.toString());
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
            appBar: AppBar(
              backgroundColor: appBodyColor,
              centerTitle: true,
              /* leading: IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Image.asset('assets/menu.png')),*/
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      sendAgain();
                    },
                    child: Image.asset(
                      'assets/money.png',
                      width: 45,
                      height: 45,
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
            drawer: Drawer(
              child: Container(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DrawerHeader(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: appYellowColor,
                                    borderRadius: BorderRadius.circular(40)),
                                child: Center(
                                  child: TextView(
                                    widget.userData.name[0].toUpperCase(),
                                    fontSize: 70,
                                    textColor: appTextColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: TextView(
                                  widget.userData.name,
                                  fontSize: 20,
                                  textColor: appTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: appTextColor,
                    ),
                    createDrawerItem(
                        icon: Icon(
                          Icons.edit,
                          color: appTextColor,
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
                      height: 3,
                      color: appBackgroundColor,
                    ),
                    createDrawerItem(
                        icon: Icon(
                          Icons.logout,
                          color: appTextColor,
                        ),
                        text: logOutText,
                        onTap: () {
                          showAlertDialogWithTwoButton(
                              context, logOutDialogueText, yesText, () {
                            _controller.pause();
                            SharedData.removeAllPrefs();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (Route<dynamic> route) => false);
                          });
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
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /* ValueListenableBuilder(
                        valueListenable: _controller,
                        builder: (context, VideoPlayerValue value, child) {
                          //Do Something with the value.
                          return TextView(value.position.toString(),textColor: appTextColor,);
                        },
                      ),*/

                      TextView(
                        timeRemainingText,
                        fontSize: 16,
                        textColor: appTextColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ValueListenableBuilder(
                        valueListenable: _controller,
                        builder: (context, VideoPlayerValue value, child) {
                          var pos = value.position;
                          var dur = value.duration * 0.3;
                          var test = (value.duration.inSeconds *
                              podcastDataList[skipCount].skipValue).toInt();

                          var durat = Duration(
                              minutes: (test / 60).truncate(),
                              seconds: (test / 60 % 60).truncate());

                          var difference = durat - pos;

                          print('testing data is :  $test');


                          if (skipCount < podcastDataList.length - 1) {
                            percenttime(
                                value.duration.inSeconds * 0.7,
                                value.duration.inSeconds * 0.97,
                                value.duration.inSeconds -
                                    value.position.inSeconds,
                                value.duration.inSeconds *
                                    podcastDataList[skipCount].skipValue);
                          }

                          var remaining =
                              difference.toString().lastIndexOf('.');
                          String result = (pos != -1)
                              ? difference.toString().substring(0, remaining)
                              : difference;
                          return TextView(
                            result,
                            fontSize: 50,
                            textColor: appTextColor,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                podcastDataList[skipCount].type == 'audio'
                    ? Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            'assets/pod.png',
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
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: TextView(
                              podcastDataList[skipCount].title,
                              textColor: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                double val = time * 0.6;
                                print(val.toString());

                                if (skipCount < podcastDataList.length - 1) {
                                  callNextPodcast();
                                } else {
                                  showAlertDialogWithTwoButtonOkAndCancel(
                                      context, lastPodCast, () {
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              child: Column(
                                children: [
                                  Image.asset('assets/skip_icon.png'),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextView(
                                    skipText,
                                    fontSize: 16,
                                    textColor: appTextColor,
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                                _controller.value.isPlaying
                                    ? isPlaying = true
                                    : isPlaying = false;
                              },
                              child: Column(
                                children: [
                                  ValueListenableBuilder(
                                      valueListenable: _controller,
                                      builder: (context, VideoPlayerValue value,
                                          child) {
                                        return value.isPlaying
                                            ? Image.asset('assets/pause.png')
                                            : Image.asset(
                                                'assets/play_icon.png');
                                      }),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: _controller,
                                    builder: (context, VideoPlayerValue value,
                                        child) {
                                      return value.isPlaying
                                          ? TextView(
                                              pauseText,
                                              textColor: appTextColor,
                                              fontSize: 16,
                                            )
                                          : TextView(
                                              playText,
                                              textColor: appTextColor,
                                              fontSize: 16,
                                            );
                                    },
                                  ),
                                ],
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

  void percenttime(
      double upperLimit, double lowerLimit, int diff, double skipValue) {
    print("diff " + diff.toString());
    print("skipValue " + skipValue.toInt().toString());
    if (diff == skipValue.toInt()) {
      if (skipCount < podcastDataList.length - 1) {
        callNextPodcast();
      } else {
        showAlertDialogWithTwoButtonOkAndCancel(context, lastPodCast, () {
          Navigator.pop(context);
        });
      }
    } else if (lowerLimit > diff && upperLimit < diff) {
      isLimitReached = false;
      print("player has reached safe zone");
    } else if (lowerLimit < diff) {
      isLimitReached = false;
      print('Player is lower bound');
    } else if (diff < upperLimit) {
      isLimitReached = true;
      print('Player is upper bound');
    }
  }

  callNextPodcast() {
    isOverData = false;
    skipCount++;
    if (isLimitReached) {
      count++;
    }
    String docId;
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: widget.userData.email)
        .getDocuments()
        .then((value) {
      docId = value.docs.first.documentID;
      FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
          .update({'coinCount': count}).catchError((e) {
        print(e.toString());
      });
    });

    playPodcast(skipCount);
  }
}
