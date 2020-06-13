import 'package:meta/meta.dart';

@immutable
abstract class LiveDiscussionScreenState {
  LiveDiscussionScreenState([props = const []]) : super();
}

class LiveDiscussionScreenLoading extends LiveDiscussionScreenState {
  @override
  String toString() => 'LiveDiscussionScreenLoading';
}

class LiveDiscussionScreenLoaded extends LiveDiscussionScreenState {
  final List liveSessionList;

  LiveDiscussionScreenLoaded({this.liveSessionList}) : super();

  @override
  String toString() => 'LiveDiscussionScreenLoaded';
}

class LiveDiscussionScreenNotLoaded extends LiveDiscussionScreenState {
  @override
  String toString() => 'LiveDiscussionScreenNotLoaded';
}

class ScheduleDiscussionScreenLoaded extends LiveDiscussionScreenState {
  final List scheduleSessionList;
  final List liveSessionList;

  ScheduleDiscussionScreenLoaded(
      {this.scheduleSessionList, this.liveSessionList})
      : super();

  @override
  String toString() => 'ScheduleDiscussionScreenLoaded';
}

class ScheduleDiscussionScreenNotLoaded extends LiveDiscussionScreenState {
  @override
  String toString() => 'ScheduleDiscussionScreenNotLoaded';
}
