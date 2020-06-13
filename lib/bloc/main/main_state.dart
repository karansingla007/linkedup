import 'package:meta/meta.dart';

@immutable
abstract class MainState {
  MainState() : super();
}

class MainLoading extends MainState {
  @override
  String toString() => 'MainLoading';
}

class MainLoaded extends MainState {
  final Map userDetail;
  final String meetingId;

  MainLoaded({@required this.userDetail, this.meetingId});

  @override
  String toString() => 'MainLoaded';
}

class MainNotLoaded extends MainState {
  @override
  String toString() => 'MainNotLoaded';
}
