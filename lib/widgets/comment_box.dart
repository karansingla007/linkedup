import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/text_input.dart';

class CommentBox extends StatelessWidget {
  final Function(String) onClickSend;

  CommentBox({this.onClickSend});

  final TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            color: Colors.transparent,
            border: Border.all(width: 1.2, color: Colors.white)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextInput(
                  maxLines: 2,
                  controller: commentController,
                  minLines: 1,
                  hintText: 'Comment...',
                  hintStyle: TextStyle(fontSize: 14.0, color: Colors.white70),
                  focusBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  textColor: Colors.white,
                  cursorColor: Colors.white,
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  onClickSend(commentController.text);
                  commentController.text = '';
                },
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ));
  }
}
