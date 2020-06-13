import 'package:flutter/material.dart';

class TextSmallButton extends StatelessWidget {
  final String data;
  final Color color;
  final TextAlign textAlign;
  final bool shadow;
  final int maxLines;

  const TextSmallButton(
    this.data, {
    Key key,
    this.color,
    this.textAlign = TextAlign.center,
    this.shadow = false,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        fontSize: 10.0,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
        color: color,
        shadows: shadow
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
      maxLines: maxLines,
    );
  }
}
