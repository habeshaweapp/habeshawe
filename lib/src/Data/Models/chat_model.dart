import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'model.dart';
class Chat extends Equatable{
  final String id;
  final int userId;
  final int matchedUserId;
  // final String? imageUrl;
  // final String? lastMessage;
  final List<Message>? messages;

  const Chat({
    required this.id,
    required this.userId,
    required this.matchedUserId,
    required this.messages,
 
    
    
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [id, userId,matchedUserId,messages];

  static Chat fromSnapshoot(DocumentSnapshot snap){
    return Chat(
      id: snap.id, 
      userId: snap['userId'], 
      matchedUserId: snap['matchedUserId'], 
      messages: snap['messages']);
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'userId': userId,
      'matchedUserId': matchedUserId,
      'messages': messages,
    };
  }






//   static List<Chat> chats = [
//     Chat(
//       id: 1,
//       userId: 1,
//       matchedUserId: 2,
//       messages: Message.messages
//           .where((message) =>
//               (message.senderId == 1 && message.receiverId == 2) ||
//               (message.senderId == 2 && message.receiverId == 1))
//           .toList(),
//     ),
//     Chat(
//       id: 2,
//       userId: 1,
//       matchedUserId: 3,
//       messages: Message.messages
//           .where((message) =>
//               (message.senderId == 1 && message.receiverId == 3) ||
//               (message.senderId == 3 && message.receiverId == 1))
//           .toList(),
//     ),
//     Chat(
//       id: 3,
//       userId: 1,
//       matchedUserId: 5,
//       messages: Message.messages
//           .where((message) =>
//               (message.senderId == 1 && message.receiverId == 5) ||
//               (message.senderId == 5 && message.receiverId == 1))
//           .toList(),
//     ),
//     Chat(
//       id: 4,
//       userId: 1,
//       matchedUserId: 6,
//       messages: Message.messages
//           .where((message) =>
//               (message.senderId == 1 && message.receiverId == 6) ||
//               (message.senderId == 6 && message.receiverId == 1))
//           .toList(),
//     ),
//   ];
 }

