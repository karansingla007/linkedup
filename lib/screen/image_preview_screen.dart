import 'package:flutter/material.dart';
import 'package:zoomclone/custom/image_loader.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String image;

  const ImagePreviewScreen({
    Key key,
    @required this.image,
  })  : assert(image != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: 'imageView',
        child: Center(
          child: Container(
            child: ImageLoader.network(image),
          ),
        ),
      ),
    );
  }
}
