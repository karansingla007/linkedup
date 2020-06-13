import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zoomclone/screen/meeting_detail_screen.dart';

enum NotificationType { onMessage, onResume, onLaunch }

class LocalNotification {
  BuildContext context;
  Map payLoad;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  showNotification(
      Map payLoad, BuildContext context, NotificationType notificationType) {
    this.context = context;
    this.payLoad = payLoad;

    if (notificationType == NotificationType.onMessage) {
      var initializationSettingsAndroid =
          new AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);

      _showNotificationWithDefaultSound(payLoad['data']);
    } else {
      Item item;
      try {
        String data = payLoad['data']['link'];
        if (!data.contains("\"type\":")) {
          data = data.replaceAll("type", "\"type\"");
          data = data.replaceFirst("id", "\"id\"");
          data = data.replaceAll('\'', '"');
        }

        item = Item.fromJson(json.decode(data));
//        navigate(context, item,
//            isSkipChecks: false,
//            replace: notificationType == NotificationType.onLaunch);
      } catch (error, stackTrace) {}
    }
  }

  Future onSelectNotification(String action) async {
    if (action != null) {
      Item item;

      try {
        String data = payLoad['data']['link'];
        if (!data.contains("\"type\":")) {
          data = data.replaceAll("type", "\"type\"");
          data = data.replaceFirst("id", "\"id\"");
          data = data.replaceAll('\'', '"');
        }
        item = Item.fromJson(json.decode(data));
        navigate(
          context,
          item,
        );
      } catch (error, stackTrace) {}
    }
  }

  static Future navigate(BuildContext context, Item item) async {
    switch (item.type) {
      case "MEETING_CREATE":
      case "MEETING_START":
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MeetingDetailScreen(
                    meetingId: item.id,
                  )),
        );
        break;
    }
  }

  Future _showNotificationWithDefaultSound(Map payLoad) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'audio_notification_is',
        'audio_notification',
        'audio_notification_description',
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      payLoad['title'],
      payLoad['body'],
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}

class Item {
  String type;
  String id;
  var idType;

  Item({this.type, this.id, this.idType});

  factory Item.fromJson(Map<String, dynamic> json) => _itemFromJson(json);

  @override
  String toString() {
    return 'Item{type: $type, id: $id}';
  }
}

Item _itemFromJson(Map<String, dynamic> json) {
  return Item(
    type: json['type'] as String,
    id: json['id'] as String,
  );
}
