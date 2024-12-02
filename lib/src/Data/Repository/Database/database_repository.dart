import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_geo_hash/geohash.dart' as geohash;
import 'package:geocoding_platform_interface/src/models/placemark.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lomi/src/Blocs/SwipeBloc/swipebloc_bloc.dart';

import 'package:lomi/src/Data/Models/chat_model.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Models/message_model.dart';
import 'package:lomi/src/Data/Models/user.dart';
import 'package:lomi/src/Data/Models/userpreference_model.dart';
import 'package:lomi/src/Data/Repository/Remote/remote_config.dart';
import 'package:lomi/src/Data/Repository/SharedPrefes/sharedPrefes.dart';
import 'package:lomi/src/Data/Repository/Storage/storage_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/boostedModel.dart';
import '../../Models/likes_model.dart';
import '../../Models/model.dart';
import '../../Models/payment_model.dart';
import 'base_database_repository.dart';

class DatabaseRepository extends BaseDatabaseRepository{
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final RemoteConfigService remoteConfig = RemoteConfigService();
  @override
  Stream<User> getUser(String userId, Gender users) {
    try {
      return _firebaseFirestore.collection(users.name)
      .doc(userId)
      .snapshots()
      .map((snap) => User.fromSnapshoot(snap));
      
    } on FirebaseException catch(e) {
      
      print('Failed with code ${e.code} : ${e.message}');
      throw Exception(e.message);
    } on Exception
    catch (e) {
      throw Exception(e);
    }
    
     
  }

  @override
  Future<void> updateUserPictures(User user, String downloadURL) async{
    try {
  
    //String downloadURL = await StorageRepository().getDownloadURL(user,imageName);

    return await _firebaseFirestore.collection(user.gender)
            .doc(user.id)
            .update({'imageUrls': FieldValue.arrayUnion([downloadURL])});

    } on FirebaseException catch(e){
      print(e.message);
      throw Exception(e.message);
      
    } catch(e){
      print(e);
      throw(Exception(e));
    }
  }
  
  @override
  Future<void> createUser(User user) async {
    //String documentId = 
    try{
    await _firebaseFirestore.collection(user.gender).doc(user.id).set(user.toMap());
    } on FirebaseException catch(e){
      print(e.message);
      throw(Exception(e.message));
    }catch(e){
      print(e);
      throw(Exception(e));
    }
    // .then((value) {
    //   print("User added, ID: ${value.id}");
    //   return value.id;
    //   });

     
  }
  
  @override
  Future<void> updateUser(User user) async {
    try{
    return await _firebaseFirestore.collection(user.gender).doc(user.id)
    .update(user.toMap()).then((value) {print('user updated');});

    } on FirebaseException catch(e){
      print(e.message);
      throw(Exception(e.message));
    }catch(e){
      print(e);
      throw(Exception(e));
    }
    
  }
  
  @override
  Stream<List<User>> getUsers(String userId, Gender users) {
    //  Position myLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // geohash.MyGeoHash myGeoHash = geohash.MyGeoHash();
    // String hash = myGeoHash.geoHashForLocation(geohash.GeoPoint(myLocation.latitude, myLocation.longitude));
    // _firebaseFirestore.collection(user.gender).snapshots()
    // .forEach((element) {
    //   element.docs.forEach((doc) {
    //    // updateUser(User.fromSnapshootOld(doc));
    //    _firebaseFirestore.collection(user.gender).doc(doc.id)
    //    .update({'geohash': hash });
    //   });
    // });
   // _firebaseFirestore.collection(user.gender).where('location[0]', whereIn: [99,21] ).where('location[1]', whereIn: [20,12]);
    try {
  return _firebaseFirestore.collection(users.name).snapshots()
  .map((snap) => snap.docs
  .map((doc) => User.fromSnapshoot(doc)).toList() );
}on FirebaseException catch (e){
  throw Exception(e.message);
}
 on Exception catch (e) {
  // TODO
  throw Exception(e);
}

    
  }

  Future<List<User>> getUsersWithLimit(User _user) async{
    try {
      final user = await _firebaseFirestore.collection(_user.gender).doc(_user.id).get()
      .then((doc) => User.fromSnapshoot(doc));
      final preference = await _firebaseFirestore.collection(user.gender).doc(_user.gender).collection('userpreference').doc('preference').get().then((doc) => UserPreference.fromSnapshoot(doc));

      //final findWithLocation = await _firebaseFirestore.collection(user.gender)


      return await _firebaseFirestore.collection(user.gender)
          .where('gender', isEqualTo: user.gender)
          .where('age', isLessThanOrEqualTo: preference.ageRange![1])
          .where('age', isGreaterThanOrEqualTo: preference.ageRange![0])
          .limit(10)
          .get().then(
            (value) => value.docs.map((doc) => User.fromSnapshoot(doc)).toList() ); 
    }on Exception catch (e) {
      throw Exception(e);
    }
  }
  
  @override
  Future<bool> userLike(User user, User matchUser, bool superLike) async {
    try {

    var result = await _firebaseFirestore.collection(user.gender)
    .doc(user.id)
    .collection('likes')
    .doc(matchUser.id).get();

    if(!result.exists){

    
   await _firebaseFirestore
    .collection(matchUser.gender)
    .doc(matchUser.id)
    .collection('likes')
    .doc(user.id)
    //.add(likedUser.toMap()..addAll({'userId' : likedUser.id}));
    .set(
      {
        'userId': user.id,
        'timestamp': FieldValue.serverTimestamp(),
        'superLike': superLike,
        'user': user.toMap()

      }
      
    );

    var localLiked = SharedPrefes.getLikedIds();
    localLiked??='';
      SharedPrefes.setLikedIds('$localLiked,${matchUser.id}');

    var localLikedNums = SharedPrefes.getLikedNums();
    localLikedNums??='';
      SharedPrefes.setLikedNums('$localLikedNums,${matchUser.number}');



 
    // var viewed = await _firebaseFirestore.collection(user.gender).doc(user.id).collection('viewedProfiles').doc('viewed').get();
    // String liked = viewed['liked'];

    // await _firebaseFirestore
    //     .collection(user.gender)
    //     .doc(user.id)
    //     .collection('viewedProfiles')
    //     .doc('viewed')
    //     .update({
    //       'liked': '$liked,${matchUser.id}'
    //     }
    //     );

    // String likedNumbers = viewed['likedNumbers'];
    // await _firebaseFirestore
    //     .collection(user.gender)
    //     .doc(user.id)
    //     .collection('viewedProfiles')
    //     .doc('viewed')
    //     .update({
    //       'likedNumbers': '$likedNumbers,${matchUser.number}'
    //     }
    //     );
        // .doc(matchUser.id)
        // .set({'liked' : true});


    return false;
    }

    if(result.exists){
      var likedMeUser = Like.fromSnapshoot(result);
      await likeLikedMeUser(user, likedMeUser, superLike);
      return true;
    //   await _firebaseFirestore
    //   .collection(user.gender)
    //   .doc(user.id)
    //   .collection('matches')
    //   .doc(matchUser.id)
    //   .set(
    //     {
    //   'timestamp' : FieldValue.serverTimestamp(),
    //   'userId': matchUser.id,
    //   'name': matchUser.name,
    //   'imageUrls': matchUser.imageUrls,
    //   'verified': matchUser.verified,
    //   'chatOpened': false,
    //   'nameSearch': searchName(matchUser.name),
    //   'superlike': superLike,
    // }
    // );
       // UserMatch(userId: userId, matchedUser: likedUser, chat:'notOpened').toMap());

      // await _firebaseFirestore
      // .collection(user.gender)
      // .doc(matchUser.id)
      // .collection('matches')
      // .doc(user.id)
      // .set(
      //   {
      //     'timestamp' : FieldValue.serverTimestamp(),
      //     'userId': matchUser.id,
      //     'name': matchUser.name,
      //     'imageUrls': matchUser.imageUrls,
      //     'verified': matchUser.verified,
      //     'chatOpened': false,
      //     'nameSearch': searchName(matchUser.name),
      //     'superlike': superLike,
      //   }
      //   );
        
      

      // await _firebaseFirestore
      //   .collection(user.gender)
      //   .doc(user.id)
      //   .collection('likes')
      //   .doc(matchUser.id)
      //   .delete();

     // return true;

      
    }
    }on FirebaseException catch(e){
      throw Exception(e.message);
    } on Exception
     catch (e) {
      print(e.toString());
    }
    return false;

    
  }
  
  @override
  Future<void> userPassed(User user, User passedUser) async {
    try {

      var localPassed = SharedPrefes.getPassedIds();
      localPassed??='';
   
      SharedPrefes.setPassedIds('$localPassed,${passedUser.id}');

      var localPassedNums = SharedPrefes.getPassedNums();
      localPassedNums??='';
   
      SharedPrefes.setPassedNums('$localPassedNums,${passedUser.number}');
   
    
   // await _firebaseFirestore.collection(user.gender).doc(userId).collection('passed').doc(passedUser.id).set(passedUser.toMap());
    // var viewed = await _firebaseFirestore.collection(user.gender).doc(user.id).collection('viewedProfiles').doc('viewed').get();
    // String passed = viewed['passed'];
    // String newPassed = '$passed,${passedUser.id}';
    // await _firebaseFirestore
    //     .collection(user.gender)
    //     .doc(user.id)
    //     .collection('viewedProfiles')
    //     .doc('viewed')
    //     .update({
    //       'passed': newPassed
    //     });

    // String passedNumbers = viewed['passedNumbers'];
    // String newPassedNums = '$passedNumbers,${passedUser.number}';
    // await _firebaseFirestore
    //     .collection(user.gender)
    //     .doc(user.id)
    //     .collection('viewedProfiles')
    //     .doc('viewed')
    //     .update({
    //       'passedNumbers': newPassedNums
    //     });


    }on FirebaseException catch(e){
      print(e.message);
      throw Exception(e.message);
    }on Exception catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }
  
  @override
  Stream<List<UserMatch>> getMatches(String userId, Gender users)  {
    try {
  return _firebaseFirestore.collection(users.name)
  .doc(userId)
  .collection('matches')
  .where('chatOpened', isEqualTo: false)
  .orderBy('timestamp', descending: true)
  .limit(10)
  .snapshots()
  .map((snap) => snap.docs
  .map((match) => UserMatch.fromSnapshoot(match)).toList());
}on FirebaseException catch (e){
  print(e.message);
  throw Exception(e.message);

}
 on Exception catch (e) {
  // TODO

  throw Exception(e);
}
    
  }
  
  @override
  Stream<List<Like>> getLikedMeUsers(String userId, Gender users) {
   try {
  return _firebaseFirestore.collection(users.name)
   .doc(userId)
   .collection('likes')
   .orderBy('timestamp', descending: true)
   .limit(10)
   .snapshots()
   .map((snap) => 
    snap.docs
    .map((user) => Like.fromSnapshoot(user)).toList()
   );
}on FirebaseException catch (e){
  throw Exception(e.message);
}
 on Exception catch (e) {
  // TODO
  throw Exception(e);
}
  }
  
  @override
  Future<void> deleteLikedMeUser(String userId, Gender users, String likedMeUserId) async {
    try {
  await _firebaseFirestore
  .collection(users.name)
  .doc(userId)
  .collection('likes')
  .doc(likedMeUserId)
  .delete();



  // var value = await _firebaseFirestore.collection(users.name).doc(userId).collection('viewedProfiles').doc('viewed').get();
  // String viewed = value['matches'];


  //   await _firebaseFirestore
  //       .collection(users.name)
  //       .doc(userId)
  //       .collection('viewedProfiles')
  //       .doc('viewed')
  //       .update({
  //         'matches': '$viewed,$likedMeUserId false'
  //       });

  var viewed = await _firebaseFirestore.collection(users.name).doc(userId).collection('viewedProfiles').doc('viewed').get();
    String passed = viewed['passed'];
    String newPassed = '$passed,$likedMeUserId';
    await _firebaseFirestore
        .collection(users.name)
        .doc(userId)
        .collection('viewedProfiles')
        .doc('viewed')
        .update({
          'passed': newPassed
        });
//you should come here some day and fix it


    // String passedNumbers = viewed['passedNumbers'];
    // String newPassedNums = '$passedNumbers,${passedUser.number}';
    // await _firebaseFirestore
    //     .collection(user.gender)
    //     .doc(user.id)
    //     .collection('viewedProfiles')
    //     .doc('viewed')
    //     .update({
    //       'passedNumbers': newPassedNums
    //     });

}on FirebaseException catch (e){
  throw Exception(e.message);

} on Exception catch (e) {
  // TODO
  throw Exception(e);
}
  }
  
  @override
  Future<void> 
  likeLikedMeUser(User user, Like likedMeUser, bool isSuperLike) async {
    try {
    await _firebaseFirestore
    .collection(user.gender)
    .doc(user.id)
    .collection('matches')
    .doc(likedMeUser.user.id)
    .set({
          'timestamp' : FieldValue.serverTimestamp(),
          'userId': likedMeUser.user.id,
          'name': likedMeUser.user.name,
          'imageUrls': likedMeUser.user.imageUrls,
          'verified': likedMeUser.user.verified,
          'chatOpened': false,
          'nameSearch': searchName(likedMeUser.user.name),
          'superLike': likedMeUser.superLike?? false,
          'gender': likedMeUser.user.gender

    });

    await _firebaseFirestore
    .collection(likedMeUser.user.gender)
    .doc(likedMeUser.user.id)
    .collection('matches')
    .doc(user.id)
    .set({
          'timestamp' : FieldValue.serverTimestamp(),
          'userId': user.id,
          'name': user.name,
          'imageUrls': user.imageUrls,
          'verified': user.verified,
          'chatOpened': false,
          'nameSearch': searchName(user.name),
          'superLike': isSuperLike,
          'gender': user.gender
      
      
    });

    await _firebaseFirestore.collection(user.gender)
    .doc(user.id)
    .collection('likes')
    .doc(likedMeUser.user.id)
    .delete();



    var localLiked = SharedPrefes.getLikedIds();
    if(localLiked != null){
      SharedPrefes.setLikedIds('$localLiked,${likedMeUser.user.id}');
    }else{
      SharedPrefes.setLikedIds('${likedMeUser.user.id}');
    }

    var localLikedNums = SharedPrefes.getLikedNums();
    if(localLikedNums !=null){
      SharedPrefes.setLikedNums('$localLikedNums,${likedMeUser.user.number}');
    }else{
      SharedPrefes.setLikedNums('${likedMeUser.user.number}');
    }
    

    // var viewed = await _firebaseFirestore.collection(user.gender).doc(user.id).collection('viewedProfiles').doc('viewed').get();
    // String liked = viewed['liked'];

    // await _firebaseFirestore
    //     .collection(user.gender)
    //     .doc(user.id)
    //     .collection('viewedProfiles')
    //     .doc('viewed')
    //     .update({
    //       'liked': '$liked,${likedMeUser.user.id}'
    //     }
    //     );

    // String likedNumbers = viewed['likedNumbers'];
    // await _firebaseFirestore
    //     .collection(user.gender)
    //     .doc(user.id)
    //     .collection('viewedProfiles')
    //     .doc('viewed')
    //     .update({
    //       'likedNumbers': '$likedNumbers,${likedMeUser.user.number}'
    //     }
    //     );




    
      
    }on FirebaseException catch (e){
    throw Exception(e.message);
  }
    on Exception catch (e) {
      throw Exception(e);     
    }
    
  }
  
  @override
  Future<void> openChat(Message message, Gender users) async {
    try {
      //await sendMessage(message,users);
      

      await _firebaseFirestore.collection(users.name)
      .doc(message.senderId)
      .collection('matches')
      .doc(message.receiverId)
      .collection('chats')
      .doc('chat')
      .set({'timestamp': FieldValue.serverTimestamp()});
      
      //for the other user
      await _firebaseFirestore.collection(users == Gender.men ? Gender.women.name : Gender.men.name)
      .doc(message.receiverId)
      .collection('matches')
      .doc(message.senderId)
      .update({'chatOpened': true});

      await _firebaseFirestore.collection(users == Gender.men ? Gender.women.name : Gender.men.name)
      .doc(message.receiverId)
      .collection('matches')
      .doc(message.senderId)
      .collection('chats')
      .doc('chat')
      .set({'timestamp': FieldValue.serverTimestamp()});
      //.set({'timestamp': message.timestamp})
      await sendMessage(message,users);

      //adding messages collection
      // await _firebaseFirestore.collection(user.gender)
      // .doc(userId)
      // .collection('matches')
      // .doc(matchedUserId)
      // .collection('chat')
      // .doc('chat')
      // .collection('messages')
      // ;

      await _firebaseFirestore.collection(users.name)
      .doc(message.senderId)
      .collection('matches')
      .doc(message.receiverId)
      .update(
        {'chatOpened': true}
        ).then((value) {
         print('here');
        }
         );

        await _firebaseFirestore.collection(users == Gender.men ? Gender.women.name : Gender.men.name)
      .doc(message.receiverId)
      .collection('matches')
      .doc(message.senderId)
      .update({'chatOpened': true});
      
    }on FirebaseException catch (e){
    throw Exception(e.message);

  }on Exception catch (e) {
      throw Exception(e);
    }
  }
  
  @override
  Future<User> getUserbyId(String userId, String? gender) async {
    try {
  return await _firebaseFirestore
      .collection(gender??'men')
      .doc(userId)
      .get()
      .then((doc) async { 
        if(doc.exists){
          return User.fromSnapshoot(doc);
        }
        return await _firebaseFirestore.collection('women').doc(userId).get().then((value) => User.fromSnapshoot(value));

        }
        );

}on FirebaseException catch (e){
  throw Exception(e.message);
}
 on Exception catch (e) {
  // TODO
  throw Exception(e);
}
        
  }
  
  @override
  Future<Gender> isUserAlreadyRegistered(String userId) async {
   try {
  return await _firebaseFirestore
   .collection('women')
   .doc(userId)
   .get()
   .then((user)async {
     if(user.exists){
      return Gender.women;
     }
     return await  _firebaseFirestore.collection('men').doc(userId).get().then((value) => value.exists? Gender.men : Gender.nonExist);


     });

}on FirebaseException catch (e){
  throw Exception(e.message);
}
 on Exception catch (e) {
  // TODO
  throw Exception(e);
}
  }

//************************ Messages repository *******************************

  @override
  Stream<List<Message>> getChats(String userId, Gender users, String matchedUserId){
    try {
  return _firebaseFirestore.collection(users.name)
    .doc(userId)
    .collection('matches')
    .doc(matchedUserId)
    .collection('chats')
    .doc('chat')
    .collection('messages')
    .orderBy('timestamp', descending: true)
    .limit(15)
    .snapshots()
    .map((snap) => snap.docs
    .map((doc) => Message.fromSnapshoot(doc))
    .toList());
}on FirebaseException catch (e){
  throw Exception(e.message);
}
 on Exception catch (e) {
  // TODO
  throw Exception(e);
}
      
  }

  @override
  Stream<List<Message>> getLastMessage(String userId, Gender users, String matchedUserId)  {
    try {
  var result =   _firebaseFirestore
  .collection(users.name)
  .doc(userId)
  .collection('matches')
    .doc(matchedUserId)
    .collection('chats')
    .doc('chat')
    
  .collection('messages')
  .orderBy('timestamp', descending: true)
  .limit(1)
  .snapshots()
  .map((msg) => 
    msg.docs.map(
    (e) => Message.fromSnapshoot(e)).toList()
   );
  
  return result;
 

  // .then((message) async => 
  //   await _firebaseFirestore.collection('messages')
  //   .doc(message.docs.first.id).get()
  //   .then((msg) => Message.fromSnapshoot(msg))
  
  // );
}on FirebaseException catch (e){
  throw Exception(e.message);
}
 on Exception catch (e) {
  // TODO
  throw Exception(e);
}

  }
  
  @override
  Future<void> sendMessage(Message message, Gender users) async{
    try {
  var docRef =await _firebaseFirestore.collection(users.name)
      .doc(message.senderId)
      .collection('matches')
      .doc(message.receiverId)
      .collection('chats')
      .doc('chat')
      .collection('messages')
      .add(message.toMap());
  
  await _firebaseFirestore.collection(users == Gender.men ? Gender.women.name : Gender.men.name)
      .doc(message.receiverId)
      .collection('matches')
      .doc(message.senderId)
      .collection('chats')
      .doc('chat')
      .collection('messages')
      .doc(docRef.id)
      .set(message.toMap());
 
 await _firebaseFirestore.collection(users.name)
      .doc(message.senderId)
      .collection('matches')
      .doc(message.receiverId)
      .update({
        'timestamp': FieldValue.serverTimestamp()
      });
 await _firebaseFirestore.collection(users == Gender.men ? Gender.women.name : Gender.men.name)
      .doc(message.receiverId)
      .collection('matches')
      .doc(message.senderId)
      .update({
        'timestamp': FieldValue.serverTimestamp()
      });
      
      

} on FirebaseException catch (e){
  throw Exception(e.message);
}
 on Exception catch (e) {
  // TODO
  throw Exception(e);
}
    
  }

  //**************** UserPreference Repository ****************** */

  @override
  Stream<UserPreference> getUserPreference(String userId, Gender users) {
    try {
  return  _firebaseFirestore
      .collection(users.name)
      .doc(userId)
      .collection('userpreference')
      .doc('preference')
      .snapshots()
      .map((snap) => UserPreference.fromSnapshoot(snap));
}on FirebaseException catch (e){
  throw Exception(e.message);
}
 on Exception catch (e) {
  // TODO
  throw Exception(e);
}
  }
  
  @override
  Future<void> updateUserPreference(UserPreference userPreference, Gender users) async{
    try {
  await _firebaseFirestore.collection(users.name)
    .doc(userPreference.userId)
    .collection('userpreference')
    .doc('preference')
    .set(userPreference.toMap());
}on FirebaseException catch (e){
  throw Exception(e.message);
}
 on Exception catch (e) {
  // TODO
  throw Exception(e);
}

}
  
  @override
  Future<List<User>> getUsersBasedonNearBy(String userId, Gender users, int max)async {
   
    try {

  Position myLocation = await Geolocator.getCurrentPosition(desiredAccuracy:  LocationAccuracy.low);
  if(myLocation.isMocked){
    return [];
  }
 // int totalNum = users == Gender.men? remoteConfig.howManyADayMen(): remoteConfig.howManyADayWomen();
  var remoteNumbers = remoteConfig.getNumbers();
  int totalNum = users == Gender.men? remoteNumbers['howManyADayMen']: remoteNumbers['howManyADayWomen'];
  int remoteMax = remoteNumbers['maxKmNearBy'];
 
  geohash.MyGeoHash myGeoHash = geohash.MyGeoHash();
  String hash = myGeoHash.geoHashForLocation(geohash.GeoPoint(myLocation.latitude, myLocation.longitude));
  
  
  geohash.GeoPoint center = geohash.GeoPoint(myLocation.latitude, myLocation.longitude);
  //var max = prefes.maximumDistance;
  double radiusInM = remoteMax * 1000;
  // preference.maximumDistance! * 1000;
  List<List<String>> bounds = myGeoHash.geohashQueryBounds(center, radiusInM);
  List<Future> futures = [];
  
  for(List<String> b in bounds){
    var q = _firebaseFirestore.collection(users == Gender.men? Gender.women.name:Gender.men.name)
              .orderBy('geohash')
              .startAt([b[0]])
              .endAt([b[1]]);
  
    futures.add(q.get());
  }

  var viewedProfiles = await _firebaseFirestore.collection(users.name)
    .doc(userId).collection('viewedProfiles').doc('viewed')
    .get().then((value) => value.data());

    //var viewedMatches = viewedProfiles?['matches'];
    List<String> likedMatches = viewedProfiles?['liked'].split(',');
    List<String> passedMatches = viewedProfiles?['passed'].split(',');
    //List<String> viewedMatches = [...likedMatches,...passedMatches];
  
  
  
  var result = await Future.wait(futures).then((snapshots){
    List<User> matchingUsers = [];
    List<User> outSideRad = [];
    for(var snap in snapshots){
      if(snap.docs.length != 0){
        
      
      for(var  doc in snap.docs){
        var userLoc = geohash.GeoPoint(doc['location'].latitude, doc['location'].longitude);
        
        final distanceInKM = myGeoHash.distanceBetween(center, userLoc );
        final distanceInM = distanceInKM * 1000;
        if(distanceInM <= radiusInM){
          matchingUsers.add(User.fromSnapshoot(doc));

        }else{
          outSideRad.add(User.fromSnapshoot(doc));
        }

        
      }
      }
    }
    // if(matchingUsers.length <10){
    //   matchingUsers.addAll(outSideRad.sublist(0,10 - matchingUsers.length));
    //   //return matchingUsers;
    // }
    if(matchingUsers.isEmpty){
      outSideRad.removeWhere((user) => likedMatches.contains(user.id));
      if(outSideRad.length>totalNum){
        return outSideRad.sublist(0,totalNum);
      }
      return outSideRad;
    }
    matchingUsers.removeWhere((user) => likedMatches.contains(user.id));
    if(matchingUsers.length > totalNum){
      return matchingUsers.sublist(0,totalNum);
    }
    return matchingUsers;
  });
  return result;
} on Exception catch (e) {
  // TODO
  throw Exception(e);
}

   

    
  }
  
  @override
  Future<void> addVerifyMeUser(User user, bool onlyVerifyMe, String url) async {
    // TODO: implement addVerifyMeUser
    try{
      await _firebaseFirestore.collection('verify')
        .doc(user.id)
        .set({
          'userId':user.id,
          'gender': user.gender,
          'timestamp': DateTime.now(),
          'onlyVerifyMe': onlyVerifyMe,
          'url': url,
        });

      
    }on Exception catch(e){
      throw Exception(e);
    }
  }
  
//   @override
// Stream<List<User>> getNearByUsers(String userId, Position locationData)  {
//     final Geoflutterfire geo = Geoflutterfire();
    


//     final center = geo.point(latitude: locationData.latitude!, longitude: locationData.longitude!);

//     final collectionReference = _firebaseFirestore.collection(user.gender);

//    return geo.collection(collectionRef: collectionReference)
//                 .within(center: center, radius: 5, field: 'location')
//                 .map((snap) => snap.map(
//                   (doc) => User.fromSnapshoot(doc)
//                   ).toList());
//   }
  
  @override
  Future<List<User>> getUsersBasedonLOmiLogic(String userId, Gender users) {
    
    final preference = _firebaseFirestore.collection(users.name).doc(userId);
    // TODO: implement getUsersBasedonLOmiLogic
    throw UnimplementedError();
  }
  
  @override
  Future<List<User>> getUsersMainLogic(String userId, Gender gender, UserPreference preference, User my) async {
    // TODO: implement getUsersMainLogic
    //try {
    var remoteNumbers = remoteConfig.getNumbers();
    int totalNum = gender == Gender.men? remoteNumbers['howManyADayMen']: remoteNumbers['howManyADayWomen'];

    //int totalNum = gender == Gender.men? remoteConfig.howManyADayMen(): remoteConfig.howManyADayWomen();
    int remoteQueensNumber = remoteNumbers['queensNumber'];
    int remoteGentsNumber = remoteNumbers['gentsNumber'];
    
    List<User> princessOrgents =[];
    List<User> queensOrKings =[];
    List<User> result=[];
      
    var collectionRef = _firebaseFirestore.collection(gender == Gender.men? Gender.women.name: Gender.men.name);
    List<int> randomsForQueens = [];
    List<int> randomsForPrincess = [];
    var viewedQueens = [];
    var viewedPrincess =[];
    var viewedProfiles = await _firebaseFirestore.collection(gender.name)
    .doc(userId).collection('viewedProfiles').doc('viewed')
    .get().then((value) => value.data());

    
    List<String> likedMatches = viewedProfiles?['liked'].split(',');
    List<String> passedMatches = viewedProfiles?['passed'].split(',');
    List<String> viewedMatches = [...likedMatches,...passedMatches];
   

    final int queenCount = await collectionRef.where('adminChoice', isEqualTo: gender == Gender.men?  'queen' : 'king').count().get().then((value) => value.count);
    final int princessCount = await collectionRef.where('adminChoice', isEqualTo: gender == Gender.men? 'princess':'gent' ).count().get().then((value) => value.count);
    final noOfUsers = await _firebaseFirestore.collection(gender == Gender.men? Gender.women.name:Gender.men.name).count().get().then((value) => value.count, onError: (e)=>print('error counting'));
    
//logic for showing queens, kings, princess and gentlemen
 if(remoteNumbers['useMainLogic']){
    viewedQueens = viewedProfiles?[gender == Gender.men? 'queens': 'kings'].split(',').map(int.parse).toList();
    viewedPrincess = viewedProfiles?[gender == Gender.men?'princess':'gents'].split(',').map(int.parse).toList();
    
    //get queens or kings based on gender
    for(int i=1; i<=remoteQueensNumber; i++){
      var random = Random().nextInt(queenCount);
       int howmany =0;
      while(viewedQueens.contains(random)|| randomsForQueens.contains(random)){
        random = Random().nextInt(queenCount);
        if(howmany>queenCount){
          howmany = 0;
          break;
        }
        howmany++;
      }
      if(random == 0){
        random =1;
      }
      randomsForQueens.add(random);
    }
    randomsForQueens.removeWhere((element) => viewedQueens.contains(element));

if(randomsForQueens.isNotEmpty){
    List<User> queensOrKings = await collectionRef
          .where('adminChoice', isEqualTo: gender == Gender.men?'queen':'king' )
          .where(gender == Gender.men? 'queenNumber' : 'kingNumber', whereIn: randomsForQueens)
          .get().then(
           (snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList());
    
    queensOrKings.removeWhere((user) => likedMatches.contains(user.id));
    // List<User> queensOrkings = await _firebaseFirestore
}
 

if(princessCount !=0){
   
    for(int i=1; i<= remoteGentsNumber; i++){
      var random = Random().nextInt(princessCount);
      int howmany = 0;
      while(viewedPrincess.contains(random)|| randomsForPrincess.contains(random)){
        random = Random().nextInt(princessCount);
        if(howmany > princessCount){
          howmany = 0;
          break;
        }
        howmany++;
      }
      if(random == 0){
        random =1;
      }
      randomsForPrincess.add(random);
    }
    randomsForPrincess.removeWhere((element) => viewedPrincess.contains(element));
    if(randomsForPrincess.isNotEmpty){
    princessOrgents = await collectionRef
        .where('adminChoice', isEqualTo: gender == Gender.men? 'princess' : 'gent')
        .where(gender == Gender.women ? 'princessNumber' : 'gentNumber', whereIn: randomsForPrincess)
        .get().then(
          (snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList());
    
      princessOrgents.removeWhere((user) => likedMatches.contains(user.id));
    }

    }
//end if princess count is greater than 0

    // List<User> princessOrgents = await _firebaseFirestore.collection(user.gender)
    var randForscore = Random().nextInt(noOfUsers);
    List<User> scoreUsers = await collectionRef
                              .where('rate', whereIn: [7,8,6])
                              .where('adminchoice', isEqualTo: 'nan')
                              .where('number', isGreaterThanOrEqualTo: randForscore)
                              .limit(totalNum)
                              .get().then((snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList());

    scoreUsers.removeWhere((user) => queensOrKings.contains(user) );
    scoreUsers.removeWhere((user) => princessOrgents.contains(user) );

    scoreUsers.removeWhere((user) => viewedMatches.contains(user.id),);

     result = [...queensOrKings, ...princessOrgents,...scoreUsers];
    if(result.length <totalNum){
       scoreUsers = await collectionRef
                              .where('rate', whereIn: [7,8,6])
                              .where('adminchoice', isEqualTo: 'nan')
                              .where('number', isLessThan: randForscore)
                              .limit(totalNum-result.length+10
                              )
                              .get().then((snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList());

    scoreUsers.removeWhere((user) => queensOrKings.contains(user) );
    scoreUsers.removeWhere((user) => princessOrgents.contains(user) );
    scoreUsers.removeWhere((user) => viewedMatches.contains(user.id),);

    }
    result.addAll(scoreUsers);
    
 }
    //same looking for
    List<User> lookingFors= [];


    if(result.length < totalNum){
      int random =Random().nextInt(10000000);

      lookingFors = await collectionRef
      .where('lookingFor', isEqualTo: my.lookingFor)
      .where('random', isLessThanOrEqualTo: random)
      
      .limit(totalNum-result.length+10)
      .get().then((value) => 
      value.docs.map((doc) => User.fromSnapshoot(doc)).toList()
      );
   
      lookingFors.removeWhere((user) => viewedMatches.contains(user.id));
      result.addAll(lookingFors);
   
    
    if(result.length <totalNum){
     // random = Random().nextInt(count);
      lookingFors = await collectionRef
      .where('lookingFor', isEqualTo: my.lookingFor)
      .where('random', isGreaterThan: random)
   
      .limit(totalNum-result.length+10)
      .get().then((value) => 
      value.docs.map((doc) => User.fromSnapshoot(doc)).toList()
      );
   
      lookingFors.removeWhere((user) => viewedMatches.contains(user.id));
      result.addAll(lookingFors);
      
    }

    


    }
    
    //final noOfUsers = await _firebaseFirestore.collection(gender == Gender.men? Gender.women.name:Gender.men.name).count().get().then((value) => value.count, onError: (e)=>print('error counting'));
    List<User> filler =[];
    if(result.length < totalNum){

    
    List<int> randoms = [];
    List<int> randomsBackUp = [];
    for(int i=0; i< totalNum+5 - result.length; i++){
      randoms.add(Random().nextInt(noOfUsers)); 
    }

    if(randoms.length > 30){
      randoms = randoms.sublist(0,30);
      randomsBackUp = randoms.sublist(30);
    }

    
    List<User> filler = await _firebaseFirestore
      .collection(gender == Gender.men? Gender.women.name:Gender.men.name)
      //.where('gender', isEqualTo: gender.name)
      .where('number', whereIn: randoms)
      .get().then(
        (value) => value.docs.map(
          (doc) => User.fromSnapshoot(doc)).toList()
      );

    if(randomsBackUp.isNotEmpty){
      if(randomsBackUp.length > 30){
        randomsBackUp = randomsBackUp.sublist(0,30);
      }
      List<User> fillerBackUp = await _firebaseFirestore
      .collection(gender == Gender.men? Gender.women.name:Gender.men.name)
      //.where('gender', isEqualTo: gender.name)
      .where('number', whereIn: randomsBackUp)
      .get().then(
        (value) => value.docs.map(
          (doc) => User.fromSnapshoot(doc)).toList()
      );

      filler.addAll(fillerBackUp);

    }

      filler.removeWhere((user) => likedMatches.contains(user.id));
      filler.removeWhere((element) => result.contains(element));


      result.addAll(filler);
    }

    //get users from other countries than ethiopia
    // var diascora = await collectionRef
    //                     .where('countryCode', isNotEqualTo: 'ET' )
    //                     .orderBy('lastseen', descending: true)
    //                     .limit(remoteNumbers['numberOfDiascora']~/2)
    //                     .get()
    //                     .then(
    //                       (snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList() );

    // diascora.removeWhere((element) => likedMatches.contains(element.id));
    // diascora.removeWhere((element) => result.contains(element),);

   

    // if(diascoraRandom.length < remoteNumbers['numberOfDiascora']/2 ){
    //   var diascoraRandom2 = await collectionRef
    //                     .where('diascora', isEqualTo: true )
    //                     .where('number', isGreaterThanOrEqualTo: randForDiascora)
    //                     //.orderBy('number', descending: true)
    //                     .limit(remoteNumbers['numberOfDiascora'])
    //                     .get()
    //                     .then(
    //                       (snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList() );

    //   diascoraRandom2.removeWhere((element) => likedMatches.contains(element.id));
    //   diascoraRandom.addAll(diascoraRandom2);
    // }

    
    //diascoraRandom.removeWhere((element) => diascora.contains(element));
    //result.addAll(diascora);
   // result.addAll(diascoraRandom);
    if(remoteNumbers['useMainLogic']){
    if(queensOrKings.isNotEmpty){
      String oldQueens = viewedProfiles?[gender == Gender.men? 'queens': 'kings'];
      String newQueens = '$oldQueens,${randomsForQueens.join(',')}';
     _firebaseFirestore
        .collection(gender.name)
        .doc(userId)
        .collection('viewedProfiles')
        .doc('viewed')
        .update({
          gender == Gender.men? 'queens': 'kings' : newQueens
        }
        );

    }
    if(princessOrgents.isNotEmpty){
      String oldPrinces = viewedProfiles?[gender == Gender.men? 'princess':'gents'];
      String newPrinces = '$oldPrinces,${randomsForPrincess.join(',')}';
      
     _firebaseFirestore
        .collection(gender.name)
        .doc(userId)
        .collection('viewedProfiles')
        .doc('viewed')
        .update({
          gender == Gender.men? 'princess':'gents' : newPrinces
        }
        );

    }

    }


    if(my.countryCode == 'ET'){
    //get foringn users with random number
    var randForDiascora = Random().nextInt(10000000);
    var diascoraSameLookingFor = await collectionRef
                        .where('diascora', isEqualTo: true )
                        .where('lookingFor', isEqualTo: my.lookingFor)
                        .where('random', isLessThan: randForDiascora)
                        //.orderBy('number', descending: true)
                        .limit(remoteNumbers['numberOfDiascora'])
                        .get()
                        .then(
                          (snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList() );

    diascoraSameLookingFor.removeWhere((element) => viewedMatches.contains(element.id));
    if(diascoraSameLookingFor.length < remoteNumbers['numberOfDiascora']){
      var diascoraSameLookingFor2 = await collectionRef
                        .where('diascora', isEqualTo: true )
                        .where('lookingFor', isEqualTo: my.lookingFor)
                        .where('random', isGreaterThanOrEqualTo: randForDiascora)
                        //.orderBy('number', descending: true)
                        .limit(remoteNumbers['numberOfDiascora'])
                        .get()
                        .then(
                          (snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList() );

            diascoraSameLookingFor2.removeWhere((element) => viewedMatches.contains(element.id));
            diascoraSameLookingFor.addAll(diascoraSameLookingFor2);
      
    }
    if(diascoraSameLookingFor.length < remoteNumbers['numberOfDiascora']){
    randForDiascora = Random().nextInt(10000000);
    var diascoraRandom = await collectionRef
                        .where('diascora', isEqualTo: true )
                        .where('random', isLessThan: randForDiascora)
                        //.orderBy('number', descending: true)
                        .limit(remoteNumbers['numberOfDiascora'])
                        .get()
                        .then(
                          (snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList() );

                        
    diascoraRandom.removeWhere((element) => viewedMatches.contains(element.id));
    diascoraRandom.removeWhere((element) => diascoraSameLookingFor.contains(element));
    diascoraSameLookingFor.addAll(diascoraRandom);

    if(diascoraSameLookingFor.length < remoteNumbers['numberOfDiascora']){
      var diascoraRandom = await collectionRef
                        .where('diascora', isEqualTo: true )
                        .where('random', isGreaterThanOrEqualTo: randForDiascora)
                        //.orderBy('number', descending: true)
                        .limit(remoteNumbers['numberOfDiascora'])
                        .get()
                        .then(
                          (snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList() );

      diascoraRandom.removeWhere((element) => viewedMatches.contains(element.id));
      diascoraRandom.removeWhere((element) => diascoraSameLookingFor.contains(element));
      diascoraSameLookingFor.addAll(diascoraRandom);

    }
    

    }


    result.removeWhere((user) => diascoraSameLookingFor.contains(user));
    if(result.length>totalNum){
      var resultT = result.sublist(0,totalNum);
     // resultT.addAll(diascora);
      diascoraSameLookingFor.addAll(resultT);
      return diascoraSameLookingFor;
    }

    //result.addAll(diascora);
    diascoraSameLookingFor.addAll(result);
    return diascoraSameLookingFor;
    
    }//end of et users with diaspora

    //  } catch (e) {
    //   print(e);
    //   throw(Exception('dailyMatch'));
      
    // }
    if(result.length > totalNum){
      return result.sublist(0,totalNum);
    }else{
      return result;
    }

  }
  


List<String> searchName(String name){
  List<String> result = [];
  String temp = '';
  for(int i = 0; i < name.length; i++){
    temp += name[i];
    result.add(temp);
  }
  return result;
}

Future<void> createDemoUsers(List<User> users) async{
  users.forEach((user) async { 
    await _firebaseFirestore.collection(user.gender).doc().set(user.toMap());
  });
}

  Future<bool> completeOnboarding({required Placemark placeMark, required User user, required bool isMocked})async {
    try {
      
    // if(isMocked){
    //  await _firebaseFirestore.collection(user.gender)
    //   .doc(user.id)
    //   .delete();
    //   return false;
    // }else{
      //creates the user

      await _firebaseFirestore.collection(user.gender)
          .doc(user.id)
          .set(user.toMap());
      
      int number =await _firebaseFirestore.collection(user.gender).count().get().then((value) => value.count);

      await _firebaseFirestore.collection(user.gender)
      .doc(user.id)
      .collection('payment')
      .doc('subscription')
      .set(
        Payment(
          country: placeMark.country ?? '', 
          countryCode: isMocked?'mocked': placeMark.isoCountryCode ?? '', 
          placeMark: placeMark.toJson(), 
          expireDate: 0, 
          paymentType: '', 
          paymentDetails: {}).toMap()
      );
      //add default user preference
      await _firebaseFirestore.collection(user.gender)
      .doc(user.id)
      .collection('userpreference')
      .doc('preference')
      .set(UserPreference(userId: user.id, phoneNumber: user.phoneNumber).toMap());

      await _firebaseFirestore.collection(user.gender)
        .doc(user.id)
        .collection('viewedProfiles')
        .doc('viewed')
        .set({
          'liked':'ulend',
          'passed':'ulend',
          user.gender ==Gender.women.name?'kings':'queens':'0',
          user.gender ==Gender.women.name?'gents':'princess':'0',
          'likedNumbers':'0',
          'passedNumbers':'0'
        });
      //online status
      await _firebaseFirestore.collection(user.gender)
        .doc(user.id)
        .collection('online')
        .doc('status')
        .set({
          'online': true,
          'lastseen': FieldValue.serverTimestamp(),
          'showstatus': true
        }
        );

      //mark  iscompleted to true in the user doc
     await _firebaseFirestore.collection(user.gender)
      .doc(user.id)
      .update({
        'isCompleted': true,
        'number': number,
        'random': Random().nextInt(10000000),
        'rate':0,
        'score':0,
        'adminChoice':'nan',
        'searcName': searchName(user.name),
        'livingIn': '${user.city}, ${user.country}',
        'creationTimestamp': FieldValue.serverTimestamp(),
        'diascora': placeMark.isoCountryCode == 'ET'? false:true,
        'fake': 'unReviewed',
        'version': '2.2.0+35',
        'platform': Platform.isAndroid?'android':Platform.isIOS?'ios':'other'
      });

      return true;

    //}

    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Payment> getUserPayment({required userId, required Gender users}) async {
    try {
      
    return await _firebaseFirestore.collection(users.name)
            .doc(userId)
            .collection('payment')
            .doc('subscription')
            .get()
            .then(
             
              (snap) => Payment.fromSnapshoot(snap));

    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void updatePayment({required String userId, required Gender users, required Map purchaseData, required int subscribtionStatus,required String paymentType, required int expireDate}) async {
    await _firebaseFirestore.collection(users.name)
          .doc(userId)
          .collection('payment')
          .doc('subscription')
          .update({
            'paymentDetails': purchaseData,
            'expireDate': expireDate,
            'subscriptionType': paymentType,
            'subscribtionStatus': subscribtionStatus
          });

    await _firebaseFirestore.collection('payments')
            .add({
              'userId': userId,
              'gender': users.name,
              'paymentDetails': purchaseData,
              'expireDate': expireDate,
              'subscriptionType': paymentType,
              'subscribtionStatus': subscribtionStatus,
              'timestamp': FieldValue.serverTimestamp(),
              'paymentType': 'subscribtion',
              'platform': Platform.isIOS?'ios':'android'
              
            });


  }

  Future<List<Message>> getMoreChats({required String userId, required Gender users, required String matchedUserId, required Timestamp startAfter}) async {
     
    try{
    return await _firebaseFirestore.collection(users.name)
      .doc(userId)
      .collection('matches')
      .doc(matchedUserId)
      .collection('chats')
      .doc('chat')
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .startAfter([startAfter])
      .limit(10)
      .get().then(
        (snap) => snap.docs.map((doc) => 
        Message.fromSnapshoot(doc)).toList(),

        onError: (e) => print('error getting messages: ${e}')
        );
    }catch(e){
        throw Exception(e);
    }
    

  }

  Future<bool> isCompleted(Gender gender, String uid)async {
    return await _firebaseFirestore.collection(gender.name)
      .doc(uid)
      .get()
      .then((value) => value['isCompleted']);

  }

  Future<List<User>> getUsersWithAge(String userId, Gender gender) async{
    var prefes = await _firebaseFirestore.collection(gender.name).doc(userId).collection('userpreference').doc('preference').get().then((value) => UserPreference.fromSnapshoot(value));
    var userList = await _firebaseFirestore.collection(gender == Gender.men?Gender.women.name:gender.name)
          .orderBy('age')
          .where('age', isGreaterThanOrEqualTo: prefes.ageRange![0])
          .where('age', isLessThanOrEqualTo: prefes.ageRange![1])
          .limit(10)
          .get().then((value) => 
                                  value.docs.map((doc) => User.fromSnapshoot(doc)).toList() );

    return userList;
    
  }

 Future<void> deletePhoto({required String imageUrl, required String userId, required Gender users})async {
    try{

    await _firebaseFirestore.collection(users.name).doc(userId).update({'imageUrls': FieldValue.arrayRemove([imageUrl])});

    }catch(e){
      throw Exception(e);
    }
  }

  Future<List<User>> getUsersBasedonPreference(String userId, Gender gender, UserPreference prefes, User my )async {
 
      
    CollectionReference collectionReference =  _firebaseFirestore.collection(gender == Gender.women? Gender.men.name:Gender.women.name);
    var remoteNumbers = remoteConfig.getNumbers();
    int totalNum = gender == Gender.men? remoteNumbers['howManyADayMen']: remoteNumbers['howManyADayWomen'];

    var viewedProfiles = await _firebaseFirestore.collection(gender.name)
    .doc(userId).collection('viewedProfiles').doc('viewed')
    .get().then((value) => value.data());

    List<String> likedMatches = viewedProfiles?['liked'].split(',');
    List<String> passedMatches = viewedProfiles?['passed'].split(',');
    List<String> viewedMatches = [...likedMatches,...passedMatches];

    int count = await collectionReference.count().get().then((value) => value.count);
    int random = Random().nextInt(count);
    int random2 =Random().nextInt(10000000);

    List<int> ageWhereIn = [];

    if(prefes.ageRange![1]-prefes.ageRange![0]<=10 ){
      for(int i = prefes.ageRange![0]; i<=prefes.ageRange![1]; i++){
        ageWhereIn.add(i);
      }

    }else{
      for(int i = prefes.ageRange![0]; i<=prefes.ageRange![0]+10; i++){
        ageWhereIn.add(i);
      }

    }

    Query query = collectionReference
      .where('age', whereIn: ageWhereIn );
         
     // users.removeWhere((user) => viewedProfiles.contains(user.id));
    //only show me from my city
    if(prefes.onlyShowFromMyCity != null && prefes.onlyShowFromMyCity!){
      query = query.where('city', isEqualTo: my.city );
    }
    //only show me from my country
    if(prefes.onlyShowFromMyCountry??false){
      query = query.where('countryCode',isEqualTo: my.countryCode);

    }


    List<User> users =[];

    if(prefes.onlyShowOnlineMatches??false){
      var queryRecent = query
      .where('lookingFor', isEqualTo: my.lookingFor)
      //.where('number', isLessThanOrEqualTo: random)
      .orderBy('lastseen', descending: true );

      users = await queryRecent
        .limit(totalNum)
        .get().then((value) => 
        value.docs.map((doc) => User.fromSnapshoot(doc)).toList()
        );

      users.removeWhere((user) => viewedMatches.contains(user.id));
    }else{
    
    //alogrithm to get user which match both looking for and interests same as the user 
    //change to only looking for if they want christian they will get christian;
     users = await query
      .where('lookingFor', isEqualTo: my.lookingFor)
      .where('number', isLessThanOrEqualTo: random)
      .orderBy('number')
      .limit(totalNum)
      .get().then((value) => 
      value.docs.map((doc) => User.fromSnapshoot(doc)).toList()
      );
   
    users.removeWhere((user) => viewedMatches.contains(user.id));
   
    
    if(users.length <totalNum){
     // random = Random().nextInt(count);
      List<User> users2 = await query
      .where('lookingFor', isEqualTo: my.lookingFor)
      .where('number', isGreaterThan: random)
      .orderBy('number')
      .limit(totalNum-users.length)
      .get().then((value) => 
      value.docs.map((doc) => User.fromSnapshoot(doc)).toList()
      );
      
      users.addAll(users2);
    }
    users.removeWhere((user) => viewedMatches.contains(user.id));
    

     random = Random().nextInt(count);
    //end of new added to check onlly recentlu
   if(users.length < totalNum){

    List<User> users3 = await query
     // .where('lookingFor', isEqualTo: my.lookingFor)
      .where('number', isGreaterThan: random)
      .orderBy('number')
      .limit(totalNum-users.length)
      .get().then((value) => 
      value.docs.map((doc) => User.fromSnapshoot(doc)).toList()
      );
      
      users.addAll(users3);

   }
   users.removeWhere((user) => viewedMatches.contains(user.id));

   if(users.length < totalNum){

    List<User> users3 = await query
     // .where('lookingFor', isEqualTo: my.lookingFor)
      .where('number', isLessThanOrEqualTo: random)
      .orderBy('number')
      .limit(totalNum-users.length)
      .get().then((value) => 
      value.docs.map((doc) => User.fromSnapshoot(doc)).toList()
      );
      
      users.addAll(users3);

   }
   users.removeWhere((user) => viewedMatches.contains(user.id));
  
  }
    
    // List<int> randoms = [];
    // for(int i=0; i< totalNum - users.length; i++){
    //   randoms.add(Random().nextInt(count)); 
    // }


    // List<User> filler = await _firebaseFirestore
    //   .collection(gender == Gender.men? Gender.women.name:Gender.men.name)
    //   .where('number', whereIn: randoms)
    //   .get().then(
    //     (value) => value.docs.map(
    //       (doc) => User.fromSnapshoot(doc)).toList()
    //   );

    //   filler.removeWhere((user) => likedMatches.contains(user.id));
    //   filler.removeWhere((element) => users.contains(element));


    //   users.addAll(filler);
     //}

    //get users from aboard not ethiopian users 
    if(my.countryCode == 'ET' && !prefes.onlyShowFromMyCountry!){
    int rand = Random().nextInt(10000000);
    var diascora = await collectionReference
                        .where('diascora', isEqualTo: true)
                        .where('age', whereIn: ageWhereIn )
                        .where('random',isLessThanOrEqualTo: rand)
                        .limit(remoteNumbers['numberOfDiascora'])
                        .get()
                        .then(
                          (snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList() );

    diascora.removeWhere((element) => viewedMatches.contains(element.id));

    if(users.length>totalNum){
      var usersW = users.sublist(0,totalNum);
      diascora.addAll(usersW);
      return diascora;
    }else{
      //users.addAll(diascora);
      diascora.addAll(users);
      return diascora;
    }

    }

    if(users.length>totalNum){
      return users.sublist(0,totalNum);
    }else{
      return users;
    }
 

  }

  Future<UserPreference> getPreference(String userId, Gender gender)async{
    return await _firebaseFirestore.collection(gender.name).doc(userId).collection('userpreference').doc('preference').get().then((value) => UserPreference.fromSnapshoot(value));

  }

  void updateConsumable({required String userId, required Gender users,required String field, required int value})async {
    await _firebaseFirestore.collection(users.name)
          .doc(userId)
          .collection('payment')
          .doc('subscription')
          .update({
            field: value
          });

    await _firebaseFirestore.collection('payments')
            .add({
              'userId': userId,
              'gender': users.name,
              'timestamp': FieldValue.serverTimestamp(),
              'paymentType': field,
              'value': value
            });

  }

  void seenMessage({required Message message, required Gender gender})async {
    await _firebaseFirestore.collection(gender.name)
      .doc(message.receiverId)
      .collection('matches')
      .doc(message.senderId)
      .collection('chats')
      .doc('chat')
      .collection('messages')
      .doc(message.id)
      .update({
        'seen': message.seen
      });

      await _firebaseFirestore.collection(gender == Gender.women ? Gender.men.name: Gender.women.name)
      .doc(message.senderId)
      .collection('matches')
      .doc(message.receiverId)
      .collection('chats')
      .doc('chat')
      .collection('messages')
      .doc(message.id)
      .update({
        'seen': message.seen
      });
  }

  Future<List<UserMatch>> searchMatchName({required String userId, required Gender gender, required String name})async {
    try {

      return await _firebaseFirestore.collection(gender.name)
            .doc(userId)
            .collection('matches')
            .where('nameSearch',arrayContains: name)
            .get()
            .then((value) => value.docs.map((doc) => UserMatch.fromSnapshoot(doc)).toList() );
      
    }catch(e){
      throw Exception(e);
      
    }
  }

  void unMatch({required String userId, required Gender gender, required UserMatch matchUser}) async{
    try {
      await _firebaseFirestore.collection(gender.name)
        .doc(userId)
        .collection('matches')
        .doc(matchUser.id)
        .delete();

      await _firebaseFirestore.collection(matchUser.gender)
        .doc(matchUser.userId)
        .collection('matches')
        .doc(userId)
        .delete();
      
    } catch (e) {
      
    }

  }

  Stream<List<Boosted>> boostedUsers(Gender gender){
    return  _firebaseFirestore.collection('boosteds')
            .doc(gender == Gender.men? Gender.women.name: Gender.men.name)
            .collection('boosted')
            .snapshots()
            .map((snap) => snap.docs
            .map((doc) => Boosted.fromSnapshoot(doc)).toList());

  }

  Future<void> updateOnlinestatus({required String userId,required Gender gender ,required bool online, bool? showstatus })async{
    try {
      await _firebaseFirestore.collection(gender.name)
        .doc(userId)
        .update({
          'online': online,
          'lastseen': FieldValue.serverTimestamp()
        });
      var update ={
          'online': online,
          'lastseen': FieldValue.serverTimestamp(),
          
      };
      if(showstatus !=null){
        update['showstatus']=showstatus;
      }
      await _firebaseFirestore.collection(gender.name)
        .doc(userId)
        .collection('online')
        .doc('status')
        .update(
          update
        );
        
      
    } catch (e) {
      print(e);
      
    }
  }

  Stream<DocumentSnapshot<Map<String,dynamic>>> onlineStatusChanged({required String userId,required String gender }){
    try {
  
    return _firebaseFirestore.collection(gender)
            .doc(userId)
            .collection('online')
            .doc('status')
            .snapshots();

        
    } catch (e) {
      throw Exception(e);
      
    }
  }

  Future<List<User>?>getOnlineUsers({required String userId, required Gender gender, int? limit=20}) async {
    try {
      // List<String> viewedIds =[];
      // var viewedProfiles = await _firebaseFirestore.collection(gender.name).doc(userId).collection('viewedProfiles').get()
      // .then((snap){
      //   viewedIds = snap.docs.map((e) => e.id).toList();
      //   return snap.docs.map((doc) => {'id': doc.id, 'liked': doc['liked'] });
      // }
      // );

      var viewedProfiles = await _firebaseFirestore.collection(gender.name)
    .doc(userId).collection('viewedProfiles').doc('viewed')
    .get().then((value) => value.data());

    //var viewedMatches = viewedProfiles?['matches'];
    List<String> likedMatches = viewedProfiles?['liked'].split(',');
    List<String> passedMatches = viewedProfiles?['passed'].split(',');
    List<String> viewedMatches = [...likedMatches,...passedMatches];


    List<User> recentUsers = await _firebaseFirestore.collection(gender == Gender.men? Gender.women.name: Gender.men.name)
                      .orderBy('lastseen', descending: true)
                      .limit(limit!)
                      .get()
                      .then((snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList());

   //List<User> backKUp= recentUsers;
   recentUsers.removeWhere((user) => viewedMatches.contains(user.id));
   if(recentUsers.isNotEmpty){
    return recentUsers;
   }
  //  else{
  //   backKUp.removeWhere((user) => likedMatches.contains(user.id));
  //   if(backKUp.isNotEmpty){
  //     return backKUp.first;
  //   }
  //  }
    // int count = await _firebaseFirestore.collection(gender == Gender.men? Gender.women.name: Gender.men.name).count().get().then((value) => value.count);

    // int random = Random().nextInt(count);


      // List<User> users = await _firebaseFirestore.collection(gender == Gender.men? Gender.women.name: Gender.men.name)
      //                 .where('online', isEqualTo: true)
      //                 .where('number', isGreaterThanOrEqualTo: random)
      //                 .limit(limit!)
      //                 .get()
                      
      //                 .then((snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList());
      // var firstUsers = users;
      // users.removeWhere((user) => likedMatches.contains(user.id));
      // List<User> recentUsers =[];
      // List<User> secondUsers =[];
      // if(users.length < limit){
      //  secondUsers = await _firebaseFirestore.collection(gender == Gender.men? Gender.women.name: Gender.men.name)
      //                 .where('online', isEqualTo: true)
      //                 .where('number', isLessThan: random)
      //                 .limit(limit!)
      //                 .get()
                      
      //                 .then((snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList());
      // var secondUsersback = users;
      // secondUsers.removeWhere((user) => likedMatches.contains(user.id));
      // users.addAll(secondUsers);

      // }

      // if(users.length <limit && limit>=10){
      //   recentUsers = await _firebaseFirestore.collection(gender == Gender.men? Gender.women.name: Gender.men.name)
      //                 .orderBy('lastSeen', descending: true)
      //                 .limit(limit)
      //                 .get()
      //                 .then((snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList());

      //   var recentBackup= recentUsers;
      //   recentUsers.removeWhere((user) => likedMatches.contains(user.id));
      //   users.addAll(recentUsers);
      //   if(users.length <10){
      //     //void viewedNotLikedUsers = firstUsers.removeWhere((user) => viewedProfiles.contains({'id': user.id, 'liked':true}) );
      //     users.addAll(firstUsers);
      //     users.addAll(secondUsers);
      //     users.removeWhere((element) => likedMatches.contains(element.id));

      //     if(users.length < 10){
      //       recentBackup.removeWhere((user) => likedMatches.contains(user.id));
      //       users.addAll(recentBackup);
      //       if(users.length<10){
      //         return users;
      //       }else{
      //         return users.sublist(0,10);
      //       }
      //     }else{
      //       return users.sublist(0,10);
      //     }

      //   }else{
      //     return users.sublist(0,10);

      //   }
      // }
      
      return null;
      
      
    } catch (e) {
      throw Exception(e);
      
    }
  }

  reportMatch({required String userId, required Gender gender,required UserMatch reportedUser, required int index, 
              required String reportName, required String description})async {

                try {
                  await _firebaseFirestore.collection('report')
                        
                        .add({
                          'reportName': reportName,
                          'reportIndex': index,
                          'description': description,
                          'reportedBy': {'id': userId,'gender':gender.name},
                          'reportedUser': {'id': reportedUser.id,'gender':reportedUser.gender},
                          'timestamp': FieldValue.serverTimestamp()
                        });

                  // _firebaseFirestore.collection(gender.name)
                  //   .doc(userId)
                  //   .collection('matches')
                  //   .doc(reportedUser.id)
                  //   .delete();

                  unMatch(userId: userId, gender: gender, matchUser: reportedUser);

                  
                } catch (e) {
                  throw Exception(e);
                }
              }

    FutureOr<User?> getRandomMatch({required String userId, required Gender gender}) async {
    try {
      final noOfUsers = await _firebaseFirestore.collection(gender == Gender.men? Gender.women.name:Gender.men.name).count().get().then((value) => value.count, onError: (e)=>print('error counting'));
      //var random = Random().nextInt(noOfUsers);
      final viewed  = await _firebaseFirestore.collection(gender.name).doc(userId).collection('viewedProfiles').doc('viewed').get();
      List<String> viewedMatches = viewed['liked'].split(',');
      var random = Random().nextInt(noOfUsers); 
      //random = 25;
    
      User? user =  await _firebaseFirestore.collection(gender == Gender.men? Gender.women.name: Gender.men.name)
              .where('adminChoice', isEqualTo: 'nan')
              .where('number', isEqualTo:random )
              .limit(1)
              .get().then((snap) { 
                var result =  snap.docs;
                if(result.isNotEmpty){
                  return User.fromSnapshoot(result.first);
                }else{
                  return null;
                }
                 });

    
        //user ??=  await getRandomMatch(userId: userId, gender: gender);
        if(viewedMatches.contains(user?.id)){
          // user=null;
          // user = await getRandomMatch(userId: userId, gender: gender);
          return null;

        }

        
        return user;
      
    } catch (e) {
      throw e;
      
    }

  }

  Future<User?>getQueen({required String userId, required Gender gender}) async{
    try {
        final viewed  = await _firebaseFirestore.collection(gender.name).doc(userId).collection('viewedProfiles').doc('viewed').get();
        var viewedQueens= viewed[gender == Gender.men? 'queens' : 'kings'].split(',').map(int.parse).toList();
   
        final noOfQueens = await _firebaseFirestore.collection(gender == Gender.men? Gender.women.name: Gender.men.name)
          .where('adminChoice', isEqualTo: gender == Gender.men? 'queen' : 'king')
          .count().get().then((value) => value.count, onError: (e)=>print('error counting'));
        var rand = Random().nextInt(noOfQueens);
        int count = 0;
        while(viewedQueens.contains(rand)){
          rand = Random().nextInt(rand);
          count ++;
          if(count >=noOfQueens){
            break;
          }
        }
        var queen = await _firebaseFirestore.collection(gender == Gender.men? Gender.women.name: Gender.men.name)
                .where('adminChoice', isEqualTo: gender == Gender.men? 'queen':'king')
                .where(gender == Gender.men? 'queenNumber': 'kingNumber', isEqualTo: rand)
                .get().then((value) => User.fromSnapshoot(value.docs.first));

       List<String> liked = viewed['matches'].split(',');
       if(liked.contains(queen.id)){
       // queen =await getQueen(userId: userId, gender: gender);
        return null;
      }

      String oldQueens = viewed[gender == Gender.men? 'queens': 'kings'];
      String newQueens = '$oldQueens,$rand';
      await _firebaseFirestore.collection(gender.name).doc(userId).collection('viewedProfiles').doc('viewed')
        .update({
          gender == Gender.men? 'queens': 'kings' : newQueens
        }
        );

      
     

      return queen;

      
    } catch (e) {
      throw e;
      
    }
  }

  Future<User?>getPrincess({required String userId, required Gender gender}) async{
    try {
      final viewed  = await _firebaseFirestore.collection(gender.name).doc(userId).collection('viewedProfiles').doc('viewed').get();
      var viewedPrincess= viewed[gender == Gender.men? 'princess' : 'gents'].split(',').map(int.parse).toList();
   
      final noOfPrince = await _firebaseFirestore.collection(gender == Gender.men? Gender.women.name:Gender.men.name)
      .where('adminChoice', isEqualTo: gender == Gender.men? 'princess': 'gent' )
      .count().get().then((value) => value.count, onError: (e)=>print('error counting'));
      var random = Random().nextInt(noOfPrince);
      //String field = gender == Gender.men?'gentNumber': 'princessNumber';
      int count = 0;
        while(viewedPrincess.contains(random)){
          random = Random().nextInt(random);
          count ++;
          if(count >=noOfPrince){
            break;
          }
        }

      User? princess= await _firebaseFirestore.collection(gender == Gender.men? Gender.women.name:Gender.men.name)
                      .where('adminChoice', isEqualTo: gender == Gender.men? 'princess':'gent')
                      .where(gender == Gender.men?'princessNumber' : 'gentNumber', isEqualTo: random)
                      .get()
                      .then((value){
                        if(value.docs.isEmpty){
                          return null;
                        }
                        return User.fromSnapshoot(value.docs.first);
                    });
      //if(princess == null){
       // princess ??= await getPrincess(userId: userId, gender: gender);
       
      if(princess != null){
         List<String> liked = viewed['matches'].split(',');
      if(liked.contains(princess?.id)){
       // princess =await getQueen(userId: userId, gender: gender);
       return null;
      }

      String oldPrince = viewed[gender == Gender.men? 'queens': 'kings'];
      String newPrince = '$oldPrince,$random';
      await _firebaseFirestore.collection(gender.name).doc(userId).collection('viewedProfiles').doc('viewed')
        .update({
          gender == Gender.men? 'princess': 'gents' : newPrince
        }
        );
      }

     

      return princess;

    } catch (e) {
      throw e;
      
    }
  }

  Future<User?> findMeOnHabeshaWe({required String id, required Gender gender}) async {
    try {
      return await _firebaseFirestore.collection(gender == Gender.men? Gender.women.name: Gender.men.name)
                        .where('id', isEqualTo: id)
                        .get()
                        .then((value) {
                          if(value.docs.isNotEmpty){
                            return User.fromSnapshoot(value.docs.first);
                          }
                          else{
                            return null;
                          }
                        });
      
    } catch (e) {
      throw e;
      
    }
  }

  Future<void> addToQueensKings(User user) async{
    var userMap = user.toMap();
    final count = await _firebaseFirestore.collection(user.gender == Gender.men.name? 'kings':'queens').count().get().then((value) => value.count);
    userMap[user.gender == Gender.men.name?'kingNumber': 'queenNumber'] = count+1;
    await _firebaseFirestore.collection(user.gender)
              .doc(user.id)
              .update({
                'adminChoice': user.gender == Gender.men.name? 'king':'queen',
                user.gender == Gender.men.name?'kingNumber': 'queenNumber': count+1
              });
              
    await _firebaseFirestore.collection(user.gender == Gender.men.name? 'kings':'queens').doc(user.id).set(userMap);

  }

  Future<void> addPrincessOrGent(User user) async{
   // var userMap = user.toMap();
    final count = await _firebaseFirestore.collection(user.gender)
      .where('adminChoice', isEqualTo: user.gender==Gender.men.name?'gent':'princess')
     .count().get().then((value) => value.count);
    //userMap[user.gender == Gender.men.name?'gentNumber': 'princessNumber'] = count+1;
    await _firebaseFirestore.collection(user.gender)
              .doc(user.id)
              .update({
                'adminChoice': user.gender == Gender.men.name? 'gent':'princess',
                user.gender == Gender.men.name?'gentNumber': 'princessNumber': count+1
              });

  }

  void deleteMessage({required Message message, required bool deletealso, required Gender gender}) async{
    try {

      await _firebaseFirestore.collection(gender.name)
        .doc(message.senderId)
        .collection('matches')
        .doc(message.receiverId)
        .collection('chats')
        .doc('chat')
        .collection('messages')
        .doc(message.id)
        .delete();

      if(deletealso){
        await _firebaseFirestore.collection(gender == Gender.men?Gender.women.name: Gender.men.name)
        .doc(message.receiverId)
        .collection('matches')
        .doc(message.senderId)
        .collection('chats')
        .doc('chat')
        .collection('messages')
        .doc(message.id)
        .delete();
      }


      
    } catch (e) {
      throw Exception(e);
      
    }
  }

  void editMessage({required Message message, required Gender gender,required String newMessage}) async {
    try {
      await _firebaseFirestore.collection(gender.name)
            .doc(message.senderId)
            .collection('matches')
            .doc(message.receiverId)
            .collection('chats')
            .doc('chat')
            .collection('messages')
            .doc(message.id)
            .update({
              'message': newMessage
            });

      await _firebaseFirestore.collection(gender == Gender.men?Gender.women.name: Gender.men.name)
            .doc(message.receiverId)
            .collection('matches')
            .doc(message.senderId)
            .collection('chats')
            .doc('chat')
            .collection('messages')
            .doc(message.id)
            .update({
              'message': newMessage
            });
      
    } catch (e) {
      
    }
  }

  Future<void> deleteAccount({required String userId, required Gender gender,required String reason, String? email, String? displayName})async {
    try {
      await _firebaseFirestore.collection(gender.name).doc(userId).delete();
      await _firebaseFirestore.collection('deleted').add({
        'timestamp': FieldValue.serverTimestamp(),
        'gender': gender.name,
        'userId': userId,
        'reason': reason,
        'email': email,
        'displayName': displayName
      });

      
    } catch (e) {
      print(e);
    }
  }

  Future<void> boostMe(User user, int after) async {
    try {
      await _firebaseFirestore.collection('boosteds')
        .doc(user.gender)
        .collection('boosted')
        .doc(user.id)
        .set(
          {
            
            'timestamp': FieldValue.serverTimestamp(),
            'user': user.toMap()
          }
        );
      await _firebaseFirestore.collection(user.gender).doc(user.id).collection('payment').doc('subscription').update({'boostedTime': DateTime.now()});

      Future.delayed(Duration(minutes: after), ()async{
        await _firebaseFirestore.collection('boosteds')
          .doc(user.gender)
          .collection('boosted')
          .doc(user.id)
          .delete();

      await _firebaseFirestore.collection(user.gender).doc(user.id).collection('payment').doc('subscription').update({'boostedTime': null});
      });
      
    } catch (e) {
      throw(Exception(e));
      
    }
  }

  Future<List<Like>> loadMoreLikes({required String userId, required Gender gender, required Timestamp startAfter}) async{
    try {
      List<Like> likes = await _firebaseFirestore.collection(gender.name)
                            .doc(userId)
                            .collection('likes')
                            .orderBy('timestamp',descending: true)
                            .startAfter([startAfter])
                            .limit(10)
                            .get().then((snap) => 
                              snap.docs.map((doc) => Like.fromSnapshoot(doc)).toList()
                            );
        
      return likes;
      
    } catch (e) {
      throw Exception(e);
      
    }
  }

  loadMoreMatches({required String userId, required Gender gender, required Timestamp startAfter}) async{
    try {
      List<UserMatch> matches = await _firebaseFirestore.collection(gender.name)
                            .doc(userId)
                            .collection('matches')
                            .where('chatOpened', isEqualTo: false)
                            .orderBy('timestamp',descending: true)
                            .startAfter([startAfter])
                            .limit(10)
                            .get().then((snap) => 
                              snap.docs.map((doc) => UserMatch.fromSnapshoot(doc)).toList()
                            );
        
      return matches;
      
    } catch (e) {
      throw Exception(e);
      
    }
  }

  void updateLastTime({required String userId, required Gender gender}) async{
  
      await _firebaseFirestore.collection(gender.name).doc(userId).collection('userpreference').doc('preference')
              
              .update({
                'lastTime': FieldValue.serverTimestamp()
              });
      
    
  }

  void removeBoost({required String gender, required String userId}) async {
    try {
          await _firebaseFirestore.collection('boosteds').doc(gender).collection('boosted').doc(userId).delete();
          await _firebaseFirestore.collection(gender).doc(userId).collection('payment').doc('subscription').update({'boostedTime': null});

      
    } catch (e) {
      
    }
  }

  Stream<List<UserMatch>> getactiveMatches(String userId, Gender users) {
    try {
  return _firebaseFirestore.collection(users.name)
  .doc(userId)
  .collection('matches')
  .where('chatOpened', isEqualTo: true)
  .orderBy('timestamp', descending: true)
  .limit(10)
  .snapshots()
  .map((snap) => snap.docs
  .map((match) => UserMatch.fromSnapshoot(match)).toList());
}on FirebaseException catch (e){
  print(e.message);
  throw Exception(e.message);

}
 on Exception catch (e) {
  // TODO

  throw Exception(e);
}
  }

  void updateLocation({required String userId,required Gender gender, required List<double> newLocation, required String hash})async {
    try {
      await _firebaseFirestore.collection(gender.name)
              .doc(userId)
              .update({
                'location': GeoPoint(newLocation[0],newLocation[1]),
                'geohash': hash

              });
      
    } catch (e) {
      
    }
  }

  Future<List<UserMatch>> loadMoreActiveMatches({required String userId, required Gender gender, required Timestamp startAfter})async {
    try {
      var matches = await  _firebaseFirestore.collection(gender.name)
                    .doc(userId)
                    .collection('matches')
                    .where('chatOpened', isEqualTo: true)
                    .orderBy('timestamp', descending: true)
                    .startAfter([startAfter])
                    .limit(10)
                    .get()
                    .then((snap) => snap.docs.map(
                      (doc) => UserMatch.fromSnapshoot(doc)).toList());

      return matches;
      
    } catch (e) {
      
      throw Exception(e);
    }

  }

  Future<int> getLikesCount({required String userId, required Gender gender})async {
    return await _firebaseFirestore.collection(gender.name).doc(userId).collection('likes').count().get().then((value) => value.count);
  }

  Future<int> getMatchesCount({required String userId, required Gender gender}) {
    return _firebaseFirestore.collection(gender.name).doc(userId).collection('matches').where('chatOpened', isEqualTo: false).count().get().then((value) => value.count);

  }

  void changeMatchImage({required String userId,required Map<String,dynamic> match, required Gender userGender, required String from, List<dynamic>? newImages}) async{
    if(from =='deleted'){
      await _firebaseFirestore.collection(userGender.name)
      .doc(userId)
      .collection('matches')
      .doc(match['id'])
      .update({
       
        'imageUrls': [],
        'name': 'DeletedAccount'
        
      });

    }else{
     newImages ??= (await getUserbyId(match['id'], match['gender'])).imageUrls;
    if(!listEquals(newImages, match['imageUrls'])){

    await _firebaseFirestore.collection(userGender.name)
      .doc(userId)
      .collection(from)
      .doc(match['id'])
      .update({
        from == 'matches'?
        'imageUrls': 'user.imageUrls': newImages
        
      });

    }
    }
  }

  void checkForChanges({required User user}) {
    var now  = DateTime.now();
    var birth = DateTime.parse(user.birthday!);
    final age = DateTime.now().difference(birth).inDays ~/365;
    if(age > user.age){
      _firebaseFirestore.collection(user.gender).doc(user.id).update({'age':age});
    }
  }

  void checkUserExist({required String userId, required Gender userGender, required Map<String, dynamic> match, required String from, required List newImages}) async{
    try{
    bool exist = await _firebaseFirestore.collection(match['gender']).doc(match['userId']).get().then((value) => value.exists);
    if(!exist){
      changeMatchImage(userId: userId, match: match, userGender: userGender, from: 'deleted', newImages: newImages);

    }

    }catch(e){

    }
  }

   Stream<List<UserMatch>> getNewMatchesBack(String userId, Gender users)  {
    try {
  return _firebaseFirestore.collection(users.name)
  .doc(userId)
  .collection('matches')
  .where('chatOpened', isEqualTo: false)
  .orderBy('timestamp', descending: true)
  .limit(1)
  .snapshots()
  .map((snap) => snap.docs
  .map((match) => UserMatch.fromSnapshoot(match)).toList());
}on FirebaseException catch (e){
  print(e.message);
  throw Exception(e.message);

}
 on Exception catch (e) {
  // TODO

  throw Exception(e);
}
    
  }

  Stream<List<Like>> getLikedMeUsersBack(String userId, Gender users) {
   try {
  return _firebaseFirestore.collection(users.name)
   .doc(userId)
   .collection('likes')
   .orderBy('timestamp', descending: true)
   .limit(1)
   .snapshots()
   .map((snap) => 
    snap.docs
    .map((user) => Like.fromSnapshoot(user)).toList()
   );
}on FirebaseException catch (e){
  throw Exception(e.message);
}
 on Exception catch (e) {
  // TODO
  throw Exception(e);
}
  }

  Stream<List<UserMatch>> getactiveMatchesBack(String userId, Gender users) {
    try {
  return _firebaseFirestore.collection(users.name)
  .doc(userId)
  .collection('matches')
  .where('chatOpened', isEqualTo: true)
  .orderBy('timestamp', descending: true)
  .limit(1)
  .snapshots()
  .map((snap) => snap.docs
  .map((match) => UserMatch.fromSnapshoot(match)).toList());
}on FirebaseException catch (e){
  print(e.message);
  throw Exception(e.message);

}
 on Exception catch (e) {
  // TODO

  throw Exception(e);
}
  }


  Future<void> updateViewedFiresbase(String id, String gender)async{
    // String gender = Gender.values[SharedPrefes.getGender()!].name;
    // String id = SharedPrefes.getUserId()!;

    var viewed = await _firebaseFirestore.collection(gender).doc(id).collection('viewedProfiles').doc('viewed').get();
    String liked = viewed['liked'];

    await _firebaseFirestore
        .collection(gender)
        .doc(id)
        .collection('viewedProfiles')
        .doc('viewed')
        .update({
          'liked': '$liked${SharedPrefes.getLikedIds()}'
        }
        );

    String likedNumbers = viewed['likedNumbers'];
    await _firebaseFirestore
        .collection(gender)
        .doc(id)
        .collection('viewedProfiles')
        .doc('viewed')
        .update({
          'likedNumbers': '$likedNumbers${SharedPrefes.getLikedNums()}'
        }
        );


   // var viewedPassed = await _firebaseFirestore.collection(user.gender).doc(user.id).collection('viewedProfiles').doc('viewed').get();
    String passed = viewed['passed'];
    String locp=SharedPrefes.getPassedIds()??'';
    String newPassed = '$passed$locp';
    await _firebaseFirestore
        .collection(gender)
        .doc(id)
        .collection('viewedProfiles')
        .doc('viewed')
        .update({
          'passed': newPassed
        });

    String passedNumbers = viewed['passedNumbers'];
    String locnp=SharedPrefes.getPassedNums()??'';
    String newPassedNums = '$passedNumbers$locnp';
    await _firebaseFirestore
        .collection(gender)
        .doc(id)
        .collection('viewedProfiles')
        .doc('viewed')
        .update({
          'passedNumbers': newPassedNums
        });

    SharedPrefes.setLikedIds('');
    SharedPrefes.setLikedNums('');
    SharedPrefes.setPassedIds('');
    SharedPrefes.setPassedNums('');


  }

  Future<List<String>> getViewed(String userId, Gender gender)async{
    var viewedProfiles = await _firebaseFirestore.collection(gender.name)
    .doc(userId).collection('viewedProfiles').doc('viewed')
    .get().then((value) => value.data());

    List<String> likedMatches = viewedProfiles?['liked'].split(',');
    List<String> passedMatches = viewedProfiles?['passed'].split(',');
    List<String> viewedMatches = [...likedMatches,...passedMatches];

    return viewedMatches;
  }

  Stream<Payment> paymentSubscription(String uid, Gender gender) {
    return _firebaseFirestore.collection(gender.name)
        .doc(uid)
        .collection('payment')
        .doc('subscription')
        .snapshots()
        .map((payment) => Payment.fromSnapshoot(payment));
        
  }

  Future<String> getTelebirrImage()async{
    var telebirr = await _firebaseFirestore.collection('configs').doc('telebirr').get();
    return telebirr['paymentUrl'];
  }
  
}



