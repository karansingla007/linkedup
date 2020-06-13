import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/text_button_small.dart';
import 'package:zoomclone/atoms/text_small_title.dart';
import 'package:zoomclone/molecule/circle_image.dart';
import 'package:zoomclone/utils/util.dart';

class SessionProfileDetail extends StatelessWidget {
  final String profilePicUrl;
  final String firstName;
  final String lastName;
  final String userName;

  SessionProfileDetail(
      {this.profilePicUrl, this.firstName, this.lastName, this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleImageWithBorder(
          profilePicUrl,
          height: 32.0,
          width: 32.0,
          signature:
              Util.getSignatureOfName(firstName: firstName, lastName: lastName),
        ),
        SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextSmallTitle(
              Util.getFullName(firstName, lastName),
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            TextSmallButton(
              userName,
              color: Colors.blueAccent,
            ),
          ],
        ),
        Expanded(
          child: Container(),
        )
      ],
    );
  }
}
