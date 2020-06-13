import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/text_small_title.dart';

class ShapeButtonBigFillIcon extends StatelessWidget {
  final String text;
  final GestureTapCallback onPressed;
  final Color color;
  final Color textColor;
  final Widget icon;

  const ShapeButtonBigFillIcon(
      {Key key,
      @required this.onPressed,
      @required this.text,
      this.icon,
      this.textColor,
      this.color})
      : assert(onPressed != null),
        assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 128.0),
        child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: Colors.black12, width: 1)),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 28.0, right: 28.0, top: 8, bottom: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                icon ?? Container(),
                SizedBox(
                  width: 8,
                ),
                TextSmallTitle(
                  text,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
