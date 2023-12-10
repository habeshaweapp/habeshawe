
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

import 'enums.dart';

class User extends Equatable {
  final String id;
  final String name;
  final int age;
  final String gender;
  final List<dynamic> imageUrls;
  final List<dynamic> interests;
  final int? lookingFor;
  final String? jobTitle;
  final List<double>? location;
  final String? school;
  final String? birthday;
  final String? company;
  final String? aboutMe;
  final String? education;
  final String? livingIn;
  final String? geohash;
  final String? verified;
  final String? country;
  final String? countryCode;
  final bool? online;
  final Timestamp? lastseen;
  final int? height;
  final String? city;
  final String? phoneNumber;
  final int? number;
  final String? email;
  final String? provider;

  const User({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.imageUrls,
    required this.interests,
     this.lookingFor,
     this.jobTitle,
     this.location,
     this.school,
     this.birthday,
     this.aboutMe,
     this.company,
     this.education,
     this.livingIn,
     this.geohash,
     this.verified= 'notVerified',
     this.country,
     this.countryCode,
     this.online,
     this.lastseen,
     this.height,
     this.city,
     this.phoneNumber,
     this.number,
     this.email,
     this.provider
  });

  @override
  List<Object?> get props => [
        id,
        name,
        age,
        gender,
        imageUrls,
        interests,
        lookingFor,
        jobTitle,
        location,
        birthday,
        school,
        aboutMe,
        company,
        education,
        livingIn, 
        geohash,
        verified,
        country,   
        countryCode,
        online,
        lastseen,
        height,
        city,
        phoneNumber,
        number,
        email,
        provider
      ];

  factory User.fromSnapshoot(DocumentSnapshot snap){
    try {
      var map = snap.data() as Map<String, dynamic>;
  return User(
    id: snap.id,  
    name: snap['name'],
    age: snap['age'],
    imageUrls: snap['imageUrls'],
    gender: snap['gender'],    
    interests: snap['interests'],
    location: [snap['location'].latitude, snap['location'].longitude ],
    school: snap['school'],
    birthday: snap['birthday'],
    aboutMe: snap['aboutMe'] ,
    company: snap['company'] ,
    education: snap['education'],
    livingIn: snap['livingIn'] ,
    jobTitle: snap['jobTitle'] ,
    lookingFor: snap['lookingFor'],
    geohash: snap['geohash'],
    verified: map.containsKey('verified') ? snap['verified'] : null,
    country: snap['country'],
    countryCode: snap['countryCode'],
    online: map.containsKey('online')? snap['online']:null,
    lastseen: map.containsKey('lastseen')? snap['lastseen'] :null,
    height: map.containsKey('height')? snap['height']:null,
    city: map.containsKey('city')? snap['city']:null,
    phoneNumber: map.containsKey('phoneNumber')? snap['phoneNumber']:null,
    number: map.containsKey('number')? snap['number']:null,
    email: map.containsKey('email')? snap['email']:null,
    provider: map.containsKey('provider')? snap['provider']:null,
    

  );
} on Exception catch (e) {
  // TODO
  print(e);
  throw Exception(e);
}

  }

  factory User.fromSnapshootOld(DocumentSnapshot snap){
    return User(
      id: snap.id,  
      name: snap['name'],
      age: snap['age'],
      imageUrls: snap['imageUrls'],
      gender: snap['gender'],    
      interests: snap['interests'],
      location: snap['location'],
      school: snap['school'],
      birthday: snap['birthday'],
      aboutMe: snap['aboutMe'] ,
      company: snap['company'] ,
      education: snap['education'],
      livingIn: snap['livingIn'] ,
      jobTitle: snap['jobTitle'] ,
      lookingFor: snap['lookingFor'],
      phoneNumber: snap['phoneNumber']

    );

  }


  Map<String, dynamic> toMap(){
    return {
      'id':id,
      'name': name,
      'age': age,
      'gender': gender,
      'imageUrls': imageUrls,
      'interests': interests,
      'lookingFor': lookingFor,
      'location': GeoPoint(location![0], location![1]),
      'school': school,
      'birthday': birthday,
      'aboutMe' : aboutMe,
      'company' : company,
      'education' : education,
      'livingIn' : livingIn,
      'jobTitle': jobTitle,
      'geohash': geohash,
      'verified': verified,
      'country': country,
      'countryCode': countryCode,
      'online': online,
      'lastseen': lastseen,
      'city': city,
      'height': height,
      'phoneNumber': phoneNumber,
      'number': number,
      'email': email,
      'provider': provider
    };
  }

  Map<String, dynamic> toJson(){
    return {
      'id':id,
      'name': name,
      'age': age,
      'gender': gender,
      'imageUrls': imageUrls,
      'interests': interests,
      'lookingFor': lookingFor,
      'location': location ,
      'school': school,
      'birthday': birthday,
      'aboutMe' : aboutMe,
      'company' : company,
      'education' : education,
      'livingIn' : livingIn,
      'jobTitle': jobTitle,
      'geohash': geohash,
      'verified': verified,
      'country': country,
      'countryCode': countryCode,
      'online': online,
      'lastseen': lastseen?.toDate().toIso8601String(),
      'city': city,
      'height': height,
      'phoneNumber': phoneNumber,
      'number': number,
      'email':email,
      'provider':provider
    };
  }

   User copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    List<dynamic>? imageUrls,
    List<dynamic>? interests,
    int? lookingFor,
    List<double>? location,
    String? school,
    String? birthday,
    String? company,
    String? aboutMe,
    String? education,
    String? livingIn,
    String? jobTitle,
    String? geohash,
    String? verified,
    String? country,
    String? countryCode,
    bool? online,
    Timestamp? lastseen,
    int? height,
    String? city,
    String? phoneNumber,
    int? number,
    String? email,
    String? provider

  }){
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      imageUrls: imageUrls ?? this.imageUrls,
      interests: interests ?? this.interests,
      lookingFor: lookingFor ?? this.lookingFor,
      location: location ?? this.location,
      school: school ?? this.school,
      birthday: birthday ?? this.birthday,
      aboutMe: aboutMe ?? this.aboutMe,
      company: company ?? this.company,
      education: education ?? this.education,
      livingIn: livingIn ?? this.livingIn,
      jobTitle: jobTitle ?? this.jobTitle,
      geohash: geohash ?? this.geohash,
      verified: verified ?? this.verified,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      online: online?? this.online,
      lastseen: lastseen??this.lastseen,
      city: city?? this.city,
      height: height?? this.height,
      phoneNumber: phoneNumber??this.phoneNumber,
      number: number??this.number,
      email: email??this.email,
      provider: provider??this.provider
    );
  }




factory User.fromSnapshootMapType(DocumentSnapshot snapshot){
  final snap = snapshot['user'];
    try {
  return User(
    id: snapshot.id,  
    name: snap['name'],
    age: snap['age'],
    imageUrls: snap['imageUrls'],
    gender: snap['gender'],    
    interests: snap['interests'],
    location: snap.containsKey('location') ?[snap['location'].latitude, snap['location'].longitude]: null,
    school: snap['school'],
    birthday: snap['birthday'],
    aboutMe: snap['aboutMe'] ,
    company: snap['company'] ,
    education: snap['education'],
    livingIn: snap['livingIn'] ,
    jobTitle: snap['jobTitle'] ,
    lookingFor: snap['lookingFor'],
    geohash: snap['geohash'],
    verified: snap.containsKey('verified') ? snap['verified'] : null,
    country: snap['country'],
    countryCode: snap['countryCode'],
    online:  snap['online'],
    lastseen: snap['lastseen'],
    height:  snap['height'],
    city: snap['city'],
    phoneNumber: snap['phoneNumber'],
    number: snap.containsKey('number') ? snap['number'] : null,
    email:snap.containsKey('email') ? snap['email'] : null,
    provider: snap.containsKey('provider') ? snap['provider'] : null,
  );
} on Exception catch (e) {
  // TODO
  print(e);
  throw Exception(e);
}

  }



  factory User.fromMap(Map<String ,dynamic>snap){
  //final snap = snapshot['user'];
    try {
  return User(
    id: snap['id'],  
    name: snap['name'],
    age: snap['age'],
    imageUrls: snap['imageUrls'],
    gender: snap['gender'],    
    interests: snap['interests'],
    location: snap['location'] ,
    school: snap['school'],
    birthday: snap['birthday'],
    aboutMe: snap['aboutMe'] ,
    company: snap['company'] ,
    education: snap['education'],
    livingIn: snap['livingIn'] ,
    jobTitle: snap['jobTitle'] ,
    lookingFor: snap['lookingFor'],
    geohash: snap['geohash'],
    verified: snap.containsKey('verified') ? snap['verified'] : null,
    country: snap['country'],
    countryCode: snap['countryCode'],
    online:  snap['online'],
    //lastseen: DateTime.parse(snap['lastseen']),
    height:  snap['height'],
    city: snap['city'],
    phoneNumber: snap['phoneNumber'],
    number: snap['number'],
    email:snap.containsKey('email') ? snap['email'] : null,
    provider: snap.containsKey('provider') ? snap['provider'] : null,

  );
} on Exception catch (e) {
  // TODO
  print(e);
  throw Exception(e);
}

  }


    factory User.fromBoost(dynamic snap){
    try {
  
  return User(
    id: snap['id'],  
    name: snap['name'],
    age: snap['age'],
    imageUrls: snap['imageUrls'],
    gender: snap['gender'],    
    interests: snap['interests'],
    location: [snap['location'].latitude, snap['location'].longitude ],
    school: snap['school'],
    birthday: snap['birthday'],
    aboutMe: snap['aboutMe'] ,
    company: snap['company'] ,
    education: snap['education'],
    livingIn: snap['livingIn'] ,
    jobTitle: snap['jobTitle'] ,
    lookingFor: snap['lookingFor'],
    geohash: snap['geohash'],
    verified: snap.containsKey('verified') ? snap['verified'] : null,
    country: snap['country'],
    countryCode: snap['countryCode'],
    online: snap.containsKey('online')? snap['online']:null,
    lastseen: snap.containsKey('lastseen')? snap['lastseen'] :null,
    height: snap.containsKey('height')? snap['height']:null,
    city: snap.containsKey('city')? snap['city']:null,
    phoneNumber: snap.containsKey('phoneNumber')? snap['phoneNumber']:null,
    number: snap.containsKey('number')? snap['number']:null,
    email: snap.containsKey('email')? snap['email']:null,
    provider: snap.containsKey('provider')? snap['provider']:null,
    

  );
} on Exception catch (e) {
  // TODO
  print(e);
  throw Exception(e);
}

  }




}