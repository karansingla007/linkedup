import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';
import 'package:zoomclone/atoms/hero_text.dart';
import 'package:zoomclone/atoms/text_input.dart';
import 'package:zoomclone/atoms/text_small_title.dart';
import 'package:zoomclone/bloc/meeting_detail/meeting_detail.dart';
import 'package:zoomclone/buttons/rounded_shape_button.dart';
import 'package:zoomclone/custom/wave_loader.dart';
import 'package:zoomclone/utils/constants.dart';
import 'package:zoomclone/utils/strings.dart';
import 'package:zoomclone/utils/time_util.dart';
import 'package:zoomclone/utils/util.dart';
import 'package:zoomclone/widgets/live_discussion_toggle.dart';

import 'invite_speaker_screen.dart';

class EditSessionScreen extends StatefulWidget {
  final String sessionId;

  EditSessionScreen(this.sessionId);

  @override
  _EditSessionScreenState createState() => _EditSessionScreenState();
}

class _EditSessionScreenState extends State<EditSessionScreen> {
  final TextEditingController sessionTitleController = TextEditingController();

  final TextEditingController sessionDescriptionController =
      TextEditingController();
  final MeetingDetailBloc meetingDetailBloc = MeetingDetailBloc();
  String liveTimeStatus;
  int selectedDateTimeEpoch;

  @override
  void initState() {
    super.initState();
    meetingDetailBloc.add(LoadMeetingDetail(widget.sessionId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextHero(Strings.EDIT_A_MEETING),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: BlocListener(
        bloc: meetingDetailBloc,
        listener: (context, state) {
          if (state is MeetingDetailLoaded) {
            sessionTitleController.text = state.sessionInfo['title'];
            sessionDescriptionController.text =
                state.sessionInfo['description'];
            if (state.sessionInfo['sessionStartTimeStamp'] != null) {
              if (TimeUtil.convertDateToTimeStamp(
                      state.sessionInfo['sessionStartTimeStamp']) <=
                  TimeUtil.getCurrentEpochTimeStamp()) {
                liveTimeStatus = Constants.NOW;
              } else {
                liveTimeStatus = Constants.LATER;
                selectedDateTimeEpoch = TimeUtil.convertDateToTimeStamp(
                    state.sessionInfo['sessionStartTimeStamp']);
              }
            }
          }
        },
        child: BlocBuilder(
          bloc: meetingDetailBloc,
          builder: (context, state) {
            if (state is MeetingDetailLoading) {
              return WaveLoader.spinKit();
            } else if (state is MeetingDetailLoaded) {
              return Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        TextInput(
                          controller: sessionTitleController,
                          label: Strings.TITLE,
                          hintText: Strings.TYPE_YOUR_TITLE,
                          minLines: 1,
                          maxLines: 2,
                          maxLength: Constants.TITLE_LENGTH,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextInput(
                          controller: sessionDescriptionController,
                          label: Strings.DESCRIPTION,
                          minLines: 1,
                          maxLines: 3,
                          hintText: Strings.TYPE_YOUR_DESCRIPTION,
                          maxLength: Constants.DESCRIPTION_LENGTH,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                2.0,
                              ),
                              border:
                                  Border.all(width: 1, color: Colors.black12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextSmallTitle(
                                    Strings.WHEN_WOULD_YOU_LIKE_TO_GO_LIVE,
                                    color: Colors.black,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: LiveDiscussionToggle(
                                      onSelectedValue: (status) {
                                        setState(() {
                                          liveTimeStatus = status;
                                        });
                                      },
                                      isToggleActive: Util.isStringNotNull(
                                                  liveTimeStatus) &&
                                              liveTimeStatus == Constants.LATER
                                          ? true
                                          : false,
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        Util.isStringNotNull(liveTimeStatus) &&
                                            liveTimeStatus == Constants.LATER,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await Util.showDatePickerBottomSheet(
                                            context, onSelectDate);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 24.0, left: 8, right: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                            color: Colors.blueAccent,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0, bottom: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.schedule,
                                                  color: Colors.white70,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                TextSmallTitle(
                                                    selectedDateTimeEpoch !=
                                                            null
                                                        ? TimeUtil.getDateAndTime(
                                                            selectedDateTimeEpoch)
                                                        : Strings
                                                            .PICK_DATE_AND_TIME),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: RoundedShapeButton(
                            text: Strings.ADD_SPEAKER,
                            onPressed: () {
                              if (isDataValid()) {
                                Map body = Map();
                                body['title'] = sessionTitleController.text;
                                body['description'] =
                                    sessionDescriptionController.text;
                                body['sessionStartTimeStamp'] =
                                    selectedDateTimeEpoch == null
                                        ? TimeUtil.convertDateToTimeStamp(
                                            state.sessionInfo[
                                                'sessionStartTimeStamp'])
                                        : selectedDateTimeEpoch.toString();
                                body['speakerUsers'] =
                                    state.sessionInfo['speakerUsers'];
                                body['sessionId'] =
                                    state.sessionInfo['sessionId'];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => InviteSpeakerScreen(
                                          body,
                                          isFromEdit: true)),
                                );
                              } else {
                                Toast.show(
                                  Strings.PLEASE_ENTER_VALID_DATA,
                                  context,
                                  gravity: Toast.CENTER,
                                  duration: Toast.LENGTH_LONG,
                                );
                              }
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                          ),
                        )),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  bool isDataValid() {
    return (Util.isStringNotNull(sessionTitleController.text) &&
        Util.isStringNotNull(sessionDescriptionController.text));
  }

  void onSelectDate(int date) {
    setState(() {
      selectedDateTimeEpoch = date;
    });
  }
}
