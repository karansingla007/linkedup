import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomclone/atoms/hero_text.dart';
import 'package:zoomclone/bloc/my_meetings/my_meetings.dart';
import 'package:zoomclone/shimmer/shimmer_list.dart';
import 'package:zoomclone/utils/constants.dart';
import 'package:zoomclone/utils/strings.dart';
import 'package:zoomclone/widgets/short_ended_discussion_info.dart';
import 'package:zoomclone/widgets/short_live_discussion_info.dart';
import 'package:zoomclone/widgets/short_schedule_discussion_info.dart';

class MyMeetingsScreen extends StatelessWidget {
  final MyMeetingsBloc myMeetingsBloc = MyMeetingsBloc();

  MyMeetingsScreen() {
    myMeetingsBloc.add(LoadMyMeetings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextHero(Strings.MY_MEETING),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: <Widget>[
            BlocBuilder(
                bloc: myMeetingsBloc,
                builder: (context, state) {
                  if (state is MyMeetingsLoading) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                      child: ShimmerList(
                        screenHeight: MediaQuery.of(context).size.height - 140,
                        widthOfSingleElement:
                            MediaQuery.of(context).size.width - 16.0,
                      ),
                    );
                  } else if (state is MyMeetingsLoaded) {
                    return Flexible(
                      child: ListView.builder(
                        itemCount: state.response.length,
                        itemBuilder: (context, index) {
                          if (state.response[index]['status'] ==
                              Constants.ENDED) {
                            return ShortEndedDiscussionInfo(
                              sessionTitle: state.response[index]['title'],
                              sessionDescription: state.response[index]
                                  ['description'],
                              sessionId: state.response[index]['sessionId'],
                            );
                          } else if (state.response[index]['status'] ==
                              Constants.SCHEDULE) {
                            return ShortScheduleDiscussionInfo(
                              sessionTitle: state.response[index]['title'],
                              sessionDescription: state.response[index]
                                  ['description'],
                              sessionStartTime: state.response[index]
                                  ['sessionStartTimeStamp'],
                              sessionId: state.response[index]['sessionId'],
                            );
                          } else if (state.response[index]['status'] ==
                              Constants.LIVE) {
                            return ShortLiveDiscussionInfo(
                              sessionTitle: state.response[index]['title'],
                              sessionDescription: state.response[index]
                                  ['description'],
                              sessionId: state.response[index]['sessionId'],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
