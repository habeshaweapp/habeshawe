import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:lomi/src/Blocs/blocs.dart';

class Payment extends Equatable{
  final String country;
  final String countryCode;
  final Map<String, dynamic> placeMark;
  final String paymentType;
  final int expireDate;
  final Map<String, dynamic> paymentDetails;
  final int subscribtionStatus;
  final int boosts;
  final int superLikes;

  const Payment({ this.boosts =0,  this.superLikes =0, this.subscribtionStatus = 0, required this.country, required this.countryCode, required this.placeMark,required this.expireDate, required this.paymentType, required this.paymentDetails });

  factory Payment.fromSnapshoot(DocumentSnapshot snap){
    return Payment(
      country: snap['country'], 
      countryCode: snap['countryCode'], 
      placeMark: snap['placeMark'], 
      expireDate: snap['expireDate'], 
      paymentType: snap['paymentType'], 
      paymentDetails: snap['paymentDetails'],
      subscribtionStatus: snap['subscribtionStatus'],
      boosts: snap['boosts'],
      superLikes: snap['superLikes']
      );
  }

  Map<String, dynamic> toMap(){
    return {
      'country': country,
      'countryCode': countryCode,
      'placeMark': placeMark, 
      'expireDate': expireDate, 
      'paymentType': paymentType, 
      'paymentDetails': paymentDetails,
      'subscribtionStatus': subscribtionStatus,
      'boosts': boosts,
      'superLikes': superLikes
    };
  }



  @override
  // TODO: implement props
  List<Object?> get props => [country, countryCode,placeMark,expireDate,paymentType,paymentDetails,subscribtionStatus,boosts,superLikes];


}