import 'package:meta/meta.dart';

@immutable
abstract class WelcomeScreenEvent {
  WelcomeScreenEvent() : super();
}

class LoadWelcomeScreen extends WelcomeScreenEvent {
  LoadWelcomeScreen();

  @override
  String toString() => 'LoadWelcomeScreen';
}

class SendUserData extends WelcomeScreenEvent {
  final Map userInfo;
  SendUserData({this.userInfo});

  @override
  String toString() => 'SendUserData';
}

class SendUserDataDesignation extends WelcomeScreenEvent {
  final Map userInfo;
  SendUserDataDesignation({@required this.userInfo});

  @override
  String toString() => 'SendUserDataDesignation';
}

class SendUserDataAge extends WelcomeScreenEvent {
  final Map userInfo;
  SendUserDataAge({@required this.userInfo});

  @override
  String toString() => 'SendUserDataAge';
}
