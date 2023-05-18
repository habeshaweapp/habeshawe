part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  
  @override
  List<Object?> get props => [];
}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState{
  final List<Message>? messages;
  
  ChatLoaded({required this.messages});

  @override
  // TODO: implement props
  List<Object?> get props => [messages];
}
