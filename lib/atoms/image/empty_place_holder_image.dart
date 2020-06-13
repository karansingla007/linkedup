import 'package:flutter/material.dart';
import 'package:zoomclone/custom/image_loader.dart';

class EmptyPlaceHolderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImageLoader.asset(
      'assets/images/empty_place_holder_image.svg',
      height: 200.0,
      width: 200.0,
    );
  }

  const EmptyPlaceHolderImage();
}
