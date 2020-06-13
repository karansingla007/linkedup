import 'package:meta/meta.dart';

@immutable
abstract class UserDetailState {
  UserDetailState([props = const []]) : super();
}

class UserDetailLoading extends UserDetailState {
  @override
  String toString() => 'UserDetailLoading';
}

class UserDetailLoaded extends UserDetailState {
  final Map data;

  UserDetailLoaded({this.data}) : super();

  @override
  String toString() => 'UserDetailLoaded';
}

class UserDetailNotLoaded extends UserDetailState {
  @override
  String toString() => 'UserDetailNotLoaded';
}

class UserDetailUpdating extends UserDetailState {
  @override
  String toString() => 'UserDetailUpdating';
}

class UserDetailUpdated extends UserDetailState {
  final Map data;

  UserDetailUpdated({this.data}) : super();

  @override
  String toString() => 'UserDetailUpdated';
}

class UserDetailNotUpdate extends UserDetailState {
  @override
  String toString() => 'UserDetailNotUpdate';
}

class UserProfilePhotoUpdating extends UserDetailState {
  @override
  String toString() => 'UserProfilePhotoUpdating';
}

class UserProfilePhotoUpdated extends UserDetailState {
  final Map data;

  UserProfilePhotoUpdated({this.data}) : super();

  @override
  String toString() => 'UserProfilePhotoUpdated';
}

class UserProfilePhotoNotUpdate extends UserDetailState {
  @override
  String toString() => 'UserProfilePhotoNotUpdate';
}
