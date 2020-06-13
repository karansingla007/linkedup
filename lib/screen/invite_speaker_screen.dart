import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomclone/api/api.dart';
import 'package:zoomclone/atoms/text_body_2.dart';
import 'package:zoomclone/bloc/create_session_screen/create_session_screen.dart';
import 'package:zoomclone/buttons/rounded_shape_button.dart';
import 'package:zoomclone/buttons/shape_button_small.dart';
import 'package:zoomclone/custom/wave_loader.dart';
import 'package:zoomclone/molecule/auto_complete.dart';
import 'package:zoomclone/screen/meeting_detail_screen.dart';
import 'package:zoomclone/utils/strings.dart';
import 'package:zoomclone/utils/util.dart';
import 'package:zoomclone/widgets/short_user_info_small_widget.dart';

class InviteSpeakerScreen extends StatefulWidget {
  final Map sessionInfo;
  final bool isFromEdit;

  InviteSpeakerScreen(this.sessionInfo, {this.isFromEdit = false});

  @override
  _InviteSpeakerScreenState createState() => _InviteSpeakerScreenState();
}

class _InviteSpeakerScreenState extends State<InviteSpeakerScreen> {
  final TextEditingController searchController = TextEditingController();
  bool showLocationLoader = false;
  final CreateSessionScreenBloc speakerUserBloc = CreateSessionScreenBloc();
  final CreateSessionScreenBloc createSessionScreenBloc =
      CreateSessionScreenBloc();
  List speakeUserList;

  @override
  void initState() {
    super.initState();
    speakerUserBloc
        .add(LoadSpeakerList(userList: widget.sessionInfo['speakerUsers']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: createSessionScreenBloc,
        listener: (context, state) {
          if (state is CreateSessionScreenLoaded) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MeetingDetailScreen(
                        meetingId: state.response['sessionId'],
                      )),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(width: 2, color: Colors.black38)),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 8,
                          ),
                          Icon(
                            Icons.search,
                            color: Colors.black38,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: AutoComplete(
                              textEditingController: searchController,
                              hintText: Strings.ADD_SPEAKERS_USERNAME,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              autoFocus: true,
                              suggestionsCallback: (String pattern) async {
                                if (Util.isStringNotNull(pattern)) {
                                  setState(() {
                                    showLocationLoader = true;
                                  });
                                }
                                List suggestedUsers = await Api()
                                    .getUserDetailByPattern(pattern: pattern);
                                setState(() {
                                  showLocationLoader = false;
                                });
                                return suggestedUsers;
                              },
                              itemBuilder: (BuildContext context, itemData) {
                                return Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        color: Colors.white,
                                        padding: const EdgeInsets.all(8.0),
                                        child: ShortUserInfoShortWidget(
                                          userName: itemData['userName'],
                                          firstName: itemData['firstName'],
                                          lastName: itemData['lastName'],
                                          profilePicUrl:
                                              itemData['profilePicUrl'],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    ShapeButtonSmall(
                                      text: Strings.ADD,
                                      onPressed: () {
                                        speakerUserBloc.add(
                                            AddSpeakerInList(user: itemData));
                                      },
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                );
                              },
                              suggestionSelectionCallback: (suggestion) {},
                              direction: AxisDirection.down,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Visibility(
                                visible: showLocationLoader,
                                child: WaveLoader.spinKit(size: 12)),
                          )
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder(
                    bloc: speakerUserBloc,
                    builder: (context, state) {
                      if (state is SpeakerListLoaded) {
                        if (Util.isValidList(state.response)) {
                          return Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 16.0, left: 16),
                                child: TextBody2(Strings.SPEAKERS),
                              ));
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                  BlocBuilder(
                    bloc: speakerUserBloc,
                    builder: (context, state) {
                      if (state is SpeakerListLoaded) {
                        if (Util.isValidList(state.response)) {
                          speakeUserList = state.response;
                          return Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8, right: 8),
                              child: ListView.builder(
                                  itemCount: state.response.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            color: Colors.white,
                                            padding: const EdgeInsets.all(8.0),
                                            child: ShortUserInfoShortWidget(
                                              userName: state.response[index]
                                                  ['userName'],
                                              firstName: state.response[index]
                                                  ['firstName'],
                                              lastName: state.response[index]
                                                  ['lastName'],
                                              profilePicUrl:
                                                  state.response[index]
                                                      ['profilePicUrl'],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        ShapeButtonSmall(
                                          text: Strings.REMOVE,
                                          onPressed: () {
                                            speakerUserBloc.add(
                                                RemoveSpeakerInList(
                                                    user:
                                                        state.response[index]));
                                          },
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                      ],
                                    );
                                  }),
                            ),
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
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: BlocBuilder(
                      bloc: createSessionScreenBloc,
                      builder: (context, state) {
                        if (state is CreateSessionScreenInit) {
                          return Container(
                              height: 20,
                              width: 40,
                              child: WaveLoader.spinKit(size: 20));
                        } else {
                          return RoundedShapeButton(
                            text: widget.isFromEdit
                                ? Strings.UPDATE_MEETING
                                : Strings.CREATE_A_MEETING,
                            onPressed: () {
                              Map body = Map();
                              body.addAll(widget.sessionInfo);
                              body['speakerUsers'] = speakeUserList;
                              body['sessionId'] =
                                  widget.sessionInfo['sessionId'];
                              if (widget.isFromEdit) {
                                createSessionScreenBloc.add(
                                    LoadUpdateSessionScreen(sessionInfo: body));
                              } else {
                                createSessionScreenBloc.add(
                                    LoadCreateSessionScreen(sessionInfo: body));
                              }
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                          );
                        }
                      },
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
