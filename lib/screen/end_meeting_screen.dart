import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/large_title.dart';

class EndMeetingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: LargeTitle(
        'Host end the meeting',
        textAlign: TextAlign.center,
        shadowEnabled: true,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      )),
    );
  }
}
