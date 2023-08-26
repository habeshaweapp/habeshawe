import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Payment extends Equatable{
  final String country;
  final String countryCode;
  final Map<String, dynamic> placeMark;
  final String paymentType;
  final String expireDate;
  final Map<String, dynamic> paymentDetails;

  const Payment({required this.country, required this.countryCode, required this.placeMark,required this.expireDate, required this.paymentType, required this.paymentDetails });

  factory Payment.fromSnapshoot(DocumentSnapshot snap){
    return Payment(
      country: snap['country'], 
      countryCode: snap['countryCode'], 
      placeMark: snap['placeMark'], 
      expireDate: snap['expireDate'], 
      paymentType: snap['paymentType'], 
      paymentDetails: snap['paymentDetails']
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
    };
  }



  @override
  // TODO: implement props
  List<Object?> get props => [];


}