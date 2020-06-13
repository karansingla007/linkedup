import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/text_body_1.dart';
import 'package:zoomclone/atoms/text_body_2.dart';
import 'package:zoomclone/utils/constants.dart';

class DropDownCountryCode extends StatefulWidget {
  final List<dynamic> list = Constants.countryCodes;
  final Function(dynamic) onChanged;

  const DropDownCountryCode({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _DropDownCountryCodeState createState() => _DropDownCountryCodeState();
}

class _DropDownCountryCodeState extends State<DropDownCountryCode> {
  dynamic dropDownValue;

  _DropDownCountryCodeState();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.0,
      width: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<dynamic>(
            value: dropDownValue,
            hint: TextBody2('+91', color: Colors.black),
            items: widget.list.map<DropdownMenuItem<dynamic>>((dynamic value) {
              return DropdownMenuItem<dynamic>(
                value: value,
                child: TextBody1(
                  value,
                  color: Colors.black,
                  shadowEnabled: false,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                dropDownValue = value;
                if (widget.onChanged != null) widget.onChanged(value);
              });
            },
          ),
        ),
      ),
    );
  }
}
