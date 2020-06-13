import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/text_button_small.dart';

class ShapeButtonSmall extends StatefulWidget {
  final double height;
  final double width;
  final String text;
  final GestureTapCallback onPressed;
  final Color color;
  final Color backgroundColor;
  final bool isEnable;

  const ShapeButtonSmall({
    Key key,
    @required this.onPressed,
    @required this.text,
    this.height = 24.0,
    this.width,
    this.color = Colors.black,
    this.backgroundColor,
    this.isEnable = true,
  })  : assert(onPressed != null),
        assert(text != null),
        super(key: key);

  @override
  _ShapeButtonSmallState createState() =>
      _ShapeButtonSmallState(isEnable: isEnable);
}

class _ShapeButtonSmallState extends State<ShapeButtonSmall> {
  bool isEnable;

  _ShapeButtonSmallState({this.isEnable});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      color: widget.backgroundColor,
      child: OutlineButton(
        padding: EdgeInsets.only(left: 0, right: 0),
        onPressed: () {
          widget.onPressed();
          setState(() {
            isEnable = false;
          });
        },
        textColor: widget.color,
        highlightedBorderColor: getColor(),
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 1.0,
          color: getColor(),
        ),
        child: TextSmallButton(
          widget.text.toUpperCase(),
          color: getColor(),
        ),
      ),
    );
  }

  Color getColor() {
    return isEnable ? widget.color : Colors.grey;
  }
}
