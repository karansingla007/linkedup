import 'package:flutter/material.dart';
import 'package:zoomclone/custom/image_loader.dart';

class IconGoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImageLoader.asset(
      'assets/images/logo_google.svg',
      height: 18.0,
      width: 18.0,
    );
  }
}
