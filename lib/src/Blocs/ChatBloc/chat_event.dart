part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChats extends ChatEvent{
  final String userId;
  final String matchedUserId;

  LoadChats({required this.userId, required this.matchedUserId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, matchedUserId];
}

class UpdateChats extends ChatEvent{
  final List<Message> messages;

  UpdateChats({required this.messages});

  @override
  // TODO: implement props
  List<Object> get props => [messages];
}

class SendMessage extends ChatEvent{
  Message message;

  SendMessage({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

class LoadMoreChats extends ChatEvent{
  String userId;
  String matchedUserId;
  Timestamp startAfter;

  LoadMoreChats({required this.userId,required this.matchedUserId ,required this.startAfter});

  @override
  List<Object> get props => [startAfter];
}
