import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';
import 'package:zoomclone/bloc/live_agora/live_agora.dart';
import 'package:zoomclone/bloc/live_agora/live_agora_bloc.dart';
import 'package:zoomclone/bloc/user_detail/user_detail.dart';
import 'package:zoomclone/bottomSheets/invite_action_bottom_sheet.dart';
import 'package:zoomclone/bottomSheets/request_to%20become_speaker.dart';
import 'package:zoomclone/bottomSheets/search_user_bottom_sheet.dart';
import 'package:zoomclone/buttons/shape_button_small.dart';
import 'package:zoomclone/dialogs/confirmation_dialog.dart';
import 'package:zoomclone/dialogs/meeting_info_dialog.dart';
import 'package:zoomclone/molecule/circle_image.dart';
import 'package:zoomclone/molecule/text_user_name_with_bloc.dart';
import 'package:zoomclone/screen/end_meeting_screen.dart';
import 'package:zoomclone/utils/constants.dart';
import 'package:zoomclone/utils/util.dart';
import 'package:zoomclone/widgets/comment_box.dart';
import 'package:zoomclone/widgets/user_comment.dart';

class LiveAgora extends StatefulWidget {
  final String meetingId;
  final String userRole;
  final Map hostUser;

  const LiveAgora({Key key, this.meetingId, this.userRole, this.hostUser})
      : super(key: key);

  @override
  _LiveAgoraState createState() => _LiveAgoraState();
}

class _LiveAgoraState extends State<LiveAgora> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  static const APP_ID = '2a6f983c71154e28a1cd3ebb7aa75ad5';

  bool audioMuted = false;
  bool videoMuted = false;
  int selectedUid;
  int actionUid;
  int selectedIndex;
  List<int> audioMutedUidList = [];
  List<int> videoMutedUidList = [];
  bool isAllPermissionGranted = false;
  Map<String, String> userNameMap = Map();
  Map<String, String> profilePicMap = Map();
  final UserDetailBloc userDetailBloc = UserDetailBloc();
  int currentUid = 0;
  final AgoraSocketBloc agoraSocketBloc = AgoraSocketBloc();

  @override
  void dispose() {
    _users.clear();
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    requestPermission();
    initialize();
    agoraSocketBloc.add(LoadSessionComment(widget.meetingId));
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    if (!Util.isStringNotNull(widget.userRole) ||
        widget.userRole == Constants.VIEWER) {
      await AgoraRtcEngine.setClientRole(ClientRole.Audience);
    } else {
      await AgoraRtcEngine.setClientRole(ClientRole.Broadcaster);
    }
    String userId = await Util.getCurrentUserId();
    await AgoraRtcEngine.joinChannel(
        null, widget.meetingId, null, int.parse(userId));
  }

  requestPermission() async {
    isAllPermissionGranted = await Util.requestAllPermission();
    if (!isAllPermissionGranted) {
      Toast.show("All permissions are required to use this feature", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      Navigator.pop(context);
    } else {
      setState(() {});
    }
  }

  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
  }

  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      userDetailBloc.add(LoadUserInfo(userId: uid.toString()));
      agoraSocketBloc.add(
          JoinSessionEvent(uid.toString(), widget.userRole, widget.meetingId));
      currentUid = uid;
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      agoraSocketBloc.add(
          JoinSessionEvent(uid.toString(), widget.userRole, widget.meetingId));
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
        userDetailBloc.add(LoadUserInfo(userId: uid.toString()));
        if (_users.length == 1) {
          selectedUid = _users[0];
          selectedIndex = 0;
        }
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
        if (selectedUid == uid) {
          selectedUid = _users[0];
        }
      });
    };

    AgoraRtcEngine.onUserMuteAudio = (int uid, bool muted) {
      setState(() {
        if (muted) {
          audioMutedUidList.add(uid);
        } else {
          audioMutedUidList.remove(uid);
        }
      });
    };

    AgoraRtcEngine.onRemoteVideoStateChanged =
        (int uid, int state, int reason, int elapsed) {
      setState(() {
        if (state == 0 && reason == 5) {
          videoMutedUidList.add(uid);
        } else if (state == 2 && reason == 6) {
          videoMutedUidList.remove(uid);
        }
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  /// Helper function to get list of native views
  List<AgoraRenderWidget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(currentUid, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  Widget _viewRows() {
    final views = _getRenderViews();
    if (views.length == 1) {
      return Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: views[0].local && videoMuted
                        ? Container(
                            color: Colors.black,
                          )
                        : Container(
                            child: views[0],
                          ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Visibility(
                  visible: views[0].local && videoMuted,
                  child: CircleImageWithBorder(
                      profilePicMap[views[0].uid.toString()])),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Visibility(
                    visible: audioMuted,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          height: 40,
                          width: 40,
                          child: Icon(
                            Icons.mic_off,
                            size: 25,
                            color: Colors.white,
                          )),
                    ))),
          ],
        ),
      );
    } else if (views.length > 1) {
      List<Widget> boxList = [];
      for (int i = 0; i < views.length; i++) {
        if (selectedUid != views[i].uid) {
          boxList.add(Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              width: 70,
              height: 92,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedUid = views[i].uid;
                    actionUid = null;
                  });
                },
//                onLongPress: () {
//                  if (widget.userRole == Constants.HOST && views[i].uid != currentUid) {
//                    setState(() {
//                      actionUid = views[i].uid;
//                    });
//                  }
//                },
                child: Stack(
                  children: <Widget>[
                    Container(
                        decoration: ShapeDecoration(
                          color: Color(0xFF333333),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        ),
                        child: views[i]),
                    Container(
                      color: (views[i].local && videoMuted) ||
                              videoMutedUidList.contains(views[i].uid)
                          ? Colors.black
                          : Colors.transparent,
                      width: 68,
                      height: 92,
                    ),
                    Center(
                      child: Visibility(
                          visible: (views[i].local && videoMuted) ||
                              videoMutedUidList.contains(views[i].uid),
                          child: CircleImageWithBorder(
                            profilePicMap[views[i].uid.toString()],
                            width: 44.0,
                            height: 44.0,
                          )),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Visibility(
                              visible:
                                  audioMutedUidList.contains(views[i].uid) ||
                                      (views[i].local && audioMuted),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                    height: 24,
                                    width: 24,
                                    child: Icon(
                                      Icons.mic_off,
                                      size: 16,
                                      color: Colors.white,
                                    )),
                              )),
                          Expanded(
                            child: Container(),
                          ),
                          TextUsernameWithBloc(
                            userNameMap[views[i].uid.toString()],
                            userId: views[i].uid.toString(),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Visibility(
                          visible: widget.userRole == Constants.HOST &&
                              views[i].uid != currentUid,
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  actionUid = views[i].uid;
                                });
                              },
                              child: Icon(Icons.more_vert))),
                    ),
                  ],
                ),
              ),
            ),
          ));
        } else {
          selectedIndex = i;
        }
      }
      return GestureDetector(
        onTap: () {
          setState(() {
            actionUid = null;
          });
        },
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: (views[selectedIndex].local && videoMuted) ||
                              (videoMutedUidList
                                  .contains(views[selectedIndex].toString()))
                          ? Container(
                              color: Colors.black,
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: views[selectedIndex],
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Visibility(
                  visible: (views[selectedIndex].local && videoMuted) ||
                      (videoMutedUidList
                          .contains(views[selectedIndex].toString())),
                  child: CircleImageWithBorder(
                      profilePicMap[views[selectedIndex].uid.toString()])),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                    height: 80,
                    width: 80,
                    child: Visibility(
                        visible: audioMutedUidList.contains(selectedUid) ||
                            (views[selectedIndex].local && audioMuted),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 100.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              height: 40,
                              width: 40,
                              child: Icon(
                                Icons.mic_off,
                                color: Colors.white,
                                size: 25,
                              )),
                        )))),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 72.0, right: 16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: boxList,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  void showBackDialog() {
    String heading;
    String subHeading;
    String text;
    if (widget.userRole == Constants.HOST) {
      subHeading = 'Are you sure you want to end meeting';
      text = 'END';
      heading = 'End Meeting';
    } else {
      subHeading = 'Are you sure you want to exit meeting';
      text = 'LEAVE';
      heading = 'Leave Meeting';
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              content: ConfirmationDialog(
                heading: heading,
                subHeading: subHeading,
                button: ShapeButtonSmall(
                  text: text,
                  onPressed: () {
                    if (widget.userRole == Constants.HOST) {
                      agoraSocketBloc
                          .add(MeetingEndEvent(meetingId: widget.meetingId));
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showBackDialog();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocListener(
          bloc: agoraSocketBloc,
          listener: (context, state) {
            if (state is LiveAgoraLoaded) {
              if (state.viewerGotInvitedData != null) {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  builder: (BuildContext bc) {
                    return InviteActionBottomSheet(
                      hostUserName: state.viewerGotInvitedData['hostUserName'],
                      hostUserProfilePicUrl:
                          state.viewerGotInvitedData['hostUserProfilePicUrl'],
                      otherUserName:
                          state.viewerGotInvitedData['otherUserName'],
                      otherUserProfilePicUrl:
                          state.viewerGotInvitedData['otherUserProfilePicUrl'],
                      onClickAccept: () {
                        AgoraRtcEngine.setClientRole(ClientRole.Broadcaster);
                      },
                    );
                  },
                  isScrollControlled: true,
                );
              } else if (state.hostMuteOtherUserInfo != null) {
                AgoraRtcEngine.muteLocalAudioStream(true);
                Toast.show(
                  '${state.hostMuteOtherUserInfo['hostUserName']} muted ${state.hostMuteOtherUserInfo['userName']} for everyone',
                  context,
                  gravity: Toast.CENTER,
                  duration: Toast.LENGTH_LONG,
                );
                audioMuted = true;
                setState(() {});
              } else if (state.hostRemoveOtherUserInfo != null) {
                Navigator.pop(context);
                Toast.show(
                  '${state.hostRemoveOtherUserInfo['hostUserName']} removed ${state.hostRemoveOtherUserInfo['userName']} from meeting',
                  context,
                  gravity: Toast.CENTER,
                  duration: Toast.LENGTH_LONG,
                );
              } else if (state.isMeetingEnded != null && state.isMeetingEnded) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => EndMeetingScreen()),
                );
              }
            }
          },
          child: BlocListener(
            bloc: userDetailBloc,
            listener: (context, state) {
              if (state is UserDetailLoaded) {
                userNameMap[state.data['userId']] = state.data['userName'];
                profilePicMap[state.data['userId']] =
                    state.data['profilePicUrl'];
              }
            },
            child: Center(
              child: Stack(
                children: <Widget>[
                  _viewRows(),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 96.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(0, 0, 0, 0.24),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Visibility(
                        visible: actionUid != null,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 70.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: Colors.black26,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    String actionStatus;
                                    if (!audioMutedUidList
                                        .contains(actionUid)) {
                                      actionStatus = 'mute';
                                      agoraSocketBloc.add(AudioChangeEvent(
                                          actionUid.toString(),
                                          actionStatus,
                                          widget.meetingId));
                                      setState(() {
                                        actionUid = null;
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.mic,
                                      color:
                                          audioMutedUidList.contains(actionUid)
                                              ? Colors.white70
                                              : Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    agoraSocketBloc.add(RemoveSpeakerEvent(
                                        actionUid.toString(),
                                        widget.meetingId));
                                    setState(() {
                                      actionUid = null;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.remove_circle,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 250.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color.fromRGBO(0, 0, 0, 0.24),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32.0, right: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                audioMuted = !audioMuted;
                                AgoraRtcEngine.muteLocalAudioStream(audioMuted);
                              });
                            },
                            child: Icon(
                              audioMuted ? Icons.mic_off : Icons.mic,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                videoMuted = !videoMuted;
                                AgoraRtcEngine.muteLocalVideoStream(videoMuted);
                              });
                            },
                            child: Icon(
                              videoMuted ? Icons.videocam_off : Icons.videocam,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              AgoraRtcEngine.switchCamera();
                            },
                            child: Icon(
                              Icons.switch_camera,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              showBackDialog();
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: BlocBuilder(
                          bloc: agoraSocketBloc,
                          builder: (context, state) {
                            if (state is LiveAgoraLoaded) {
                              if (Util.isValidList(state.comments)) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 70.0, left: 16),
                                  child: Container(
                                    height: 230,
                                    width:
                                        MediaQuery.of(context).size.width - 90,
                                    child: ListView.separated(
                                        reverse: true,
                                        padding: const EdgeInsets.all(0.0),
                                        itemCount: state.comments.length,
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                              color: Colors.transparent,
                                              height: 8,
                                            ),
                                        itemBuilder: (context, index) {
                                          return UserComment(
                                              userName: state.comments[index]
                                                  ['user']['userName'],
                                              profilePicUrl:
                                                  state.comments[index]['user']
                                                      ['profilePicUrl'],
                                              commentText: state.comments[index]
                                                  ['commentText'],
                                              commentTime: state.comments[index]
                                                      ['createdAt']
                                                  .toString(),
                                              signature: Util.getSignatureOfName(
                                                  firstName:
                                                      state.comments[index]
                                                          ['firstName'],
                                                  lastName:
                                                      state.comments[index]
                                                          ['lastName']));
                                        }),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          })),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 16, right: 16, top: 8),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: CommentBox(
                            onClickSend: (data) {
                              agoraSocketBloc.add(PostSessionComment(
                                sessionId: widget.meetingId,
                                commentText: data,
                              ));
                            },
                          )),
                          SizedBox(
                            width: Util.isStringNotNull(widget.userRole) &&
                                    widget.userRole == Constants.HOST
                                ? 16
                                : 0,
                          ),
                          Visibility(
                            visible: Util.isStringNotNull(widget.userRole) &&
                                widget.userRole != Constants.SPEAKER,
                            child: GestureDetector(
                              onTap: () {
                                if (widget.userRole == Constants.HOST) {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.white,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                    ),
                                    builder: (BuildContext bc) {
                                      return FractionallySizedBox(
                                        heightFactor: 0.7,
                                        child: SearchUserBottomSheet(
                                          onClickInvite: (selectedUser) {
                                            agoraSocketBloc.add(
                                                InviteViewerToBecomeSpeakerEvent(
                                                    sessionId: widget.meetingId,
                                                    otherUserName: selectedUser[
                                                        'userName'],
                                                    otherUserProfilePicUrl:
                                                        selectedUser[
                                                            'profilePicUrl'],
                                                    otherUserId: selectedUser[
                                                        'userId']));
                                          },
                                        ),
                                      );
                                    },
                                    isScrollControlled: true,
                                  );
                                } else if (widget.userRole ==
                                    Constants.VIEWER) {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.white,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                    ),
                                    builder: (BuildContext bc) {
                                      return RequestToBecomeSpeaker(
                                        hostUser: widget.hostUser,
                                      );
                                    },
                                    isScrollControlled: true,
                                  );
                                }
                              },
                              child: Icon(
                                Icons.person_add,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          GestureDetector(
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
                                      content:
                                          MeetingInfoDialog(widget.meetingId),
                                    );
                                  });
                            },
                            child: Icon(
                              Icons.info_outline,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
