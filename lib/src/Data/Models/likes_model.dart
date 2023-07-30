import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Like extends Equatable{
  final String userId;
  final String name;
  final int age;
  final List<dynamic> imageUrls;
  String? timestamp;
  FieldValue? timestamptemp;
  final String verified;

   Like({
    required this.userId,
    required this.name,
    required this.age,
    required this.imageUrls,
    required this.verified,
    this.timestamp,
    this.timestamptemp,
  });

  factory Like.fromSnapshoot(DocumentSnapshot snap){
    return Like(
      userId: snap['userId'],
      name: snap['name'], 
      age: snap['age'], 
      imageUrls: snap['imageUrls'], 
      timestamp: snap['timestamp'],
      verified: snap['verified'],
      );
  }

  Map<String, dynamic> toMap(){
    return {
      'userId': userId,
      'name': name,
      'age': age,
      'imageUrls': imageUrls,
      'timestamp': timestamptemp,
      'verified': verified,
    };
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [name,age,imageUrls,timestamp,timestamptemp, verified];


}