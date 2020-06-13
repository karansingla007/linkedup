import 'package:meta/meta.dart';

@immutable
abstract class HistoryDiscussionScreenEvent {
  HistoryDiscussionScreenEvent() : super();
}

class LoadHistoryDiscussionScreen extends HistoryDiscussionScreenEvent {
  LoadHistoryDiscussionScreen();

  @override
  String toString() => 'LoadHistoryDiscussionScreen';
}
