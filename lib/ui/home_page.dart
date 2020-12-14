import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
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
  AudioPlayer player = AudioPlayer();
  VideoPlayerController _controller;
  List<PodcastData> podcastDataList;
  var viewDataCount;
  Map<dynamic, dynamic> map;
  int positionValue;
  bool isLoading = true;
  bool isPlaying = false;
  bool _isPlaying = false;
  bool isOverData = false;
  bool isLimitReached = false;
  bool isSkipAuto = false;
  bool _isPaused = false;
  int plays = 0;
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
      isLoading = false;
      if (podcastDataList[skipCount].type == 'audio') {
        playAudio(skipCount);
      } else {
        playPodcast(skipCount);
      }
    }
  }

  getRandonValueRange() {
    Random random = new Random();
    double range = 0.3 - 0.03;
    double scaled = random.nextDouble() * range;
    double shifted = scaled + 0.3;
    print("shifted " + shifted.toString().substring(0, 4));
    return double.parse(shifted.toString().substring(0, 4));
  }

  @override
  void dispose() {
    _controller.dispose();
    player.dispose();
    super.dispose();
  }

  sendAgain() {
    // ignore: deprecated_member_use
    var options = new GmailSmtpOptions()
      ..username = adminEmailText
      ..password = adminEmailPassword;
    var emailTransport = new SmtpTransport(options);

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

  void _clearPlayer() {
    setState(() {
      _isPlaying = false;
      _isPaused = false;
    });
  }

  Future pause() async {
    int result = await player.pause();
    if (result == 1) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  Future resume() async {
    int result = await player.resume();
    if (result == 1) {
      setState(() {
        _isPlaying = true;
      });
    }
  }

  Future play([int position]) async {
    int result = await player.play(podcastDataList[skipCount].link);
    if (result == 1) {
      setState(() {
        _isPlaying = true;
      });
    }
  }

  Future<void> playAudio(int position) async {
    isLoading = false;
    await play(position);
    player.onDurationChanged.listen((event) {
      time = event.inSeconds;
    });
    player.onAudioPositionChanged.listen((event) {
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          positionValue = event.inSeconds;
        });
      });
    });
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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: appTextMaroonColor,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(appOffWhiteColor),
              ),
            ),
          )
        : Stack(
            children: [
              Scaffold(
                backgroundColor: appOffWhiteColor,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: appOffWhiteColor,
                  iconTheme: IconThemeData(color: appTextMaroonColor),

                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16, right: 16),
                      child: TextView(
                        '$count Listen Credits',
                        fontSize: 14,
                        textColor: appTextRedColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoCondensed-Bold',
                      ),
                    ),
                  ],
                  // title: TextView(
                  //   homeText,
                  //   textColor: appTextColor,
                  //   fontSize: 20,
                  // ),
                ),
                drawer: Drawer(
                  child: Container(
                    color: appOffWhiteColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DrawerHeader(
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: appTextEditingColor,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: TextView(
                                      widget.userData.name[0].toUpperCase(),
                                      fontSize: 35,
                                      textColor: appTextColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextView(
                                      widget.userData.name,
                                      fontSize: 21.6,
                                      textColor: appTextMaroonColor,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextView(
                                          '$count Listen Credits',
                                          fontSize: 14,
                                          fontFamily: 'RobotoCondensed',
                                          textColor: appTextRedColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (widget.userData.coinCount <=
                                                0) {
                                              showAlertDialogWithTwoButtonOkAndCancel(
                                                  context,
                                                  'No money added, Listend podcast to get money',
                                                  () {
                                                Navigator.pop(context);
                                              });
                                            }
                                            sendAgain();
                                          },
                                          child: TextView(
                                            'CASH OUT',
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'RobotoCondensed',
                                            fontSize: 14,
                                            textColor: appTextRedColor,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0.8,
                          child: Divider(
                            height: 1,
                            color: appTextMaroonColor,
                          ),
                        ),
                        createDrawerItem(
                            text: editProfileText,
                            onTap: () {
                              if (podcastDataList[skipCount].type == 'audio') {
                                player.pause();
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfile(widget.userData),
                                    ));
                              } else {
                                _controller.pause();
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfile(widget.userData),
                                    ));
                              }
                            }),
                        Opacity(
                          opacity: 0.8,
                          child: Divider(
                            height: 1,
                            color: appTextMaroonColor,
                          ),
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
                                if (podcastDataList[skipCount].type ==
                                    'audio') {
                                  player.pause();
                                  SharedData.removeAllPrefs();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                      (Route<dynamic> route) => false);
                                } else {
                                  _controller.pause();
                                  SharedData.removeAllPrefs();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                      (Route<dynamic> route) => false);
                                }
                              });
                            }),
                        Opacity(
                          opacity: 0.8,
                          child: Divider(
                            height: 1,
                            color: appTextMaroonColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      podcastDataList[skipCount].type == 'audio'
                          ? Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Opacity(
                                    opacity: 0.6,
                                    child: Image.asset(
                                      'assets/pod.png',
                                      width:
                                          MediaQuery.of(context).size.height /
                                              5,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Align(
                              alignment: Alignment.topCenter,
                              child: _controller.value.initialized
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5,
                                        ),
                                        AspectRatio(
                                          aspectRatio:
                                              _controller.value.aspectRatio,
                                          child: VideoPlayer(_controller),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ),
                      SizedBox(
                        height: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: TextView(
                            podcastDataList[skipCount].title,
                            textColor: appTextMaroonColor,
                            fontSize: 14,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: podcastDataList[skipCount].type == 'audio'
                            ? Builder(builder: (context) {
                                if (time == 0) {
                                  return SizedBox();
                                } else {
                                  int dur = (time * 0.3).toInt();
                                  int pos = positionValue;
                                  int skipTime = (dur *
                                          podcastDataList[skipCount].skipValue)
                                      .toInt();

                                  print('Duration is $dur');
                                  print('Position is $pos');
                                  print('Skip is $skipTime');
                                  var difference = skipTime - pos;

                                  print('difference is $difference');

                                  if (pos == skipTime) {
                                    isLimitReached = true;
                                    callNextPodcast();
                                  }

                                  var remaining = Duration(seconds: difference)
                                      .toString()
                                      .lastIndexOf('.');

                                  String result = (pos != -1)
                                      ? Duration(seconds: difference)
                                          .toString()
                                          .substring(2, remaining)
                                      : difference;
                                  return TextView(
                                    result,
                                    fontSize: 60,
                                    textColor: appTextRedColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'RobotoSlab',
                                  );
                                }
                              })
                            : ValueListenableBuilder(
                                valueListenable: _controller,
                                builder:
                                    (context, VideoPlayerValue value, child) {
                                  var pos = value.position;
                                  var dur = (value.duration * 0.3);
                                  var test = (value.duration.inSeconds *
                                          podcastDataList[skipCount].skipValue)
                                      .toInt();
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
                                        test);
                                  }

                                  var remaining =
                                      difference.toString().lastIndexOf('.');
                                  String result = (pos != -1)
                                      ? difference
                                          .toString()
                                          .substring(0, remaining)
                                      : difference;
                                  return TextView(
                                    result,
                                    fontSize: 60,
                                    fontFamily: 'RobotoSlab',
                                    fontWeight: FontWeight.bold,
                                    textColor: appTextRedColor,
                                  );
                                },
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextView(
                        'Time Until Next Listen Credit',
                        fontSize: 14,
                        textColor: appTextRedColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoCondensed',
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RaisedButton(
                              elevation: 0,
                              color: appOffWhiteColor,
                              onPressed: () {
                                if (skipCount < podcastDataList.length - 1) {
                                  if (podcastDataList[skipCount].type ==
                                      'audio') {
                                    player.pause();
                                  } else {
                                    _controller.pause();
                                  }
                                  callNextPodcast();
                                } else {
                                  showAlertDialogWithTwoButtonOkAndCancel(
                                      context, lastPodCast, () {
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              child: TextView(
                                skipText,
                                fontSize: 14,
                                textColor: appTextMaroonColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'RobotoCondensed',
                              ),
                            ),
                            TextView(
                              "/",
                              textColor: appSlashColor,
                              fontSize: 50,
                            ),
                            RaisedButton(
                              elevation: 0,
                              color: appOffWhiteColor,
                              onPressed:
                                  podcastDataList[skipCount].type == 'audio'
                                      ? () {
                                          _isPlaying
                                              ? pause()
                                              : _isPaused
                                                  ? resume()
                                                  : play();
                                        }
                                      : () {
                                          _controller.value.isPlaying
                                              ? _controller.pause()
                                              : _controller.play();
                                          _controller.value.isPlaying
                                              ? isPlaying = true
                                              : isPlaying = false;
                                        },
                              child: podcastDataList[skipCount].type == 'audio'
                                  ? Builder(builder: (context) {
                                      return _isPlaying
                                          ? TextView(
                                              pauseText,
                                              textColor: appTextMaroonColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'RobotoCondensed',
                                            )
                                          : TextView(
                                              playText,
                                              textColor: appTextMaroonColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'RobotoCondensed',
                                            );
                                    })
                                  : ValueListenableBuilder(
                                      valueListenable: _controller,
                                      builder: (context, VideoPlayerValue value,
                                          child) {
                                        return value.isPlaying
                                            ? TextView(
                                                pauseText,
                                                textColor: appTextMaroonColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'RobotoCondensed',
                                              )
                                            : TextView(
                                                playText,
                                                textColor: appTextMaroonColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'RobotoCondensed',
                                              );
                                      },
                                    ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  void percenttime(
      double upperLimit, double lowerLimit, int diff, int skipValue) {
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
    if (skipCount <= podcastDataList.length) {
      podcastDataList[skipCount].type == 'audio'
          ? playAudio(skipCount)
          : playPodcast(skipCount);
    } else {
      showAlertDialogWithTwoButtonOkAndCancel(context, overList, () {
        if (podcastDataList[skipCount].type == 'audio') {
          player.pause();
        } else {
          _controller.pause();
        }

        Navigator.pop(context);
      });
    }
  }
}
