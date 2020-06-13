import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String hintText;
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;
  final int minLines;
  final String errorText;
  final ValueChanged<String> onChanged;
  final int maxLength;
  final ValueChanged<String> onSubmitted;
  final TextStyle errorStyle;
  final FocusNode focusNode;
  final InputBorder errorBorder;
  final InputBorder focusedErrorBorder;
  final bool enabled;
  final EdgeInsetsGeometry contentPadding;
  final bool autoFocus;
  final InputBorder focusBorder;
  final InputBorder enabledBorder;
  final TextInputAction textInputAction;
  final Widget icon;
  final double fontSize;
  final bool readOnly;
  final Color textColor;
  final TextStyle hintStyle;
  final String counterText;
  final Color cursorColor;

  const TextInput({
    Key key,
    this.hintText,
    this.textColor = Colors.black,
    this.label,
    this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.errorText,
    this.onChanged,
    this.maxLength,
    this.onSubmitted,
    this.focusNode,
    this.cursorColor = Colors.black,
    this.errorBorder =
        const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    this.focusedErrorBorder =
        const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    this.errorStyle = const TextStyle(color: Colors.red),
    this.enabled,
    this.contentPadding,
    this.autoFocus = false,
    this.focusBorder =
        const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    this.enabledBorder = const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black54)),
    this.textInputAction,
    this.icon,
    this.fontSize,
    this.readOnly = false,
    this.hintStyle = const TextStyle(fontSize: 14.0, color: Colors.black26),
    this.counterText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: cursorColor,
      onChanged: onChanged,
      readOnly: readOnly,
      focusNode: focusNode,
      autofocus: autoFocus,
      style: TextStyle(color: textColor, fontSize: fontSize),
      enabled: enabled,
      decoration: InputDecoration(
          errorText: errorText,
          errorStyle: errorStyle,
          errorBorder: errorBorder,
          focusedErrorBorder: focusedErrorBorder,
          contentPadding: contentPadding,
          labelText: label,
          focusedBorder: focusBorder,
          enabledBorder: enabledBorder,
          labelStyle: TextStyle(color: Colors.black54, fontSize: fontSize),
          hintStyle: hintStyle,
          hintText: hintText,
          counterText: counterText,
          icon: icon),
      keyboardType: keyboardType,
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      textInputAction: textInputAction,
      onSubmitted: (value) {
        onSubmitted(value);
      },
    );
  }
}
