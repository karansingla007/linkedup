import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomclone/atoms/text_big_hero.dart';
import 'package:zoomclone/bloc/live_discussion_screen/live_discussion_screen.dart';
import 'package:zoomclone/buttons/shape_button_small.dart';
import 'package:zoomclone/screen/create_session_screen.dart';
import 'package:zoomclone/shimmer/shimmer_list.dart';
import 'package:zoomclone/utils/strings.dart';
import 'package:zoomclone/utils/util.dart';
import 'package:zoomclone/widgets/empty_place_holder.dart';
import 'package:zoomclone/widgets/short_live_discussion_info.dart';
import 'package:zoomclone/widgets/short_schedule_discussion_info.dart';

import 'meeting_detail_screen.dart';

class LiveDiscussionScreen extends StatelessWidget {
  final LiveDiscussionScreenBloc liveDiscussionScreenBloc =
      LiveDiscussionScreenBloc();
  final LiveDiscussionScreenBloc scheduleDiscussionScreenBloc =
      LiveDiscussionScreenBloc();

  LiveDiscussionScreen() {
    liveDiscussionScreenBloc.add(LoadLiveDiscussionScreen());
  }

  Future<void> onRefresh() async {
    liveDiscussionScreenBloc.add(LoadLiveDiscussionScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        BlocListener(
                          bloc: liveDiscussionScreenBloc,
                          listener: (context, state) {
                            if (state is LiveDiscussionScreenLoaded) {
                              scheduleDiscussionScreenBloc.add(
                                  LoadScheduleDiscussionScreen(
                                      state.liveSessionList));
                            }
                          },
                          child: Column(
                            children: <Widget>[
                              BlocBuilder(
                                  bloc: liveDiscussionScreenBloc,
                                  builder: (context, state) {
                                    if (state is LiveDiscussionScreenLoaded) {
                                      if (Util.isValidList(
                                          state.liveSessionList)) {
                                        if (Util.isValidList(
                                            state.liveSessionList)) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12.0, left: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  TextBigHero(
                                                    Strings.LIVE,
                                                    color: Colors.black87,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      } else {
                                        return Container();
                                      }
                                    } else {
                                      return Container();
                                    }
                                  }),
                              BlocBuilder(
                                bloc: liveDiscussionScreenBloc,
                                builder: (context, state) {
                                  if (state is LiveDiscussionScreenLoading) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: ShimmerList(
                                        screenHeight: 250,
                                        widthOfSingleElement:
                                            MediaQuery.of(context).size.width -
                                                32.0,
                                      ),
                                    );
                                  } else if (state
                                      is LiveDiscussionScreenLoaded) {
                                    if (Util.isValidList(
                                        state.liveSessionList)) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: state.liveSessionList.length,
                                        itemBuilder: (context, index) {
                                          return ShortLiveDiscussionInfo(
                                            sessionTitle:
                                                state.liveSessionList[index]
                                                    ['title'],
                                            sessionDescription:
                                                state.liveSessionList[index]
                                                    ['description'],
                                            sessionId:
                                                state.liveSessionList[index]
                                                    ['sessionId'],
                                          );
                                        },
                                      );
                                    } else {
                                      return Container();
                                    }
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            BlocBuilder(
                                bloc: scheduleDiscussionScreenBloc,
                                builder: (context, state) {
                                  if (state is ScheduleDiscussionScreenLoaded) {
                                    if (Util.isValidList(
                                        state.scheduleSessionList)) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 12.0, left: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              TextBigHero(
                                                Strings.SCHEDULE,
                                                color: Colors.black87,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      if (!Util.isValidList(
                                              state.liveSessionList) &&
                                          !Util.isValidList(
                                              state.scheduleSessionList)) {
                                        return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                100,
                                            child: Center(
                                                child: EmptyPlaceHolder(
                                              button: ShapeButtonSmall(
                                                text: 'Create Meeting',
                                                width: 200.0,
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CreateSessionScreen()),
                                                  );
                                                },
                                              ),
                                            )));
                                      } else {
                                        return Container();
                                      }
                                    }
                                  } else {
                                    return Container();
                                  }
                                }),
                            BlocBuilder(
                              bloc: scheduleDiscussionScreenBloc,
                              builder: (context, state) {
                                if (state is LiveDiscussionScreenLoading) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: ShimmerList(
                                      screenHeight: 250,
                                      widthOfSingleElement:
                                          MediaQuery.of(context).size.width -
                                              32.0,
                                    ),
                                  );
                                } else if (state
                                    is ScheduleDiscussionScreenLoaded) {
                                  if (Util.isValidList(
                                      state.scheduleSessionList)) {
                                    return ListView.builder(
                                      padding:
                                          const EdgeInsets.only(bottom: 64.0),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          state.scheduleSessionList.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MeetingDetailScreen()),
                                              );
                                            },
                                            child: ShortScheduleDiscussionInfo(
                                              sessionTitle:
                                                  state.scheduleSessionList[
                                                      index]['title'],
                                              sessionDescription:
                                                  state.scheduleSessionList[
                                                      index]['description'],
                                              sessionStartTime:
                                                  state.scheduleSessionList[
                                                          index]
                                                      ['sessionStartTimeStamp'],
                                              sessionId:
                                                  state.scheduleSessionList[
                                                      index]['sessionId'],
                                            ));
                                      },
                                    );
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
