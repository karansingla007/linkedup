import 'package:meta/meta.dart';

@immutable
abstract class LiveDiscussionScreenEvent {
  LiveDiscussionScreenEvent() : super();
}

class LoadLiveDiscussionScreen extends LiveDiscussionScreenEvent {
  LoadLiveDiscussionScreen();

  @override
  String toString() => 'LoadLiveDiscussionScreen';
}

class LoadScheduleDiscussionScreen extends LiveDiscussionScreenEvent {
  final List liveDiscussionList;

  LoadScheduleDiscussionScreen(this.liveDiscussionList);

  @override
  String toString() => 'LoadScheduleDiscussionScreen';
}
