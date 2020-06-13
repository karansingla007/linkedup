import 'package:meta/meta.dart';

@immutable
abstract class UserInfoScreenEvent {
  UserInfoScreenEvent() : super();
}

class LoadUserInfoScreen extends UserInfoScreenEvent {
  final Map body;

  LoadUserInfoScreen({@required this.body});

  @override
  String toString() => 'LoadUserInfoScreen';
}
