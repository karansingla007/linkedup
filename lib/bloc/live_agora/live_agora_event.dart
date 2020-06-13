import 'package:meta/meta.dart';

@immutable
abstract class LiveAgoraEvent {
  LiveAgoraEvent([props = const []]) : super();
}

class LoadSessionComment extends LiveAgoraEvent {
  final String sessionId;

  LoadSessionComment(this.sessionId);

  @override
  String toString() => 'LoadSessionComment';
}

class PostSessionComment extends LiveAgoraEvent {
  final String sessionId;
  final String commentText;

  PostSessionComment({this.sessionId, this.commentText});

  @override
  String toString() => 'PostSessionComment';
}

///emit
class JoinSessionEvent extends LiveAgoraEvent {
  final String userId;
  final String sessionId;
  final String userRole;

  JoinSessionEvent(this.userId, this.userRole, this.sessionId);

  @override
  String toString() => 'JoinSessionEvent';
}

class AudioChangeEvent extends LiveAgoraEvent {
  final String userId;
  final String audioStatus;
  final String sessionId;

  AudioChangeEvent(this.userId, this.audioStatus, this.sessionId);

  @override
  String toString() => 'AudioChangeEvent';
}

class RemoveSpeakerEvent extends LiveAgoraEvent {
  final String userId;
  final String sessionId;

  RemoveSpeakerEvent(
    this.userId,
    this.sessionId,
  );

  @override
  String toString() => 'RemoveSpeakerEvent';
}

class InviteViewerToBecomeSpeakerEvent extends LiveAgoraEvent {
  final String otherUserName;
  final String otherUserProfilePicUrl;
  final String otherUserId;
  final String sessionId;

  InviteViewerToBecomeSpeakerEvent({
    this.otherUserName,
    this.otherUserProfilePicUrl,
    this.sessionId,
    this.otherUserId,
  });

  @override
  String toString() => 'InviteViewerToBecomeSpeakerEvent';
}

class MeetingEndEvent extends LiveAgoraEvent {
  final String meetingId;

  MeetingEndEvent({this.meetingId});

  @override
  String toString() => 'MeetingEndEvent';
}

///listen
class SessionJoined extends LiveAgoraEvent {
  final Map data;

  SessionJoined({this.data});

  @override
  String toString() => 'SessionStarted';
}

class AudioChangedEvent extends LiveAgoraEvent {
  final Map mutedUserInfo;

  AudioChangedEvent(this.mutedUserInfo);

  @override
  String toString() => 'OutDoneEvent';
}

class RemovedSpeakerEvent extends LiveAgoraEvent {
  final Map removedUserInfo;

  RemovedSpeakerEvent({this.removedUserInfo});

  @override
  String toString() => 'RemovedSpeakerEvent';
}

class CommentReceiveEvent extends LiveAgoraEvent {
  final Map comment;

  CommentReceiveEvent({this.comment});

  @override
  String toString() => 'CommentReceiveEvent';
}

class ViewerGotInvitationEvent extends LiveAgoraEvent {
  final Map data;

  ViewerGotInvitationEvent({this.data});

  @override
  String toString() => 'ViewerGotInvitationEvent';
}

class MeetingEndedEvent extends LiveAgoraEvent {
  @override
  String toString() => 'MeetingEndedEvent';
}
