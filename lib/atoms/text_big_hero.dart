import 'package:flutter/material.dart';

class TextBigHero extends StatelessWidget {
  final String data;
  final TextAlign textAlign;
  final Color color;
  final bool shadowEnabled;

  const TextBigHero(
    this.data, {
    Key key,
    this.textAlign = TextAlign.center,
    this.shadowEnabled = false,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: _getStyle(),
      textAlign: textAlign,
    );
  }

  TextStyle _getStyle() {
    return TextStyle(
      fontFamily: 'Roboto Condensed',
      fontSize: 22.0,
      color: color,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.bold,
      shadows: shadowEnabled
          ? <Shadow>[
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 6.0,
                color: Colors.black12,
              ),
            ]
          : null,
    );
  }
}
