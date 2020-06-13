import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutoComplete extends StatelessWidget {
  final SuggestionsCallback suggestionsCallback;
  final ItemBuilder itemBuilder;
  final SuggestionSelectionCallback suggestionSelectionCallback;
  final String labelText;
  final String hintText;
  final TextEditingController textEditingController;
  final AxisDirection direction;
  final InputBorder focusedBorder;
  final InputBorder enabledBorder;
  final ValueChanged<dynamic> onSubmitted;
  final Function(dynamic) onChanged;
  final bool autoFocus;
  final TextStyle hintStyle;
  final TextStyle labelStyle;

  const AutoComplete({
    Key key,
    @required this.suggestionsCallback,
    @required this.itemBuilder,
    @required this.suggestionSelectionCallback,
    this.labelText,
    this.hintText,
    this.textEditingController,
    this.direction,
    this.focusedBorder,
    this.enabledBorder,
    this.onSubmitted,
    this.onChanged,
    this.autoFocus = false,
    this.hintStyle = const TextStyle(color: Colors.black26, fontSize: 14),
    this.labelStyle = const TextStyle(color: Colors.black54, fontSize: 20),
  })  : assert(suggestionsCallback != null),
        assert(itemBuilder != null),
        assert(suggestionSelectionCallback != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: textEditingController,
        onChanged: onChanged,
        autofocus: autoFocus,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          focusedBorder: focusedBorder ??
              UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
          enabledBorder: enabledBorder ??
              UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
          labelStyle: labelStyle,
          hintStyle: hintStyle,
        ),
        onSubmitted: onSubmitted,
      ),
      direction: direction ?? AxisDirection.up,
      hideOnEmpty: true,
      hideOnError: true,
      hideOnLoading: true,
      suggestionsCallback: suggestionsCallback,
      onSuggestionSelected: suggestionSelectionCallback,
      itemBuilder: itemBuilder,
    );
  }
}
