import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/hero_text.dart';
import 'package:zoomclone/atoms/text_input.dart';
import 'package:zoomclone/buttons/rounded_shape_button.dart';
import 'package:zoomclone/screen/meeting_detail_screen.dart';
import 'package:zoomclone/utils/strings.dart';

class JoinMeetingScreen extends StatelessWidget {
  final TextEditingController meetingIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextHero(Strings.JOIN_A_MEETING),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.transparent,
                  border: Border.all(width: 1, color: Colors.blueAccent)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: TextInput(
                  maxLength: 10,
                  counterText: "",
                  controller: meetingIdController,
                  focusBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: Strings.ENTER_MEETING_ID,
                  fontSize: 18.0,
                  hintStyle: TextStyle(fontSize: 18.0, color: Colors.black26),
                ),
              ),
            ),
            SizedBox(
              height: 52,
            ),
            RoundedShapeButton(
              text: Strings.CONTINUE,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MeetingDetailScreen(
                            meetingId: meetingIdController.text,
                          )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
