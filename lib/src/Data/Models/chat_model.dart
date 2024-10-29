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

  static Chat fromMap(Map<String,dynamic> snap){
    return Chat(
      id: snap['id'], 
      userId: snap['userId'], 
      matchedUserId: snap['matchedUserId'], 
      messages: snap['messages']);
  }


 }

