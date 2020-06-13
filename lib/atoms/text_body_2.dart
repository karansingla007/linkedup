import 'package:flutter/material.dart';

class TextBody2 extends StatelessWidget {
  final String data;
  final Color color;

  const TextBody2(this.data, {Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        fontSize: 14.0,
        color: color,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
