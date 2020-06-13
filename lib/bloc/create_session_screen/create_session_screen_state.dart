import 'package:meta/meta.dart';

@immutable
abstract class CreateSessionScreenState {
  CreateSessionScreenState([props = const []]) : super();
}

class CreateSessionScreenLoading extends CreateSessionScreenState {
  @override
  String toString() => 'CreateSessionScreenLoading';
}

class CreateSessionScreenInit extends CreateSessionScreenState {
  @override
  String toString() => 'CreateSessionScreenInit';
}

class CreateSessionScreenLoaded extends CreateSessionScreenState {
  final Map response;

  CreateSessionScreenLoaded({
    this.response,
  }) : super();

  @override
  String toString() => 'CreateSessionScreenLoaded';
}

class CreateSessionScreenNotLoaded extends CreateSessionScreenState {
  @override
  String toString() => 'CreateSessionScreenNotLoaded';
}

class SpeakerListLoaded extends CreateSessionScreenState {
  final List response;

  SpeakerListLoaded({
    this.response,
  }) : super();

  @override
  String toString() => 'SpeakerListLoaded';
}

class SpeakerListNotLoaded extends CreateSessionScreenState {
  @override
  String toString() => 'SpeakerListNotLoaded';
}
