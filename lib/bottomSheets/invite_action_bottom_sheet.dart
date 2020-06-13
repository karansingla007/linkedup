import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/text_body_2.dart';
import 'package:zoomclone/atoms/text_user_name.dart';
import 'package:zoomclone/buttons/rounded_shape_button.dart';
import 'package:zoomclone/molecule/circle_image.dart';

class InviteActionBottomSheet extends StatelessWidget {
  final String otherUserName;
  final String hostUserName;
  final String otherUserProfilePicUrl;
  final String hostUserProfilePicUrl;
  final Function onClickAccept;

  const InviteActionBottomSheet(
      {this.hostUserProfilePicUrl,
      this.otherUserName,
      this.otherUserProfilePicUrl,
      this.hostUserName,
      this.onClickAccept});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.topCenter,
                    child: CircleImageWithBorder(
                      hostUserProfilePicUrl,
                    )),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 120.0),
                      child: CircleImageWithBorder(otherUserProfilePicUrl),
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextUsername(hostUserName),
              TextBody2(' invite you to become Speaker.'),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RoundedShapeButton(
                text: 'Decline',
                color: Colors.redAccent,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 16,
              ),
              RoundedShapeButton(
                text: 'Accept',
                color: Colors.blue,
                onPressed: () {
                  onClickAccept();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
