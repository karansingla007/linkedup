import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/text_small_title.dart';

class ProfileActionWidget extends StatelessWidget {
  final String text;
  final Icon icon;

  ProfileActionWidget({this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(color: Colors.black12, width: 1),
            color: Colors.lightBlue),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              icon,
              SizedBox(
                width: 8,
              ),
              TextSmallTitle(
                text,
                color: Colors.white,
              ),
              Expanded(
                child: Container(),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
