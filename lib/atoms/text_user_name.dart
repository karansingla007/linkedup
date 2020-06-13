import 'package:flutter/material.dart';

class TextUsername extends StatelessWidget {
  final String data;
  final Color color;
  final int maxLine;
  final TextOverflow overFlow;

  const TextUsername(this.data,
      {Key key, this.color = Colors.white, this.maxLine, this.overFlow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        fontFamily: 'Roboto Condensed',
        fontSize: 14.0,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      maxLines: maxLine,
      overflow: overFlow,
    );
  }
}
