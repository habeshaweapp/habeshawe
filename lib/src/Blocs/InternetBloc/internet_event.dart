part of 'internet_bloc.dart';

class InternetEvent extends Equatable {
  const InternetEvent();

  @override
  List<Object> get props => [];
}

class ConnectionChanged extends InternetEvent{
  final ConnectivityResult result;

  const ConnectionChanged({required this.result});
}
