import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';
import 'package:zoomclone/atoms/hero_text.dart';
import 'package:zoomclone/atoms/text_big_title.dart';
import 'package:zoomclone/atoms/text_body_2.dart';
import 'package:zoomclone/atoms/text_small_title.dart';
import 'package:zoomclone/bloc/meeting_detail/meeting_detail.dart';
import 'package:zoomclone/bloc/user_detail/user_detail.dart';
import 'package:zoomclone/buttons/rounded_shape_button.dart';
import 'package:zoomclone/buttons/shape_button_small.dart';
import 'package:zoomclone/custom/share_helper.dart';
import 'package:zoomclone/custom/wave_loader.dart';
import 'package:zoomclone/dialogs/confirmation_dialog.dart';
import 'package:zoomclone/screen/edit_session_screen.dart';
import 'package:zoomclone/screen/home_screen.dart';
import 'package:zoomclone/screen/live_meeting.dart';
import 'package:zoomclone/utils/constants.dart';
import 'package:zoomclone/utils/strings.dart';
import 'package:zoomclone/utils/time_util.dart';
import 'package:zoomclone/utils/util.dart';
import 'package:zoomclone/widgets/session_profile_detail.dart';

class MeetingDetailScreen extends StatelessWidget {
  final String meetingId;
  final MeetingDetailBloc meetingDetailBloc = MeetingDetailBloc();
  final MeetingDetailBloc startMeetingBloc = MeetingDetailBloc();
  final MeetingDetailBloc deletMeetingBloc = MeetingDetailBloc();
  final UserDetailBloc userDetailBloc = UserDetailBloc();
  String status;
  String userRole;

  MeetingDetailScreen({this.meetingId}) {
    meetingDetailBloc.add(LoadMeetingDetail(meetingId));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!Navigator.canPop(context)) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: TextHero(Strings.MEETING_DETAIL),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
          actions: <Widget>[
            BlocBuilder(
              bloc: userDetailBloc,
              builder: (context, state) {
                if (state is UserDetailLoaded) {
                  return Visibility(
                    visible: status == Constants.SCHEDULE &&
                        state.data['isCurrentUser'],
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditSessionScreen(meetingId)),
                          );
                        },
                        child: Icon(Icons.edit)),
                  );
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(
              width: 16,
            ),
            BlocListener(
              bloc: deletMeetingBloc,
              listener: (context, state) {
                if (state is MeetingDetailDeleted) {
                  Toast.show(
                    Strings.MEETING_DELETED,
                    context,
                    gravity: Toast.CENTER,
                    duration: Toast.LENGTH_LONG,
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else if (state is MeetingDetailNotLoaded) {
                  Toast.show(
                    Strings.SOMETHING_WENT_WRONG,
                    context,
                    gravity: Toast.CENTER,
                    duration: Toast.LENGTH_LONG,
                  );
                }
              },
              child: BlocBuilder(
                bloc: userDetailBloc,
                builder: (context, state) {
                  if (state is UserDetailLoaded) {
                    return Visibility(
                      visible: status == Constants.SCHEDULE &&
                          state.data['isCurrentUser'],
                      child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      elevation: 20,
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.white,
                                          width: 1.0,
                                          style: BorderStyle.solid,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      content: ConfirmationDialog(
                                        heading: 'Delete meeting',
                                        subHeading:
                                            'Are you sure you want to delete this meeting?',
                                        button: BlocBuilder(
                                          bloc: deletMeetingBloc,
                                          builder: (context, state) {
                                            if (state
                                                is MeetingDetailDeleting) {
                                              return WaveLoader.spinKit(
                                                  size: 20);
                                            } else {
                                              return ShapeButtonSmall(
                                                text: 'Delete',
                                                onPressed: () {
                                                  deletMeetingBloc.add(
                                                      DeleteMeeting(meetingId));
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ));
                                });
                          },
                          child: Icon(Icons.delete_forever)),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
        body: BlocListener(
          bloc: meetingDetailBloc,
          listener: (context, state) {
            if (state is MeetingDetailLoaded) {
              userRole = state.sessionInfo['userRole'];
              status = state.sessionInfo['status'];
              userDetailBloc.add(LoadIsCurrentUser(
                  userId: state.sessionInfo['hostUser']['userId']));
            }
          },
          child: BlocBuilder(
            bloc: meetingDetailBloc,
            builder: (context, state) {
              if (state is MeetingDetailLoaded) {
                return Stack(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextBigTitle(
                              state.sessionInfo['title'],
                              color: Colors.black,
                              textAlign: TextAlign.start,
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextSmallTitle(
                              state.sessionInfo['description'],
                              color: Colors.black87,
                              textAlign: TextAlign.start,
                              maxLines: 4,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 300.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  border: Border.all(
                                      color: Colors.black12, width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextBody2(
                                        'Host',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    SessionProfileDetail(
                                      profilePicUrl:
                                          state.sessionInfo['hostUser']
                                              ['profilePicUrl'],
                                      userName: state.sessionInfo['hostUser']
                                          ['userName'],
                                      firstName: state.sessionInfo['hostUser']
                                          ['firstName'],
                                      lastName: state.sessionInfo['hostUser']
                                          ['lastName'],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Visibility(
                                      visible: Util.isValidList(
                                          state.sessionInfo['speakerUsers']),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: TextBody2('Speakers'),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      height: 185,
                                      child: Util.isValidList(
                                              state.sessionInfo['speakerUsers'])
                                          ? ListView.separated(
                                              separatorBuilder:
                                                  (context, index) => Divider(
                                                color: Colors.white,
                                                height: 16,
                                              ),
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              itemCount: state
                                                  .sessionInfo['speakerUsers']
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return SessionProfileDetail(
                                                  profilePicUrl: state
                                                              .sessionInfo[
                                                          'speakerUsers'][index]
                                                      ['profilePicUrl'],
                                                  userName: state.sessionInfo[
                                                          'speakerUsers'][index]
                                                      ['userName'],
                                                  firstName: state.sessionInfo[
                                                          'speakerUsers'][index]
                                                      ['firstName'],
                                                  lastName: state.sessionInfo[
                                                          'speakerUsers'][index]
                                                      ['lastName'],
                                                );
                                              },
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 60.0),
                        child: TextBody2('Start At ' +
                            TimeUtil.getDateAndTimeByDate(
                                state.sessionInfo['sessionStartTimeStamp'])),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundedShapeButton(
                              text: 'Share',
                              color: Colors.redAccent,
                              onPressed: () {
                                String shareUrl =
                                    'https://linkedUp.co.in/meeting/' +
                                        meetingId;
                                ShareHelper().shareOnSocial(shareUrl);
                              },
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            state.sessionInfo['status'] == Constants.SCHEDULE
                                ? BlocBuilder(
                                    bloc: userDetailBloc,
                                    builder: (context, userDetailState) {
                                      if (userDetailState is UserDetailLoaded) {
                                        if (userDetailState
                                            .data['isCurrentUser']) {
                                          return BlocBuilder(
                                            bloc: startMeetingBloc,
                                            builder:
                                                (context, startMeetingState) {
                                              if (startMeetingState
                                                  is MeetingDetailStarting) {
                                                return Container(
                                                  height: 20,
                                                  width: 128,
                                                  child: WaveLoader.spinKit(
                                                      size: 20),
                                                );
                                              } else if (startMeetingState
                                                  is MeetingDetailStarted) {
                                                return RoundedShapeButton(
                                                  text: 'Join',
                                                  onPressed: () {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LiveMeeting(
                                                                meetingId:
                                                                    meetingId,
                                                                userRole:
                                                                    userRole,
                                                                hostUser: state
                                                                        .sessionInfo[
                                                                    'hostUser'],
                                                              )),
                                                    );
                                                  },
                                                );
                                              } else {
                                                return RoundedShapeButton(
                                                  text: 'Start',
                                                  onPressed: () {
                                                    startMeetingBloc.add(
                                                        StartMeeting(
                                                            meetingId));
                                                  },
                                                );
                                              }
                                            },
                                          );
                                        } else {
                                          return Container(
                                            height: 1,
                                          );
                                        }
                                      } else {
                                        return Container(
                                          height: 1,
                                        );
                                      }
                                    },
                                  )
                                : state.sessionInfo['status'] == Constants.LIVE
                                    ? RoundedShapeButton(
                                        text: 'Join',
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LiveMeeting(
                                                      meetingId: meetingId,
                                                      userRole: userRole,
                                                    )),
                                          );
                                        },
                                      )
                                    : Container(
                                        height: 1,
                                      ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              } else if (state is MeetingDetailLoading) {
                return Center(child: WaveLoader.spinKit());
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
