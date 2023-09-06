import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_geo_hash/geohash.dart' as geohash;
import 'package:geocoding_platform_interface/src/models/placemark.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

import 'package:lomi/src/Data/Models/chat_model.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Models/message_model.dart';
import 'package:lomi/src/Data/Models/user.dart';
import 'package:lomi/src/Data/Models/userpreference_model.dart';
import 'package:lomi/src/Data/Repository/Storage/storage_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/likes_model.dart';
import '../../Models/model.dart';
import '../../Models/payment_model.dart';
import 'base_database_repository.dart';

class DatabaseRepository extends BaseDatabaseRepository{
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Stream<User> getUser(String userId) {
    try {
      return _firebaseFirestore.collection(Gender.men.name)
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
  Future<void> updateUserPictures(User user, String imageName) async{
    try {
  
    String downloadURL = await StorageRepository().getDownloadURL(user,imageName);

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
  Stream<List<User>> getUsers(String userId, String gender) {
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
  return _firebaseFirestore.collection(userId).snapshots()
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
  Future<bool> userLike(User user, User matchUser) async {
    try {

    var result = await _firebaseFirestore.collection(user.gender)
    .doc(user.id)
    .collection('likes')
    .doc(matchUser.id).get();

    if(!result.exists){

    
   await _firebaseFirestore
    .collection(user.gender)
    .doc(user.id)
    .collection('likes')
    .doc(matchUser.id)
    //.add(likedUser.toMap()..addAll({'userId' : likedUser.id}));
    .set(
      {
        'userId': user.id,
        'timestamp': FieldValue.serverTimestamp(),
        'user': matchUser.toMap()
      }
      //user.toMap()


      // Like(userId: user.id, name: user.name, age: user.age, imageUrls: user.imageUrls, timestamp: FieldValue.serverTimestamp()).toMap()
      // {
      //   'likedby' : _firebaseFirestore.collection(user.gender).doc(userId),
      //   'timestamp' : FieldValue.serverTimestamp(),   
      // }
     // (await getUserbyId(userId)).toMap()
    );

    //var res = result;
    await _firebaseFirestore
        .collection(user.gender)
        .doc(user.id)
        .collection('viewedProfiles')
        .doc(matchUser.id)
        .set({'liked' : true});


    return false;
    }

    if(result.exists){
      await _firebaseFirestore
      .collection(user.gender)
      .doc(user.id)
      .collection('matches')
      .doc(matchUser.id)
      .set(
        {
      'timestamp' : FieldValue.serverTimestamp(),
      'userId': matchUser.id,
      'name': matchUser.name,
      'imageUrls': matchUser.imageUrls,
      'verified': matchUser.verified,
      'chatOpened': false,
      'nameSearch': searchName(matchUser.name),
    }
    );
       // UserMatch(userId: userId, matchedUser: likedUser, chat:'notOpened').toMap());

      await _firebaseFirestore
      .collection(user.gender)
      .doc(matchUser.id)
      .collection('matches')
      .doc(user.id)
      .set(
        {
          'timestamp' : FieldValue.serverTimestamp(),
          'userId': matchUser.id,
          'name': matchUser.name,
          'imageUrls': matchUser.imageUrls,
          'verified': matchUser.verified,
          'chatOpened': false,
          'nameSearch': searchName(matchUser.name),
        }
        );
        
      

      await _firebaseFirestore
        .collection(user.gender)
        .doc(user.id)
        .collection('likes')
        .doc(matchUser.id)
        .delete();

      return true;

      
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
    
   // await _firebaseFirestore.collection(user.gender).doc(userId).collection('passed').doc(passedUser.id).set(passedUser.toMap());

    await _firebaseFirestore
        .collection(user.gender)
        .doc(user.id)
        .collection('viewedProfiles')
        .doc(passedUser.id)
        .set({'liked' : false});
    final result = await _firebaseFirestore.collection(user.gender)
        .doc(user.id)
        .collection('likes')
        .doc(passedUser.id)
        .get();

    if(result.exists){
      await _firebaseFirestore.collection(user.gender)
            .doc(user.id)
            .collection('likes')
            .doc(passedUser.id)
            .delete();

    }

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
  .orderBy('timestamp', descending: true)
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

}on FirebaseException catch (e){
  throw Exception(e.message);

} on Exception catch (e) {
  // TODO
  throw Exception(e);
}
  }
  
  @override
  Future<void> likeLikedMeUser(String userId,Gender users, User likedMeUser) async {
    try {
      await _firebaseFirestore
    .collection(users.name)
    .doc(userId)
    .collection('matches')
    .doc(likedMeUser.id)
    .set(likedMeUser.toMap());

    await _firebaseFirestore.collection(users.name)
    .doc(userId)
    .collection('likes')
    .doc(likedMeUser.id)
    .delete();
      
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
      await _firebaseFirestore.collection(users.name)
      .doc(message.senderId)
      .collection('matches')
      .doc(message.receiverId)
      .update(
        {'chatOpened': true}
        ).then((value) {
         print('here');
        }
         )
      
      ;

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
      
    }on FirebaseException catch (e){
    throw Exception(e.message);

  }on Exception catch (e) {
      throw Exception(e);
    }
  }
  
  @override
  Future<User> getUserbyId(String userId) async {
    try {
  return await _firebaseFirestore
      .collection('men')
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
  await _firebaseFirestore.collection(users.name)
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
      .add(message.toMap());
 
//  await _firebaseFirestore.collection(user.gender)
//       .doc(message.senderId)
//       .collection('matches')
//       .doc(message.receiverId)
//       .update({
//         'timestamp': FieldValue.serverTimestamp()
//       });
//  await _firebaseFirestore.collection(user.gender)
//       .doc(message.receiverId)
//       .collection('matches')
//       .doc(message.senderId)
//       .update({
//         'timestamp': FieldValue.serverTimestamp()
//       });
      
      

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
  Future<List<User>> getUsersBasedonPreference(String userId, Gender users)async {
   
    // final permission = await Geolocator.requestPermission();
    // Position myLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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

    try {
  final preference = await _firebaseFirestore.collection(users.name)
  .doc(userId).collection('userpreference').doc('preference')
  .get().then((snap) => UserPreference.fromSnapshoot(snap));
  final prefes = await SharedPreferences.getInstance();
  //.snapshots().map((snap) => UserPreference.fromSnapshoot(snap));
  Position myLocation = await Geolocator.getCurrentPosition(desiredAccuracy:  LocationAccuracy.low);
  prefes.setDouble('latitude', myLocation.latitude);
  prefes.setDouble('longitude', myLocation.longitude);
  //final myLocation = await _firebaseFirestore.collection(user.gender).doc(userId).get().then((value) => value.data()!['location']);
  geohash.MyGeoHash myGeoHash = geohash.MyGeoHash();
  String hash = myGeoHash.geoHashForLocation(geohash.GeoPoint(myLocation.latitude, myLocation.longitude));
  
  // _firebaseFirestore.collection(user.gender).get().then(
  //   (value) => value.docs.(doc) => doc)
  
  
  geohash.GeoPoint center = geohash.GeoPoint(myLocation.latitude, myLocation.longitude);
  double radiusInM = preference.maximumDistance! * 1000;
  List<List<String>> bounds = myGeoHash.geohashQueryBounds(center, radiusInM);
  List<Future> futures = [];
  
  for(List<String> b in bounds){
    var q = _firebaseFirestore.collection(users.name)
              .orderBy('geohash')
              .startAt([b[0]])
              .endAt([b[1]]);
  
    futures.add(q.get());
  }
  
  
  
  var result = await Future.wait(futures).then((snapshots){
    List<User> matchingUsers = [];
    
    
    for(var snap in snapshots){
      if(snap.docs.length != 0){
        
      
      for(var  doc in snap.docs){
        var userLoc = geohash.GeoPoint(doc['location'].latitude, doc['location'].longitude);
        
        final distanceInKM = myGeoHash.distanceBetween(center, userLoc );
        final distanceInM = distanceInKM * 1000;
        if(distanceInM <= radiusInM){
          matchingUsers.add(User.fromSnapshoot(doc));

        }

        
      }
      }
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
  Future<void> addVerifyMeUser(User user, String type, String url) async {
    // TODO: implement addVerifyMeUser
    try{
      await _firebaseFirestore.collection('verify')
        .doc(user.id)
        .set({
          'timestamp': DateTime.now(),
          'type': type,
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
  Future<List<User>> getUsersMainLogic(User user, UserPreference preference) async {
    // TODO: implement getUsersMainLogic
    List<int> randomsForQueens = [];
    List<int> randomsForPrincess = [];
    List<String> viewedProfiles = await _firebaseFirestore.collection(user.gender)
    .doc(user.id).collection('viewedProfiles')
    .get().then((snap) => snap.docs.map((e) => e.id,).toList() );

    //get queens or kings based on gender
    for(int i=1; i<=10; i++){
      randomsForQueens.add(Random().nextInt(10));
    }

    List<User> queensOrKings = await _firebaseFirestore
        .collection(user.gender == 'women'? 'queens' : 'kings')
        .where(user.gender == 'women'? 'queenNumber' : 'kingNumber', whereIn: randomsForQueens)
        .get().then(
          (snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList());
    
    queensOrKings.removeWhere((user) => viewedProfiles.contains(user.id));
    // List<User> queensOrkings = await _firebaseFirestore
    //     .collection(user.gender == 'female'? 'queens' : 'kings')
    //     // .orderBy('number')
    //     // .startAfter(['values'])
    //     // .limit(5)
    //     .get()
    //     .then((snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList());
    
    //List<String> queensNotViewed = queens.toSet().difference(viewedProfiles.toSet()).toList();
    //queensOrkings.removeWhere((user) => viewedProfiles.contains(user.id));

    // List<User> temp=[];
    // for(int i=0; i<5; i++){
    //   int random = Random().nextInt(queensOrkings.length);
    //   temp.add(queensOrkings[random]);
    // }
    // queensOrkings = temp;
  //  if(user.gender == 'women'){


    //get princess or gents 

    for(int i=1; i<=10; i++){
      randomsForPrincess.add(Random().nextInt(10));
    }

    List<User> princessOrgents = await _firebaseFirestore
        .collection(user.gender == 'women'? 'mens' : 'womens')
        .where('verified', isEqualTo: user.gender == 'women'? 'princess' : 'gents')
        .where(user.gender == 'women'? 'princessNumber' : 'gentsNumber', whereIn: randomsForPrincess)
        .get().then(
          (snap) => snap.docs.map((doc) => User.fromSnapshoot(doc)).toList());
    
    princessOrgents.removeWhere((user) => viewedProfiles.contains(user.id));

    // List<User> princessOrgents = await _firebaseFirestore.collection(user.gender)
    //   .where('gender', isEqualTo: user.gender )
    //   .where('verified', isEqualTo: user.gender == 'female'? 'princess' : 'gentlemens')
    //   .orderBy('createdAt')
    //   .limit(4)
    //   .get()
    //   .then(
    //     (querySnap) => querySnap.docs.map((doc) => User.fromSnapshoot(doc)).toList());
   // }

   // if(user.gender == 'man'){
    // List<User> princess = await _firebaseFirestore.collection(user.gender)
    //   .where('gender', isEqualTo: 'women')
    //   .where('verified', isEqualTo: 'gentlemen')
    //   .orderBy('createdAt')
    //   .limit(4)
    //   .get()
    //   .then(
    //     (querySnap) => querySnap.docs.map((doc) => User.fromSnapshoot(doc)).toList());
    // princess.remov
    //}
    final noOfUsers = await _firebaseFirestore.collection(user.gender).count().get().then((value) => value.count, onError: (e)=>print('error counting'));
    List<int> randoms = [];
    for(int i=0; i< 10; i++){
      randoms.add(Random().nextInt(noOfUsers)); 
    }

    List<User> filler = await _firebaseFirestore
      .collection(user.gender)
      .where('gender', isEqualTo: user.gender)
      .where('number', whereIn: randoms)
      .get().then(
        (value) => value.docs.map(
          (doc) => User.fromSnapshoot(doc)).toList()
      );

    // List<User> filler = await _firebaseFirestore
    //   .collection(user.gender)
    //   .where('gender', isEqualTo: user.gender)
    //   .where('score', isGreaterThanOrEqualTo: 1)
    //   .limit(5)
    //   .get()
    //   .then(
    //     (querySnap) => 
    //     querySnap.docs.map((doc) => 
    //     User.fromSnapshoot(doc)).toList()
    //     );
    List<User> result = [...queensOrKings, ...princessOrgents,...filler];

     return result;
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

      await _firebaseFirestore.collection(user.gender)
      .doc(user.id)
      .collection('payment')
      .doc('subscription')
      .set(
        Payment(
          country: placeMark.country ?? '', 
          countryCode: placeMark.isoCountryCode ?? '', 
          placeMark: placeMark.toJson(), 
          expireDate: '', 
          paymentType: '', 
          paymentDetails: {}).toMap()
      );
      //add default user preference
      await _firebaseFirestore.collection(user.gender)
      .doc(user.id)
      .collection('userpreference')
      .doc('preference')
      .set(UserPreference(userId: user.id).toMap());

      //mark  iscompleted to true in the user doc
     await _firebaseFirestore.collection(user.gender)
      .doc(user.id)
      .update({
        'isCompleted': true
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
            .then((snap) => Payment.fromSnapshoot(snap));

    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void updatePayment({required String userId, required Gender users, required Map purchaseData, required paymentType}) async {
    await _firebaseFirestore.collection(users.name)
          .doc(userId)
          .collection('payment')
          .doc('subscription')
          .update({
            'paymentDetails': purchaseData,
            'expiredate': purchaseData['expiredate'],
            'paymentType': paymentType
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
      .limit(5)
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



}



