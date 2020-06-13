import 'package:meta/meta.dart';

@immutable
abstract class MeetingDetailState {
  MeetingDetailState([props = const []]) : super();
}

class MeetingDetailLoading extends MeetingDetailState {
  @override
  String toString() => 'MeetingDetailLoading';
}

class MeetingDetailStarting extends MeetingDetailState {
  @override
  String toString() => 'MeetingDetailStarting';
}

class MeetingDetailStarted extends MeetingDetailState {
  @override
  String toString() => 'MeetingDetailStarted';
}

class MeetingDetailDeleting extends MeetingDetailState {
  @override
  String toString() => 'MeetingDetailDeleting';
}

class MeetingDetailDeleted extends MeetingDetailState {
  @override
  String toString() => 'MeetingDetailDeleted';
}

class MeetingDetailLoaded extends MeetingDetailState {
  final Map sessionInfo;

  MeetingDetailLoaded({this.sessionInfo}) : super();

  @override
  String toString() => 'MeetingDetailLoaded';
}

class MeetingDetailNotLoaded extends MeetingDetailState {
  @override
  String toString() => 'MeetingDetailNotLoaded';
}
