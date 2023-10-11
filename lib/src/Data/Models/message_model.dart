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
  List<Object?> get props => [id,senderId,receiverId,message,imageUrl];

  static Message fromSnapshoot(DocumentSnapshot snap){
    return Message(
      id: snap.id, 
      senderId: snap['senderId'], 
      receiverId: snap['receiverId'], 
      message: snap['message'],
      timestamp: snap['timestamp'],
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




  // static List<Message> messages = [
  //   Message(
  //       id: 1,
  //       senderId: 1,
  //       receiverId: 2,
  //       message: 'Hey, how are you?',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
  //   Message(
  //       id: 2,
  //       senderId: 2,
  //       receiverId: 1,
  //       message: 'I\'m good, thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),

  //   Message(
  //       id: 3,
  //       senderId: 1,
  //       receiverId: 2,
  //       message: 'I\'m good, as well. Thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),
  //       ),
  //       Message(
  //       id: 1,
  //       senderId: 1,
  //       receiverId: 2,
  //       message: 'Hey, how are you?',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
  //   Message(
  //       id: 2,
  //       senderId: 2,
  //       receiverId: 1,
  //       message: 'I\'m good, thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
        
  //   Message(
  //       id: 3,
  //       senderId: 1,
  //       receiverId: 2,
  //       message: 'I\'m good, as well. Thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),
  //       ),
  //       Message(
  //       id: 1,
  //       senderId: 1,
  //       receiverId: 2,
  //       message: 'Hey, how are you?',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
  //   Message(
  //       id: 2,
  //       senderId: 2,
  //       receiverId: 1,
  //       message: 'I\'m good, thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
        
  //   Message(
  //       id: 3,
  //       senderId: 1,
  //       receiverId: 2,
  //       message: 'I\'m good, as well. Thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),
  //       ),
  //       Message(
  //       id: 1,
  //       senderId: 1,
  //       receiverId: 2,
  //       message: 'Hey, how are you?',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
  //   Message(
  //       id: 2,
  //       senderId: 2,
  //       receiverId: 1,
  //       message: 'I\'m good, thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
        
  //   Message(
  //       id: 3,
  //       senderId: 1,
  //       receiverId: 2,
  //       message: 'I\'m good, as well. Thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),
  //       ),
  //       Message(
  //       id: 1,
  //       senderId: 1,
  //       receiverId: 2,
  //       message: 'Hey, how are you?',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
  //   Message(
  //       id: 2,
  //       senderId: 2,
  //       receiverId: 1,
  //       message: 'I\'m good, thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
        
  //   Message(
  //       id: 3,
  //       senderId: 1,
  //       receiverId: 2,
  //       message: 'I\'m good, as well. Thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),
  //       ),
  //   Message(
  //       id: 4,
  //       senderId: 1,
  //       receiverId: 3,
  //       message: 'Hey, how are you?',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
  //   Message(
  //       id: 5,
  //       senderId: 3,
  //       receiverId: 1,
  //       message: 'I\'m good, thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
  //   Message(
  //       id: 6,
  //       senderId: 1,
  //       receiverId: 5,
  //       message: 'Hey, how are you?',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
  //   Message(
  //       id: 7,
  //       senderId: 5,
  //       receiverId: 1,
  //       message: 'I\'m good, thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
  //   Message(
  //       id: 8,
  //       senderId: 1,
  //       receiverId: 6,
  //       message: 'Hey, how are you?',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
  //   Message(
  //       id: 9,
  //       senderId: 6,
  //       receiverId: 1,
  //       message: 'I\'m good, thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
  //   Message(
  //       id: 10,
  //       senderId: 1,
  //       receiverId: 7,
  //       message: 'i kan not belive my eyes',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
  //   Message(
  //       id: 11,
  //       senderId: 7,
  //       receiverId: 1,
  //       message: 'I\'m good, thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateTime.now().toString(),),
  // ];


}

// class DateFormat {
// }