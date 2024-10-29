import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'model.dart';

class UserMatch extends Equatable{
  final String? id;
  final String userId;
  final String name;
  final List<dynamic> imageUrls;
   String? verified;
  final bool chatOpened;
  final Timestamp? timestamp;
  final bool? superLike;
  final String gender;

   UserMatch({ this.id, required this.userId, required this.name,required this.gender, required this.imageUrls,  this.verified,  this.timestamp, required this.chatOpened, required this.superLike});
  
  @override
  // TODO: implement props
  List<Object?> get props => [id,userId,name,imageUrls,verified,timestamp,chatOpened,superLike,gender];

  static UserMatch fromSnapshoot(DocumentSnapshot snap){
    return UserMatch(
      id: snap.id, 
      userId: snap['userId'],
      name: snap['name'],
      imageUrls: snap['imageUrls'],
      verified: (snap.data() as Map<String, dynamic>).containsKey('verified') ? snap['verified'] : null,
      timestamp: snap['timestamp'],
      chatOpened: snap['chatOpened'],
      superLike:(snap.data() as Map<String, dynamic>).containsKey('superLike') ? snap['superLike'] : null,
      gender: (snap.data() as Map<String, dynamic>).containsKey('gender') ? snap['gender'] : 'women',
      );
  }

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'userId': userId,
      'name': name,
      'imageUrls': imageUrls,
      'verified': verified,
      'timestamp': timestamp,
      'chatOpened': chatOpened,
      'superLike': superLike,
      'gender':gender
    };

  }



}