import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/widgets/short_user_info_small_widget.dart';

class NetworkUserWidget extends StatelessWidget {
  final String profilePicUrl;
  final String firstName;
  final String lastName;
  final String userName;

  NetworkUserWidget(
      {@required this.profilePicUrl,
      @required this.firstName,
      @required this.lastName,
      @required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ShortUserInfoShortWidget(
          userName: userName,
          firstName: firstName,
          lastName: lastName,
          profilePicUrl: profilePicUrl,
        ),
        Expanded(
          child: Container(),
        ),
        Icon(Icons.call),
        SizedBox(
          width: 16,
        ),
        Icon(Icons.video_call),
      ],
    );
  }
}
