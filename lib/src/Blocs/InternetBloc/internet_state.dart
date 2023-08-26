part of 'internet_bloc.dart';

class InternetState extends Equatable {
  const InternetState();
  
  @override
  List<Object> get props => [];
}

class InternetInitial extends InternetState {}

class InternetStatus extends InternetState{
  final bool isConnected;
  const InternetStatus({required this.isConnected});

  @override
  // TODO: implement props
  List<Object> get props => [isConnected];
}
