import 'package:meta/meta.dart';

@immutable
abstract class CreateSessionScreenEvent {
  CreateSessionScreenEvent() : super();
}

class LoadCreateSessionScreen extends CreateSessionScreenEvent {
  final Map sessionInfo;

  LoadCreateSessionScreen({@required this.sessionInfo});

  @override
  String toString() => 'LoadCreateSessionScreen';
}

class LoadUpdateSessionScreen extends CreateSessionScreenEvent {
  final Map sessionInfo;

  LoadUpdateSessionScreen({@required this.sessionInfo});

  @override
  String toString() => 'LoadUpdateSessionScreen';
}

class AddSpeakerInList extends CreateSessionScreenEvent {
  final Map user;

  AddSpeakerInList({@required this.user});

  @override
  String toString() => 'AddSpeakerInList';
}

class RemoveSpeakerInList extends CreateSessionScreenEvent {
  final Map user;

  RemoveSpeakerInList({@required this.user});

  @override
  String toString() => 'RemoveSpeakerInList';
}

class LoadSpeakerList extends CreateSessionScreenEvent {
  final List userList;

  LoadSpeakerList({@required this.userList});

  @override
  String toString() => 'LoadSpeakerList';
}
