import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:lomi/src/Data/Models/model.dart';

class Boosted extends Equatable {
  final Timestamp timestamp;
  final String gender;
  final User user;

  const Boosted({
    required this.timestamp,
    required this.gender,
    required this.user
    });

  factory Boosted.fromSnapshoot(DocumentSnapshot snap){
    return Boosted(
      timestamp: snap['timestamp'],
       gender: snap['gender'], 
       user: User.fromSnapshoot(snap['user']),
       );
  }
  @override
  // TODO: implement props
  List<Object?> get props => [timestamp, gender, user];
}