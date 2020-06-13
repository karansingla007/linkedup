import 'package:meta/meta.dart';

@immutable
abstract class LiveAgoraState {
  LiveAgoraState() : super();
}

class LiveAgoraLoading extends LiveAgoraState {
  @override
  String toString() => 'LiveAgoraLoading';
}

class LiveAgoraLoaded extends LiveAgoraState {
  final List comments;
  final Map viewerGotInvitedData;
  final Map hostMuteOtherUserInfo;
  final Map hostRemoveOtherUserInfo;
  final bool isMeetingEnded;

  LiveAgoraLoaded(
      {@required this.comments,
      this.viewerGotInvitedData,
      this.hostMuteOtherUserInfo,
      this.hostRemoveOtherUserInfo,
      this.isMeetingEnded = false});

  @override
  String toString() => 'LiveAgoraLoaded';
}

class LiveAgoraNotLoaded extends LiveAgoraState {
  @override
  String toString() => 'LiveAgoraNotLoaded';
}

class AudioChangedState extends LiveAgoraState {
  final String userId;
  final String audioStatus;

  AudioChangedState({@required this.userId, this.audioStatus});

  @override
  String toString() => 'LiveAgoraLoaded';
}

class RemovedSpeakerState extends LiveAgoraState {
  final String userId;

  RemovedSpeakerState({@required this.userId});

  @override
  String toString() => 'RemovedSpeakerState';
}
