import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/text_big_title.dart';
import 'package:zoomclone/atoms/text_user_name.dart';
import 'package:zoomclone/molecule/circle_image.dart';
import 'package:zoomclone/utils/util.dart';

class ShortUserInfoWidget extends StatelessWidget {
  final String profilePicUrl;
  final String firstName;
  final String lastName;
  final String userName;

  ShortUserInfoWidget(
      {@required this.profilePicUrl,
      @required this.firstName,
      @required this.lastName,
      @required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleImageWithBorder(
          profilePicUrl,
          signature:
              Util.getSignatureOfName(firstName: firstName, lastName: lastName),
        ),
        SizedBox(
          width: 8,
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextBigTitle(
                Util.getFullName(firstName, lastName),
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              TextUsername(
                userName,
                color: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
