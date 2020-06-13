import 'package:flutter/cupertino.dart';
import 'package:zoomclone/utils/constants.dart';

class SessionInfo {
  final SessionStatus sessionStatus;
  final String sessionStartTimeStamp;
  final String sessionTitle;
  final String sessionDescription;
  final String sessionId;

  SessionInfo(
      {@required this.sessionStatus,
      @required this.sessionStartTimeStamp,
      @required this.sessionTitle,
      @required this.sessionDescription,
      @required this.sessionId});
}
