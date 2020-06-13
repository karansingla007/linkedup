import 'package:meta/meta.dart';

@immutable
abstract class LoginSignupEvent {
  LoginSignupEvent([props = const []]) : super();
}

class LoadLoginSignup extends LoginSignupEvent {
  final String type;

  LoadLoginSignup({this.type});

  @override
  String toString() => 'LoadLoginSignup';
}

class LoadLoginSignUpWithMobile extends LoginSignupEvent {
  final String contactNumber;

  LoadLoginSignUpWithMobile({this.contactNumber});

  @override
  String toString() => 'LoadLoginSignUpWithMobile';
}

class LoadLoadingState extends LoginSignupEvent {
  @override
  String toString() => 'LoadLoadingState';
}
