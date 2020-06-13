import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/text_small_title.dart';

class RoundedShapeButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onPressed;
  final Color color;
  final Color textColor;

  const RoundedShapeButton(
      {Key key,
      @required this.onPressed,
      @required this.text,
      this.textColor = Colors.white,
      this.color = Colors.blue})
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
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.black12, width: 1)),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 60.0, right: 60.0, top: 8, bottom: 8.0),
            child: TextSmallTitle(
              text,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
