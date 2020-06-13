import 'package:meta/meta.dart';

@immutable
abstract class MyMeetingsState {
  MyMeetingsState([props = const []]) : super();
}

class MyMeetingsLoading extends MyMeetingsState {
  @override
  String toString() => 'MyMeetingsLoading';
}

class MyMeetingsLoaded extends MyMeetingsState {
  final List response;

  MyMeetingsLoaded({
    this.response,
  }) : super();

  @override
  String toString() => 'MyMeetingsLoaded';
}

class MyMeetingsNotLoaded extends MyMeetingsState {
  @override
  String toString() => 'MyMeetingsNotLoaded';
}
