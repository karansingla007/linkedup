import 'dart:io';

import 'package:meta/meta.dart';

@immutable
abstract class UserDetailEvent {
  UserDetailEvent() : super();
}

class LoadIsCurrentUser extends UserDetailEvent {
  final String userId;

  LoadIsCurrentUser({@required this.userId});

  @override
  String toString() => 'LoadIsCurrentUser';
}

class LoadCurrentUserInfo extends UserDetailEvent {
  @override
  String toString() => 'LoadCurrentUserInfo';
}

class LoadUserInfo extends UserDetailEvent {
  final String userId;

  LoadUserInfo({this.userId});

  @override
  String toString() => 'LoadCurrentUserInfo';
}

class UpdateUserDetail extends UserDetailEvent {
  final Map userInfo;

  UpdateUserDetail({this.userInfo});

  @override
  String toString() => 'UpdateUserDetail';
}

class UploadProfilePhoto extends UserDetailEvent {
  final File imageFile;
  final String url;

  UploadProfilePhoto({this.imageFile, this.url});

  @override
  String toString() => 'UpdateUserDetail';
}
