import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/screen/live_agora.dart';

class LiveMeeting extends StatelessWidget {
  final String meetingId;
  final String userRole;
  final Map hostUser;

  LiveMeeting({@required this.meetingId, this.userRole, this.hostUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiveAgora(
          meetingId: meetingId, userRole: userRole, hostUser: hostUser),
    );
  }
}
