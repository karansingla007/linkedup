import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoomclone/api/api.dart';
import 'package:zoomclone/screen/create_session_screen.dart';
import 'package:zoomclone/screen/history_discussion_screen.dart';
import 'package:zoomclone/screen/join_meeting_screen.dart';
import 'package:zoomclone/screen/live_discussion_screen.dart';
import 'package:zoomclone/screen/meeting_detail_screen.dart';
import 'package:zoomclone/screen/network_screen.dart';
import 'package:zoomclone/screen/profile_screen.dart';
import 'package:zoomclone/utils/local_notification.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  final List<Widget> _children = [
    LiveDiscussionScreen(),
    HistoryDiscussionScreen(),
    CreateSessionScreen(),
    NetworkScreen(),
    ProfileScreen(),
  ];
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    firebaseCloudMessagingListeners();

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initShareIntent();
    }
  }

  _initShareIntent() async {
    try {
      Map data = await MethodChannel('app.channel.shared.data')
          .invokeMethod('getSharedData');
      if (data.isEmpty) {
        return;
      }
      if (data.containsKey('shared_link_click')) {
        String link = data['shared_link_click'];
        print(link);
        List linkDetail = link.split('/');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MeetingDetailScreen(
                    meetingId: linkDetail.last,
                  )),
        );
      }
    } catch (_) {}
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) {
      try {
        Api().updateFcmToken(fcmToken: token);
      } catch (error, stackTrace) {
        print(error);
//        Util.reportError("fcm_token_falied", error, stackTrace);
      }
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        try {
          LocalNotification localNotification = LocalNotification();
          localNotification.showNotification(
              message, context, NotificationType.onMessage);
        } catch (error, stackTrace) {
          print(error);
//          Util.reportError("fcm_token_on_message_falied", error, stackTrace);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        try {
          LocalNotification localNotification = LocalNotification();
          localNotification.showNotification(
              message, context, NotificationType.onResume);
        } catch (error, stackTrace) {
          print(error);
//          Util.reportError("fcm_token_on_resume_falied", error, stackTrace);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        try {
          LocalNotification localNotification = LocalNotification();
          localNotification.showNotification(
              message, context, NotificationType.onMessage);
        } catch (error, stackTrace) {
          print(error);
//          Util.reportError("on_launch_player_home", error, stackTrace);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 50,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        iconSize: 32,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.live_tv,
              color: Colors.blue,
            ),
            title: new Text(
              'Live',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.history,
              color: Colors.blue,
            ),
            title: new Text(
              'History',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.add_circle,
              color: Colors.blue,
            ),
            title: new Text(
              'Create',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.group,
              color: Colors.blue,
            ),
            title: new Text(
              'Network',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              title: Text(
                'Profile',
                style: TextStyle(color: Colors.blue),
              ))
        ],
      ),
      floatingActionButton: Visibility(
        visible: _currentIndex == 0,
        child: FloatingActionButton(
          child: Icon(Icons.calendar_today),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JoinMeetingScreen()),
            );
          },
        ),
      ),
      body: _children[_currentIndex],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
