import 'package:flutter/material.dart';

class LargeTitle extends StatelessWidget {
  final String data;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final Color color;
  final TextOverflow overflow;
  final int maxLines;
  final bool shadowEnabled;

  const LargeTitle(this.data,
      {Key key,
      this.fontWeight = FontWeight.normal,
      this.textAlign,
      this.color = Colors.white,
      this.overflow,
      this.maxLines,
      this.shadowEnabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        fontSize: 40.0,
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight,
        color: color,
        shadows: shadowEnabled
            ? <Shadow>[
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 8.0,
                  color: Colors.black12,
                ),
              ]
            : null,
      ),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}
