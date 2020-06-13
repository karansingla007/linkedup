import 'package:meta/meta.dart';

@immutable
abstract class MeetingDetailEvent {
  MeetingDetailEvent() : super();
}

class LoadMeetingDetail extends MeetingDetailEvent {
  final String sessionId;
  LoadMeetingDetail(this.sessionId);

  @override
  String toString() => 'LoadMeetingDetail';
}

class StartMeeting extends MeetingDetailEvent {
  final String sessionId;
  StartMeeting(this.sessionId);

  @override
  String toString() => 'StartMeeting';
}

class DeleteMeeting extends MeetingDetailEvent {
  final String sessionId;
  DeleteMeeting(this.sessionId);

  @override
  String toString() => 'DeletMeeting';
}
