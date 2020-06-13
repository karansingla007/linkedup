import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/text_small_title.dart';
import 'package:zoomclone/molecule/toggle_icon.dart';
import 'package:zoomclone/utils/constants.dart';
import 'package:zoomclone/utils/strings.dart';

class LiveDiscussionToggle extends StatelessWidget {
  final Function(String) onSelectedValue;
  final bool isToggleActive;

  LiveDiscussionToggle({this.onSelectedValue, this.isToggleActive});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        TextSmallTitle(
          Strings.NOW,
          color: isToggleActive ? Colors.black54 : Colors.black,
        ),
        ToggleIcon(
          switchValue: isToggleActive,
          activeTrackColor: Colors.lightBlue,
          inactiveTrackColor: Colors.lightBlue,
          inactiveThumbColor: Colors.blue,
          activeThumbColor: Colors.blue,
          onChange: (value) {
            if (!value) {
              onSelectedValue(Constants.NOW);
            } else {
              onSelectedValue(Constants.LATER);
            }
          },
        ),
        TextSmallTitle(
          Strings.LATER,
          color: isToggleActive ? Colors.black : Colors.black54,
        ),
      ],
    );
  }
}
