part of 'last_message_cubit.dart';

abstract class LastMessageState extends Equatable {
  const LastMessageState();

  @override
  List<Object> get props => [];
}

class LastMessageInitial extends LastMessageState {}

class LastMessageLoading extends LastMessageState {}

class LastMessageLoaded extends LastMessageState{
  final Message message;
  const LastMessageLoaded({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
