import 'package:meta/meta.dart';

@immutable
abstract class UserInfoScreenState {
  UserInfoScreenState([props = const []]) : super();
}

class UserInfoScreenLoading extends UserInfoScreenState {
  @override
  String toString() => 'UserInfoScreenLoading';
}

class UserInfoScreenLoaded extends UserInfoScreenState {
  final Map data;

  UserInfoScreenLoaded({this.data}) : super();

  @override
  String toString() => 'UserInfoScreenLoaded';
}

class UserInfoScreenNotLoaded extends UserInfoScreenState {
  @override
  String toString() => 'UserInfoScreenNotLoaded';
}
