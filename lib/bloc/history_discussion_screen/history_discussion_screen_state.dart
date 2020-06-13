import 'package:meta/meta.dart';

@immutable
abstract class HistoryDiscussionScreenState {
  HistoryDiscussionScreenState([props = const []]) : super();
}

class HistoryDiscussionScreenLoading extends HistoryDiscussionScreenState {
  @override
  String toString() => 'HistoryDiscussionScreenLoading';
}

class HistoryDiscussionScreenLoaded extends HistoryDiscussionScreenState {
  final List historySessionList;

  HistoryDiscussionScreenLoaded({
    this.historySessionList,
  }) : super();

  @override
  String toString() => 'HistoryDiscussionScreenLoaded';
}

class HistoryDiscussionScreenNotLoaded extends HistoryDiscussionScreenState {
  @override
  String toString() => 'HistoryDiscussionScreenNotLoaded';
}
