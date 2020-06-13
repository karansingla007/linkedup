import 'package:zoomclone/socket/socket_events.dart';
import 'package:zoomclone/socket/socket_io.dart';

class LiveSocket {
  final String url = 'https://live-up.herokuapp.com/';

  static SocketIo socketIo;

  LiveSocket.internal() {
    socketIo = SocketIo();
  }

  static LiveSocket _instance = LiveSocket.internal();

  factory LiveSocket() => _instance;

  initLiveSocket() async {
    await socketIo.initSocket(url: url);
  }

  listenSessionJoinedEvent(sessionJoinedCallback) {
    socketIo.listenEvent(SocketEvent.SESSION_JOINED, sessionJoinedCallback);
  }

  listenAudioChangedEvent(audioChangedCallback) {
    socketIo.listenEvent(SocketEvent.AUDIO_CHANGED, audioChangedCallback);
  }

  listenRemovedSpeakerEvent(removedSpeakerCallback) {
    socketIo.listenEvent(SocketEvent.REMOVED_SPEAKER, removedSpeakerCallback);
  }

  listenCommentReceiveEvent(commentReceiveCallback) {
    socketIo.listenEvent(SocketEvent.COMMENT_RECEIVE, commentReceiveCallback);
  }

  listenViewerGotInvitationEvent(commentReceiveCallback) {
    socketIo.listenEvent(
        SocketEvent.VIEWER_GOT_INVITATION, commentReceiveCallback);
  }

  listenMeetingEndedEvent(meetingEndedCallback) {
    socketIo.listenEvent(
        SocketEvent.MEETING_ENDED, meetingEndedCallback);
  }

//  listenInvitationAcceptedByViewerEvent(invitationAcceptedByViewerCallback) {
//    socketIo.listenEvent(SocketEvent.INVITATION_ACCEPTED_BY_VIEWER,
//        invitationAcceptedByViewerCallback);
//  }

  viewerGotInvitationEvent(viewerGotInvitationCallback) {
    socketIo.listenEvent(
        SocketEvent.VIEWER_GOT_INVITATION, viewerGotInvitationCallback);
  }

  emitEvent(event, {List data}) {
    if (socketIo != null) {
      socketIo.emitEvent(event, data);
    }
  }

  disconnectSocket() {
    socketIo.disconnectSocket();
  }
}
