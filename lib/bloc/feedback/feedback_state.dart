import 'package:meta/meta.dart';

@immutable
abstract class FeedbackState {
  FeedbackState([props = const []]) : super();
}

class FeedbackLoading extends FeedbackState {
  @override
  String toString() => 'FeedbackLoading';
}

class FeedbackSubmiting extends FeedbackState {
  @override
  String toString() => 'FeedbackSubmiting';
}

class FeedbackLoaded extends FeedbackState {
  final Map response;

  FeedbackLoaded({
    this.response,
  }) : super();

  @override
  String toString() => 'FeedbackLoaded';
}

class FeedbackNotLoaded extends FeedbackState {
  @override
  String toString() => 'FeedbackNotLoaded';
}
