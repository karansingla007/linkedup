import 'package:meta/meta.dart';

@immutable
abstract class MainEvent {
  MainEvent([props = const []]) : super();
}

class LoadMain extends MainEvent {
  final String meetingId;

  LoadMain({this.meetingId});

  @override
  String toString() => 'LoadMain';
}
