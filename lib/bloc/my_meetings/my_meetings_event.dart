import 'package:meta/meta.dart';

@immutable
abstract class MyMeetingsEvent {
  MyMeetingsEvent() : super();
}

class LoadMyMeetings extends MyMeetingsEvent {
  LoadMyMeetings();

  @override
  String toString() => 'LoadMyMeetings';
}
