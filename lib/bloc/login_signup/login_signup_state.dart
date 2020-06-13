import 'package:meta/meta.dart';

@immutable
abstract class LoginSignupState {
  LoginSignupState() : super();
}

class LoginSignupLoading extends LoginSignupState {
  @override
  String toString() => 'LoginSignupLoading';
}

class LoginSignupInit extends LoginSignupState {
  @override
  String toString() => 'LoginSignupInit';
}

class LoginSignupLoaded extends LoginSignupState {
  final Map userDetail;

  LoginSignupLoaded({@required this.userDetail});

  @override
  String toString() => 'LoginSignupLoaded';
}

class LoginSignupNotLoaded extends LoginSignupState {
  @override
  String toString() => 'LoginSignupNotLoaded';
}
