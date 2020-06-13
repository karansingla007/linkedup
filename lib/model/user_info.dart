import 'package:flutter/cupertino.dart';

class UserInfo {
  final String profilePicUrl;
  final String lastName;
  final String firstName;
  final String userName;
  final String userId;

  UserInfo({
    @required this.profilePicUrl,
    @required this.lastName,
    @required this.firstName,
    @required this.userName,
    @required this.userId,
  });
}
