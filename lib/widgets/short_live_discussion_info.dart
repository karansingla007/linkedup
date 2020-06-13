import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/hero_text.dart';
import 'package:zoomclone/atoms/text_small_title.dart';
import 'package:zoomclone/screen/meeting_detail_screen.dart';

class ShortLiveDiscussionInfo extends StatelessWidget {
  final String sessionTitle;
  final String sessionDescription;
  final String sessionId;

  ShortLiveDiscussionInfo({
    @required this.sessionTitle,
    @required this.sessionDescription,
    @required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MeetingDetailScreen(meetingId: sessionId)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: Colors.black12, width: 1)),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextHero(
                      sessionTitle,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 65,
                      child: TextSmallTitle(
                        sessionDescription,
                        color: Colors.black,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000.0),
                        color: Colors.red,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
