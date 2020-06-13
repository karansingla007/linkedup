import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/text_big_button.dart';
import 'package:zoomclone/atoms/text_body_1.dart';
import 'package:zoomclone/molecule/circle_image.dart';
import 'package:zoomclone/utils/util.dart';

class ShortUserInfoShortWidget extends StatelessWidget {
  final String profilePicUrl;
  final String firstName;
  final String lastName;
  final String userName;

  ShortUserInfoShortWidget(
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
          height: 32.0,
          width: 32.0,
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
              TextBigButton(
                Util.getFullName(firstName, lastName),
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              TextBody1(
                userName,
                color: Colors.blueAccent,
                shadowEnabled: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
