import 'package:meta/meta.dart';

@immutable
abstract class NetworkScreenState {
  NetworkScreenState([props = const []]) : super();
}

class NetworkScreenLoading extends NetworkScreenState {
  @override
  String toString() => 'NetworkScreenLoading';
}

class NetworkScreenLoaded extends NetworkScreenState {
  final List myNetworkList;

  NetworkScreenLoaded({
    this.myNetworkList,
  }) : super();

  @override
  String toString() => 'NetworkScreenLoaded';
}

class NetworkScreenNotLoaded extends NetworkScreenState {
  @override
  String toString() => 'NetworkScreenNotLoaded';
}
