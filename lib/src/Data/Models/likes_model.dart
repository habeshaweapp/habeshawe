import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:lomi/src/Data/Models/user.dart';

class Like extends Equatable{
  final String userId;
  final Timestamp timestamp;
  final User user;
  final bool? superLike;
  // final String name;
  // final int age;
  // final List<dynamic> imageUrl
  // /String? timestamp;
  //  FieldValue? timestamptemp;
  // final String verified;

   Like({
    required this.userId,
    required this.timestamp,
    required this.user,
     this.superLike = false,
  });

  factory Like.fromSnapshoot(DocumentSnapshot snap){
    return Like(
      userId: snap['userId'],
      timestamp: snap['timestamp'],
      superLike: (snap.data() as Map<String, dynamic>).containsKey('superLike') ? snap['superLike'] : false,
      user: User.fromSnapshootMapType(snap)
      );
  }

  Map<String, dynamic> toMap(){
    return {
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
      'superLike': superLike,
      'user': user.toMap()
    };
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [userId,timestamp,superLike,user];


}