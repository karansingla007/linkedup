import 'package:meta/meta.dart';

@immutable
abstract class WelcomeScreenState {
  WelcomeScreenState([props = const []]) : super();
}

class WelcomeScreenLoading extends WelcomeScreenState {
  @override
  String toString() => 'WelcomeScreenLoading';
}

class WelcomeScreenLoaded extends WelcomeScreenState {
  final Map data;

  WelcomeScreenLoaded(this.data) : super();

  @override
  String toString() => 'WelcomeScreenLoaded';
}

class WelcomeScreenNotLoaded extends WelcomeScreenState {
  @override
  String toString() => 'WelcomeScreenNotLoaded';
}

class UpdateUserInfoWelcomeLoading extends WelcomeScreenState {
  @override
  String toString() => 'UpdateUserInfoWelcomeLoading';
}

class UpdateUserInfoWelcomeLoaded extends WelcomeScreenState {
  final Map data;

  UpdateUserInfoWelcomeLoaded(this.data) : super();

  @override
  String toString() => 'UpdateUserInfoWelcomeLoaded';
}

class UpdateUserInfoWelcomeNotLoaded extends WelcomeScreenState {
  @override
  String toString() => 'UpdateUserInfoWelcomeNotLoaded';
}
