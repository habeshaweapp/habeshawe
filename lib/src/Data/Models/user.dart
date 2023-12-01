
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
     this.number
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
        number
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
    number: map.containsKey('number')? snap['number']:null

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
      'number': number
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
      'number': number
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
    int? number

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
      number: number??this.number
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
    number: snap['number']
  );
} on Exception catch (e) {
  // TODO
  print(e);
  throw Exception(e);
}

  }


















//   static List<User> users = [
//     User(
//       id: '1',
//       name: 'John',
//       age: 25,
//       gender: 'Male',
//       imageUrls: [
//         'https://images.unsplash.com/photo-1595623238469-fc58b3839cf6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=755&q=80',
//         'https://images.unsplash.com/photo-1595623238469-fc58b3839cf6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=755&q=80',
//         'https://images.unsplash.com/photo-1595623238469-fc58b3839cf6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=755&q=80',
//         'https://images.unsplash.com/photo-1595623238469-fc58b3839cf6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=755&q=80',
//         'https://images.unsplash.com/photo-1595623238469-fc58b3839cf6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=755&q=80',
//       ],
//       jobTitle: 'Job Title Here',
//       interests: ['Music', 'Economics', 'Football'],
//       bio:
//           'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
//       location: 'Milan',
//     ),
//     User(
//       id: '2',
//       name: 'Tamara',
//       age: 30,
//       gender: 'Female',
//       imageUrls: [
//         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
//         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
//         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
//         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
//         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
//       ],
//       jobTitle: 'Job Title Here',
//       interests: ['Music', 'Economics', 'Football'],
//       bio:
//           'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
//       location: 'Milan',
//     ),
//     User(
//       id: '3',
//       name: 'Marta',
//       age: 35,
//       gender: 'Female',
//       imageUrls: [
//         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//       ],
//       jobTitle: 'Job Title Here',
//       interests: ['Music', 'Economics', 'Football'],
//       bio:
//           'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
//       location: 'Milan',
//     ),
//     User(
//       id: '4',
//       name: 'Sara',
//       age: 30,
//       gender: 'Female',
//       imageUrls: [
//         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
//         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
//         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
//         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
//         'https://images.unsplash.com/photo-1622023459113-9b195477d9c4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=671&q=80',
//       ],
//       jobTitle: 'Job Title Here',
//       interests: ['Music', 'Economics', 'Football'],
//       bio:
//           'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
//       location: 'Milan',
//     ),
//     User(
//       id: '5',
//       name: 'Anna',
//       age: 35,
//       gender: 'Female',
//       imageUrls: [
//         'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//       ],
//       jobTitle: 'Job Title Here',
//       interests: ['Music', 'Economics', 'Football'],
//       bio:
//           'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
//       location: 'Milan',
//     ),
//     User(
//       id: '6',
//       name: 'Lisa',
//       age: 35,
//       gender: 'Female',
//       imageUrls: [
//         'https://images.unsplash.com/photo-1503185912284-5271ff81b9a8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1503185912284-5271ff81b9a8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1503185912284-5271ff81b9a8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1503185912284-5271ff81b9a8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1503185912284-5271ff81b9a8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//       ],
//       jobTitle: 'Job Title Here',
//       interests: ['Music', 'Economics', 'Football'],
//       bio:
//           'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
//       location: 'Milan',
//     ),
//     User(
//       id: '7',
//       name: 'Luisa',
//       age: 35,
//       gender: 'Female',
//       imageUrls: [
//         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//       ],
//       jobTitle: 'Job Title Here',
//       interests: ['Music', 'Economics', 'Football'],
//       bio:
//           'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
//       location: 'Milan',
//     ),
//     User(
//       id: '8',
//       name: 'Sara',
//       age: 35,
//       gender: 'Female',
//       imageUrls: [
//         'https://images.unsplash.com/photo-1589571894960-20bbe2828d0a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=633&q=80',
//         'https://images.unsplash.com/photo-1589571894960-20bbe2828d0a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=633&q=80',
//         'https://images.unsplash.com/photo-1589571894960-20bbe2828d0a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=633&q=80',
//         'https://images.unsplash.com/photo-1589571894960-20bbe2828d0a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=633&q=80',
//         'https://images.unsplash.com/photo-1589571894960-20bbe2828d0a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=633&q=80',
//       ],
//       jobTitle: 'Job Title Here',
//       interests: ['Music', 'Economics', 'Football'],
//       bio:
//           'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
//       location: 'Milan',
//     ),
//     User(
//       id: '9',
//       name: 'Andrea',
//       age: 35,
//       gender: 'Female',
//       imageUrls: [
//         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1622244099803-75318348305a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//       ],
//       jobTitle: 'Job Title Here',
//       interests: ['Music', 'Economics', 'Football'],
//       bio:
//           'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
//       location: 'Milan',
//     ),
//     User(
//       id: '10',
//       name: 'Mary',
//       age: 35,
//       gender: 'Female',
//       imageUrls: [
//         'https://images.unsplash.com/photo-1456885284447-7dd4bb8720bf?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1456885284447-7dd4bb8720bf?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1456885284447-7dd4bb8720bf?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1456885284447-7dd4bb8720bf?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//         'https://images.unsplash.com/photo-1456885284447-7dd4bb8720bf?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//       ],
//       jobTitle: 'Job Title Here',
//       interests: ['Music', 'Economics', 'Football'],
//       bio:
//           'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
//       location: 'Milan',
//     ),
//     User(
//       id: '11',
//       name: 'Denise',
//       age: 35,
//       gender: 'Female',
//       imageUrls: [
//         'https://images.unsplash.com/photo-1596815064285-45ed8a9c0463?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=615&q=80',
//         'https://images.unsplash.com/photo-1596815064285-45ed8a9c0463?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=615&q=80',
//         'https://images.unsplash.com/photo-1596815064285-45ed8a9c0463?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=615&q=80',
//         'https://images.unsplash.com/photo-1596815064285-45ed8a9c0463?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=615&q=80',
//         'https://images.unsplash.com/photo-1596815064285-45ed8a9c0463?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=615&q=80',
//       ],
//       jobTitle: 'Job Title Here',
//       interests: ['Music', 'Economics', 'Football'],
//       bio:
//           'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
//       location: 'Milan',
//     ),
//     User(
//       id: '12',
//       name: 'Elle',
//       age: 35,
//       gender: 'Female',
//       imageUrls: [
//         'https://images.unsplash.com/photo-1562003389-902303a38425?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1429&q=80',
//         'https://images.unsplash.com/photo-1562003389-902303a38425?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1429&q=80'
//             'https://images.unsplash.com/photo-1562003389-902303a38425?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1429&q=80'
//             'https://images.unsplash.com/photo-1562003389-902303a38425?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1429&q=80'
//             'https://images.unsplash.com/photo-1562003389-902303a38425?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1429&q=80'
//       ],
//       jobTitle: 'Job Title Here',
//       interests: ['Music', 'Economics', 'Football'],
//       bio:
//           'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
//       location: 'Milan',
//     ),
//   ];
}