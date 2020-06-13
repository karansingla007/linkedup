import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:zoomclone/atoms/text_body_1.dart';
import 'package:zoomclone/atoms/text_body_2.dart';
import 'package:zoomclone/atoms/text_user_name.dart';
import 'package:zoomclone/molecule/circle_image.dart';
import 'package:zoomclone/utils/time_util.dart';

class UserComment extends StatelessWidget {
  final String profilePicUrl;
  final String type;
  final String commentText;
  final String userName;
  final String commentTime;
  final String signature;

  UserComment(
      {this.profilePicUrl,
      this.type,
      this.commentText,
      this.userName,
      this.commentTime,
      this.signature});

  var moment = new Moment.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleImageWithBorder(
          profilePicUrl,
          width: 32.0,
          height: 32.0,
          signature: signature,
        ),
        SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextUsername(userName),
                SizedBox(
                  width: 16,
                ),
                TextBody1(
                  moment.from(
                      TimeUtil.convertTimeStampToDate(int.parse(commentTime))),
                  shadowEnabled: false,
                  color: Colors.white60,
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            TextBody2(
              commentText,
              color: Colors.white,
            )
          ],
        ),
      ],
    );
  }
}
