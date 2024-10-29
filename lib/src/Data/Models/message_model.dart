import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';


class Message extends Equatable{
  final String id;
  final String senderId;
  final String receiverId;
  final String message;

  final String? imageUrl;
  final Timestamp? timestamp;
  final Timestamp? seen;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.imageUrl,
    this.timestamp,
    this.seen
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [id,senderId,receiverId,message,imageUrl,seen,timestamp];

  static Message fromSnapshoot(DocumentSnapshot snap){
    return Message(
      id: snap.id, 
      senderId: snap['senderId'], 
      receiverId: snap['receiverId'], 
      message: snap['message'],
      timestamp: snap['timestamp'],
      imageUrl: snap['imageUrl'],
      seen: (snap.data() as Map<String,dynamic>).containsKey('seen')?snap['seen']:null
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'imageUrl': imageUrl,
      'seen': seen
    };
  }

   static Message fromMap(Map<String,dynamic> snap){
    return Message(
      id: snap['id'], 
      senderId: snap['senderId'], 
      receiverId: snap['receiverId'], 
      message: snap['message'],
      timestamp: snap['timestamp'].toDate(),


    );
  }

  Message copyWith({
   String? id,
   String? senderId,
   String? receiverId,
   String? message,
   String? imageUrl,
   Timestamp? timestamp,
   Timestamp? seen,

  }){
    return Message(
      id: id?? this.id, 
      senderId: senderId?? this.senderId, 
      receiverId: receiverId??this.receiverId, 
      message: message?? this.message,
      imageUrl: imageUrl??this.imageUrl,
      timestamp: timestamp??this.timestamp,
      seen: seen??this.seen
      );
  }



}