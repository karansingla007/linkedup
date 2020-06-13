import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:zoomclone/api/api.dart';
import 'package:zoomclone/bloc/live_agora/live_agora_event.dart';
import 'package:zoomclone/bloc/live_agora/live_agora_state.dart';
import 'package:zoomclone/socket/agora_socket.dart';
import 'package:zoomclone/socket/socket_events.dart';
import 'package:zoomclone/utils/constants.dart';
import 'package:zoomclone/utils/time_util.dart';
import 'package:zoomclone/utils/util.dart';

class AgoraSocketBloc extends Bloc<LiveAgoraEvent, LiveAgoraState> {
  @override
  LiveAgoraState get initialState => LiveAgoraLoading();

  LiveSocket liveSocket;
  AgoraSocketBloc() {
    initializeSocket();
  }

  initializeSocket() async {
    liveSocket = LiveSocket();
    await liveSocket.initLiveSocket();
    liveSocket.listenSessionJoinedEvent(sessionJoinedCallback);
    liveSocket.listenAudioChangedEvent(audioChangedCallback);
    liveSocket.listenRemovedSpeakerEvent(removedSpeakerCallback);
    liveSocket.listenCommentReceiveEvent(commentReceiveCallback);
    liveSocket.listenViewerGotInvitationEvent(viewerGotInvitationCallback);
    liveSocket.listenMeetingEndedEvent(meetingEndedCallback);
  }

  sessionJoinedCallback(Map data) {
    this.add(SessionJoined(data: data));
  }

  audioChangedCallback(Map data) {
    this.add(AudioChangedEvent(data));
  }

  viewerGotInvitationCallback(Map data) {
    this.add(ViewerGotInvitationEvent(data: data));
  }

  meetingEndedCallback(Map data) {
    this.add(MeetingEndedEvent());
  }

  removedSpeakerCallback(Map data) {
    this.add(RemovedSpeakerEvent(removedUserInfo: data));
  }

  commentReceiveCallback(Map data) {
    this.add(CommentReceiveEvent(comment: data));
  }

  @override
  Stream<LiveAgoraState> mapEventToState(
    LiveAgoraEvent event,
  ) async* {
    if (event is SessionJoined) {
      final currentState = state;
      if (currentState is LiveAgoraLoaded) {
        List comment = currentState.comments;
        comment.insert(0, event.data);
        yield LiveAgoraLoaded(comments: comment);
      }
    } else if (event is AudioChangedEvent) {
      final currentState = state;
      if (currentState is LiveAgoraLoaded) {
        List comment = currentState.comments;
        String currentUserId = await Util.getCurrentUserId();
        if (event.mutedUserInfo['userId'] == currentUserId) {
          yield LiveAgoraLoaded(
              comments: comment, hostMuteOtherUserInfo: event.mutedUserInfo);
        }
      }
    } else if (event is RemovedSpeakerEvent) {
      final currentState = state;
      if (currentState is LiveAgoraLoaded) {
        List comment = currentState.comments;
        String currentUserId = await Util.getCurrentUserId();
        if (event.removedUserInfo['userId'] == currentUserId) {
          yield LiveAgoraLoaded(
              comments: comment,
              hostRemoveOtherUserInfo: event.removedUserInfo);
        }
      }
    } else if (event is ViewerGotInvitationEvent) {
      final currentState = state;
      if (currentState is LiveAgoraLoaded) {
        String currentUserId = await Util.getCurrentUserId();
        if (currentUserId == event.data['otherUserId']) {
          yield LiveAgoraLoaded(
              comments: currentState.comments,
              viewerGotInvitedData: event.data);
        }
      }
    } else if (event is MeetingEndedEvent) {
      final currentState = state;
      if (currentState is LiveAgoraLoaded) {
        yield LiveAgoraLoaded(
            comments: currentState.comments, isMeetingEnded: true);
      }
    } else if (event is JoinSessionEvent) {
      Map data = Map();
      data['userRole'] = event.userRole;
      data['sessionId'] = event.sessionId;
      Map userInfo = await Api().getUserDetail(userId: event.userId);
      data['user'] = userInfo;
      if (event.userRole == Constants.SPEAKER) {
        data['commentText'] = 'Joined as a speaker';
      } else if (event.userRole == Constants.VIEWER) {
        data['commentText'] = 'Joined as a viewer';
      } else {
        data['commentText'] = 'Joined as a host';
      }
      data['createdAt'] = TimeUtil.getCurrentEpochTimeStamp().toString();
      liveSocket.emitEvent(SocketEvent.JOIN_SESSION, data: [json.encode(data)]);
    } else if (event is AudioChangeEvent) {
      final userInfo = await Api().getUserDetail(userId: event.userId);
      final hostUserInfo = await Util.getCurrentUserInfo();
      Map data = Map();
      data['userId'] = event.userId;
      data['userName'] = userInfo['userName'];
      data['hostUserName'] = hostUserInfo['userName'];
      data['audioStatus'] = event.audioStatus;
      data['sessionId'] = event.sessionId;
      liveSocket.emitEvent(SocketEvent.AUDIO_CHANGE, data: [json.encode(data)]);
    } else if (event is RemoveSpeakerEvent) {
      final userInfo = await Api().getUserDetail(userId: event.userId);
      final hostUserInfo = await Util.getCurrentUserInfo();
      Map data = Map();
      data['userId'] = event.userId;
      data['userName'] = userInfo['userName'];
      data['hostUserName'] = hostUserInfo['userName'];
      data['sessionId'] = event.sessionId;
      liveSocket
          .emitEvent(SocketEvent.REMOVE_SPEAKER, data: [json.encode(data)]);
    } else if (event is LoadSessionComment) {
      try {
        yield LiveAgoraLoading();
        List response =
            await Api().getSessionCommentList(sessionId: event.sessionId);
        yield LiveAgoraLoaded(
          comments: response,
        );
      } catch (error) {
        yield LiveAgoraNotLoaded();
      }
    } else if (event is PostSessionComment) {
      try {
        final currentState = state;
        if (currentState is LiveAgoraLoaded) {
          List comment = currentState.comments;

          Map userInfo = await Util.getCurrentUserInfo();
          Map body = Map();
          body['user'] = userInfo;
          body['commentText'] = event.commentText;
          body['createdAt'] = TimeUtil.getCurrentEpochTimeStamp().toString();
          body['sessionId'] = event.sessionId;

          comment.insert(0, body);

          yield LiveAgoraLoaded(comments: comment);

          liveSocket
              .emitEvent(SocketEvent.COMMENT_SEND, data: [json.encode(body)]);
          await Api().postCommentInSession(comment: body);
        }
      } catch (error) {
        print(error);
      }
    } else if (event is CommentReceiveEvent) {
      final currentState = state;
      if (currentState is LiveAgoraLoaded) {
        List comment = currentState.comments;
        comment.insert(0, event.comment);
        yield LiveAgoraLoaded(comments: comment);
      }
    } else if (event is InviteViewerToBecomeSpeakerEvent) {
      Map userInfo = await Util.getCurrentUserInfo();
      Map body = Map();
      body['hostUserName'] = userInfo['userName'];
      body['hostUserProfilePicUrl'] = userInfo['profilePicUrl'];
      body['otherUserName'] = event.otherUserName;
      body['otherUserProfilePicUrl'] = event.otherUserProfilePicUrl;
      body['otherUserId'] = event.otherUserId;
      body['sessionId'] = event.sessionId;

      liveSocket.emitEvent(SocketEvent.INVITE_VIEWER_TO_BECOME_SPEAKER,
          data: [json.encode(body)]);
    } else if (event is MeetingEndEvent) {
      Map body = Map();
      body['sessionId'] = event.meetingId;
      Map response = await Api().endSessionStatus(sessionId: event.meetingId);
      liveSocket.emitEvent(SocketEvent.MEETING_END, data: [json.encode(body)]);
    }
  }
}
