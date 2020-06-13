import 'package:flutter/material.dart';

class TextBigButton extends StatelessWidget {
  final String data;
  final Color color;
  final FontWeight fontWeight;

  const TextBigButton(this.data,
      {Key key, this.color, this.fontWeight = FontWeight.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
          fontSize: 14.0,
          fontStyle: FontStyle.normal,
          fontWeight: fontWeight,
          color: color),
      textAlign: TextAlign.center,
    );
  }
}
