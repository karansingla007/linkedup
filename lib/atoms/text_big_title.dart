import 'package:flutter/material.dart';

class TextBigTitle extends StatelessWidget {
  final String data;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final Color color;
  final TextOverflow overflow;
  final int maxLines;

  const TextBigTitle(this.data,
      {Key key,
      this.fontWeight = FontWeight.normal,
      this.textAlign,
      this.color = Colors.white,
      this.overflow,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        fontSize: 24.0,
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight,
        color: color,
      ),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}
