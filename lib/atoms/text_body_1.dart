import 'package:flutter/material.dart';

class TextBody1 extends StatelessWidget {
  final String data;
  final Color color;
  final bool shadowEnabled;
  final TextAlign textAlign;
  final TextOverflow textOverflow;
  final int maxLine;

  const TextBody1(
    this.data, {
    Key key,
    this.color,
    this.shadowEnabled = true,
    this.textAlign = TextAlign.left,
    this.textOverflow,
    this.maxLine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        color: color,
        fontSize: 12.0,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
        shadows: shadowEnabled
            ? <Shadow>[
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 6.0,
                  color: Colors.black,
                ),
              ]
            : null,
      ),
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: maxLine,
    );
  }
}
