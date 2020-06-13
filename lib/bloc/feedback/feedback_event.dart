import 'package:meta/meta.dart';

@immutable
abstract class FeedbackEvent {
  FeedbackEvent() : super();
}

class LoadFeedback extends FeedbackEvent {
  final Map body;
  LoadFeedback({this.body});

  @override
  String toString() => 'LoadFeedback';
}
