import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/hero_text.dart';
import 'package:zoomclone/atoms/text_small_title.dart';

class SplashItem extends StatelessWidget {
  final String image;
  final String text;
  final String title;

  const SplashItem({Key key, this.image, this.text, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          TextHero(title),
          SizedBox(
            height: 4,
          ),
          TextSmallTitle(
            text,
            textAlign: TextAlign.center,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 300,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
