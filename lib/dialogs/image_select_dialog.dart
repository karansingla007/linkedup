import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/text_small_title.dart';
import 'package:zoomclone/buttons/shape_button_small.dart';
import 'package:zoomclone/molecule/circle_image.dart';

class ImageSelectDialog extends StatefulWidget {
  final Function() onSelecteGallery;
  final Function(String) onClickSave;

  ImageSelectDialog(this.onSelecteGallery, this.onClickSave);

  @override
  _ImageSelectDialogState createState() => _ImageSelectDialogState();
}

class _ImageSelectDialogState extends State<ImageSelectDialog> {
  String selectImage = 'https://linkedup.s3.ap-south-1.amazonaws.com/avataar/myAvatar.png';
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            TextSmallTitle('Select Image'),
            Expanded(child: Container(),),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                widget.onSelecteGallery();
              },
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 1)
                  ),
                  child: Icon(Icons.photo)),
            ),
          ],
        ),
        SizedBox(height: 16,),
        Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
setState(() {
  selectImage = 'https://linkedup.s3.ap-south-1.amazonaws.com/avataar/myAvatar.png';
});
              },
                child: CircleImageWithBorder('https://linkedup.s3.ap-south-1.amazonaws.com/avataar/myAvatar.png', height: 32.0, width: 32.0,)),
            SizedBox(width: 8,),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectImage = 'https://linkedup.s3.ap-south-1.amazonaws.com/avataar/myAvatar-2.png';
                });

              },
                child: CircleImageWithBorder('https://linkedup.s3.ap-south-1.amazonaws.com/avataar/myAvatar-2.png', height: 32.0, width: 32.0,)),
            SizedBox(width: 8,),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectImage = 'https://linkedup.s3.ap-south-1.amazonaws.com/avataar/myAvatar-3.png';
                });

              },
                child: CircleImageWithBorder('https://linkedup.s3.ap-south-1.amazonaws.com/avataar/myAvatar-3.png', height: 32.0, width: 32.0,)),
          ],
        ),
SizedBox(height: 16,),
        CircleImageWithBorder(selectImage, height: 80.0, width: 80.0,),

        SizedBox(height: 32,),
        ShapeButtonSmall(text: 'SAVE', onPressed: () {
widget.onClickSave(selectImage);
Navigator.pop(context);
        },),
      ],
    );
  }
}