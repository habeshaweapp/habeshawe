part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChats extends ChatEvent{
  final String userId;
  final Gender users;
  final String matchedUserId;

  LoadChats({required this.userId, required this.users, required this.matchedUserId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, matchedUserId, users];
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
  Gender users;
  XFile? image;

  SendMessage({required this.message, required this.users, this.image});

  @override
  // TODO: implement props
  List<Object> get props => [message, users];
}

class LoadMoreChats extends ChatEvent{
  String userId;
  String matchedUserId;
  Timestamp startAfter;
  Gender users;

  LoadMoreChats({required this.userId,required this.matchedUserId ,required this.startAfter, required this.users});

  @override
  List<Object> get props => [startAfter, userId, matchedUserId,startAfter,users];
}

class FirstMessageSent extends ChatEvent{
  final Message message;

  const FirstMessageSent({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

class SeenMessage extends ChatEvent{
  final Message message;
  final Gender users;
  const SeenMessage({required this.message, required this.users});

  @override
  // TODO: implement props
  List<Object> get props => [message,users];
}

class UnMatch extends ChatEvent{
  final String userId;
  final Gender gender;
  final UserMatch matchUser;

  const UnMatch({
    required this.userId,
    required this.gender,
    required this.matchUser
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId, gender, matchUser];
}

class ReportMatch extends ChatEvent{
  final String userId;
  final Gender gender;
  final UserMatch matchUser;
  final int index;
  final String reportName;
  final String description;

  const ReportMatch({
    required this.userId,
    required this.gender,
    required this.matchUser,
    required this.index,
    required this.reportName,
    required this.description
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId, gender, matchUser, index, reportName, description];

}

class DeleteMessage extends ChatEvent{
  final Message message;
  final bool deleteAlso;
  final Gender gender;

  const DeleteMessage({required this.message , this.deleteAlso=true, required this.gender});

  @override
  // TODO: implement props
  List<Object> get props => [message, deleteAlso, gender];
}

class EditMessage extends ChatEvent{
  final Message message;
  final Gender gender;
  final String newMessage;

  const EditMessage({required this.message, required this.gender, required this.newMessage});

  @override
  // TODO: implement props
  List<Object> get props => [message, gender];
}