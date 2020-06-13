import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/text_big_title.dart';
import 'package:zoomclone/atoms/text_body_2.dart';
import 'package:zoomclone/atoms/text_small_title.dart';

class ConfirmationDialog extends StatelessWidget {
  final String heading;
  final String subHeading;
  final Widget button;

  ConfirmationDialog({this.heading, this.subHeading, this.button});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextBigTitle(
          heading,
          color: Colors.black,
        ),
        SizedBox(
          height: 8,
        ),
        TextSmallTitle(
          subHeading,
          color: Colors.black87,
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: TextBody2(
                'Cancel',
                color: Colors.black54,
              ),
            ),
            SizedBox(
              width: 16,
            ),
            button,
          ],
        ),
      ],
    );
  }
}
