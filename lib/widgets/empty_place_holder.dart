import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/image/empty_place_holder_image.dart';
import 'package:zoomclone/atoms/text_big_button.dart';
import 'package:zoomclone/utils/strings.dart';

class EmptyPlaceHolder extends StatelessWidget {
  final Widget image;
  final String text;
  final String subHeading;
  final Widget button;
  final MainAxisSize mainAxisSize;

  EmptyPlaceHolder({
    Key key,
    this.image = const EmptyPlaceHolderImage(),
    this.text = Strings.THERE_IS_NOTHING_HERE_YET,
    this.subHeading = "",
    this.button,
    this.mainAxisSize = MainAxisSize.min,
  })  : assert(text != null),
        assert(image != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: mainAxisSize ?? MainAxisSize.max,
        children: <Widget>[
          image,
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
            child: TextBigButton(
              text,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextBigButton(
              subHeading,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          button ?? Container(),
        ],
      ),
    );
  }
}
