import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomclone/atoms/text_big_title.dart';
import 'package:zoomclone/atoms/text_body_2.dart';
import 'package:zoomclone/atoms/text_small_title.dart';
import 'package:zoomclone/bloc/meeting_detail/meeting_detail.dart';
import 'package:zoomclone/buttons/rounded_shape_button.dart';
import 'package:zoomclone/custom/share_helper.dart';
import 'package:zoomclone/custom/wave_loader.dart';
import 'package:zoomclone/utils/util.dart';
import 'package:zoomclone/widgets/session_profile_detail.dart';

class MeetingInfoDialog extends StatelessWidget {
  final MeetingDetailBloc meetingDetailBloc = MeetingDetailBloc();
  final String meetingId;

  MeetingInfoDialog(this.meetingId) {
    meetingDetailBloc.add(LoadMeetingDetail(meetingId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: meetingDetailBloc,
      builder: (context, state) {
        if (state is MeetingDetailLoading) {
          return Container(
              height: 350, child: Center(child: WaveLoader.spinKit()));
        } else if (state is MeetingDetailLoaded) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                        border: Border.all(color: Colors.black12, width: 1)),
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
                            profilePicUrl: state.sessionInfo['hostUser']
                                ['profilePicUrl'],
                            userName: state.sessionInfo['hostUser']['userName'],
                            firstName: state.sessionInfo['hostUser']
                                ['firstName'],
                            lastName: state.sessionInfo['hostUser']['lastName'],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Visibility(
                            visible: Util.isValidList(
                                state.sessionInfo['speakerUsers']),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
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
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      color: Colors.white,
                                      height: 16,
                                    ),
                                    padding: const EdgeInsets.all(0.0),
                                    itemCount: state
                                        .sessionInfo['speakerUsers'].length,
                                    itemBuilder: (context, index) {
                                      return SessionProfileDetail(
                                        profilePicUrl:
                                            state.sessionInfo['speakerUsers']
                                                [index]['profilePicUrl'],
                                        userName:
                                            state.sessionInfo['speakerUsers']
                                                [index]['userName'],
                                        firstName:
                                            state.sessionInfo['speakerUsers']
                                                [index]['firstName'],
                                        lastName:
                                            state.sessionInfo['speakerUsers']
                                                [index]['lastName'],
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
                Align(
                  alignment: Alignment.center,
                  child: RoundedShapeButton(
                    text: 'Share',
                    color: Colors.redAccent,
                    onPressed: () {
                      String shareUrl =
                          'https://linkedUp.co.in/meeting/' + meetingId;
                      ShareHelper().shareOnSocial(shareUrl);
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
