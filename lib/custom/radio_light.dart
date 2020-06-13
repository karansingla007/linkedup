import 'package:flutter/material.dart';
import 'package:zoomclone/utils/constants.dart';

class RadioLight extends StatefulWidget {
  final List<String> labels;

  final String picked;

  final List<String> disabled;

  final void Function(String label, int index) onChange;

  final void Function(String selected) onSelected;
  final TextStyle labelStyle;
  final RadioGroupedButtonsOrientation orientation;

  final Widget Function(Radio radioButton, Text label, int index) itemBuilder;

  final Color activeColor;

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry margin;
  final double width;

  RadioLight(
      {Key key,
      @required this.labels,
      this.picked,
      this.disabled,
      this.onChange,
      this.onSelected,
      this.labelStyle = const TextStyle(),
      this.activeColor, //defaults to toggleableActiveColor,
      this.orientation = RadioGroupedButtonsOrientation.VERTICAL,
      this.itemBuilder,
      this.padding = const EdgeInsets.all(0.0),
      this.margin = const EdgeInsets.all(0.0),
      this.width})
      : super(key: key);

  @override
  _RadioLightState createState() => _RadioLightState();
}

class _RadioLightState extends State<RadioLight> {
  String _selected;

  @override
  void initState() {
    super.initState();

    //set the selected to the picked (if not null)
    _selected = widget.picked ?? "";
  }

  @override
  Widget build(BuildContext context) {
    //set the selected to the picked (if not null)
    _selected = widget.picked ?? _selected;

    List<Widget> content = [];
    for (int i = 0; i < widget.labels.length; i++) {
      Radio rb = Radio(
        activeColor:
            widget.activeColor ?? Theme.of(context).toggleableActiveColor,
        groupValue: widget.labels.indexOf(_selected),
        value: i,
        onChanged: (widget.disabled != null &&
                widget.disabled.contains(widget.labels.elementAt(i)))
            ? null
            : (var index) => setState(() {
                  _selected = widget.labels.elementAt(i);

                  if (widget.onChange != null)
                    widget.onChange(widget.labels.elementAt(i), i);
                  if (widget.onSelected != null)
                    widget.onSelected(widget.labels.elementAt(i));
                }),
      );

      Text t = Text(widget.labels.elementAt(i),
          style: (widget.disabled != null &&
                  widget.disabled.contains(widget.labels.elementAt(i)))
              ? widget.labelStyle.apply(color: Theme.of(context).disabledColor)
              : widget.labelStyle);

      //use user defined method to build
      if (widget.itemBuilder != null)
        content.add(widget.itemBuilder(rb, t, i));
      else {
        //otherwise, use predefined method of building

        //vertical orientation means Column with Row inside
        if (widget.orientation == RadioGroupedButtonsOrientation.VERTICAL) {
          content.add(Row(children: <Widget>[
            SizedBox(width: 8.0),
            rb,
            SizedBox(width: 8.0),
            t,
          ]));
        } else if (widget.orientation ==
            RadioGroupedButtonsOrientation.HORIZONTAL) {
          //horizontal orientation means Row with Column inside

          content.add(Column(children: <Widget>[
            rb,
            SizedBox(width: 8.0),
            t,
          ]));
        } else {
          content.add(Container(
              color: Colors.transparent,
              width: widget.width ?? 180.0,
              child: Row(children: <Widget>[
                rb,
                GestureDetector(
                  child: t,
                  onTap: () {
                    widget.onSelected(widget.labels.elementAt(i));
                  },
                ),
              ])));
        }
      }
    }

    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: widget.orientation == RadioGroupedButtonsOrientation.VERTICAL
          ? Column(children: content)
          : widget.orientation == RadioGroupedButtonsOrientation.HORIZONTAL
              ? Row(children: content)
              : Wrap(children: content),
    );
  }
}
