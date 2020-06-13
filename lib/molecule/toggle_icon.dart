import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToggleIcon extends StatelessWidget {
  final bool switchValue;
  final Function(bool) onChange;
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final Color inactiveThumbColor;
  final Color activeThumbColor;

  ToggleIcon(
      {@required this.switchValue,
      @required this.onChange,
      this.activeTrackColor,
      this.inactiveThumbColor,
      this.activeThumbColor,
      this.inactiveTrackColor});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: switchValue,
      activeTrackColor: activeTrackColor,
      inactiveTrackColor: inactiveTrackColor,
      inactiveThumbColor: inactiveThumbColor,
      activeColor: activeThumbColor,
      onChanged: (value) {
        onChange(value);

//        setState(() {
//          switchValue = !switchValue;
//        });
      },
    );
  }
}
