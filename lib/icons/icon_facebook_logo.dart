import 'package:flutter/material.dart';
import 'package:zoomclone/custom/image_loader.dart';

class IconFacebookLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImageLoader.asset(
      'assets/images/logo_facebook.svg',
      height: 18.0,
      width: 18.0,
    );
  }
}
