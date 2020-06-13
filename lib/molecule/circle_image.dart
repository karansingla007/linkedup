import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/text_big_title.dart';
import 'package:zoomclone/custom/image_loader.dart';
import 'package:zoomclone/styles.dart';
import 'package:zoomclone/utils/util.dart';

class CircleImageWithBorder extends StatelessWidget {
  final String image;
  final String signature;
  final height;
  final width;

  const CircleImageWithBorder(
    this.image, {
    Key key,
    @required this.signature,
    this.height = 88.0,
    this.width = 88.0,
  });

  @override
  Widget build(BuildContext context) {
    if (Util.isStringNotNull(image)) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000.0),
            border: Border.all(width: 1, color: Colors.black38)),
        child: image != null
            ? ImageLoader.network(image,
                borderRadius: BorderRadius.circular(10000.0))
            : null,
      );
    } else {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Styles.getRandomColor()),
        child: Center(
          child: TextBigTitle(
            signature,
            fontWeight: FontWeight.normal,
          ),
        ),
      );
    }
  }
}
