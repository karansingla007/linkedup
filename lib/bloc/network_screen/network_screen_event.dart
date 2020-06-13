import 'package:meta/meta.dart';

@immutable
abstract class NetworkScreenEvent {
  NetworkScreenEvent() : super();
}

class LoadNetworkScreen extends NetworkScreenEvent {
  LoadNetworkScreen();

  @override
  String toString() => 'LoadNetworkScreen';
}
