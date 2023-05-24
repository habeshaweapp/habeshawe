import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_geo_hash/geohash.dart' as geohash;
import 'package:geolocator/geolocator.dart';
import 'package:lomi/src/Data/Models/chat_model.dart';
import 'package:lomi/src/Data/Models/message_model.dart';
import 'package:lomi/src/Data/Models/user.dart';
import 'package:lomi/src/Data/Models/userpreference_model.dart';
import 'package:lomi/src/Data/Repository/Storage/storage_repository.dart';

import '../../Models/model.dart';
import 'base_database_repository.dart';

class DatabaseRepository extends BaseDatabaseRepository{
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Stream<User> getUser(String userId) {
    return _firebaseFirestore.collection('users')
    .doc(userId)
    .snapshots()
    .map((snap) => User.fromSnapshoot(snap));
     
  }

  @override
  Future<void> updateUserPictures(User user, String imageName) async{
    String downloadURL = await StorageRepository().getDownloadURL(user,imageName);

    return await _firebaseFirestore.collection('users')
            .doc(user.id)
            .update({'imageUrls': FieldValue.arrayUnion([downloadURL])});
  }
  
  @override
  Future<void> createUser(User user) async {
    //String documentId = 
    await _firebaseFirestore.collection('users').doc(user.id).set(user.toMap());
    // .then((value) {
    //   print("User added, ID: ${value.id}");
    //   return value.id;
    //   });

     
  }
  
  @override
  Future<void> updateUser(User user) async {
    return await _firebaseFirestore.collection('users').doc(user.id)
    .update(user.toMap()).then((value) {print('user updated');});
  }
  
  @override
  Stream<List<User>> getUsers(String userId, String gender) {
    //  Position myLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // geohash.MyGeoHash myGeoHash = geohash.MyGeoHash();
    // String hash = myGeoHash.geoHashForLocation(geohash.GeoPoint(myLocation.latitude, myLocation.longitude));
    // _firebaseFirestore.collection('users').snapshots()
    // .forEach((element) {
    //   element.docs.forEach((doc) {
    //    // updateUser(User.fromSnapshootOld(doc));
    //    _firebaseFirestore.collection('users').doc(doc.id)
    //    .update({'geohash': hash });
    //   });
    // });
   // _firebaseFirestore.collection('users').where('location[0]', whereIn: [99,21] ).where('location[1]', whereIn: [20,12]);
    return _firebaseFirestore.collection('users').where('gender', isNotEqualTo: gender).snapshots()
    .map((snap) => snap.docs
    .map((doc) => User.fromSnapshoot(doc)).toList() );

    
  }
  
  @override
  Future<bool> userLike(String userId, User likedUser) async {
    try {

    var result = await _firebaseFirestore.collection('users')
    .doc(userId)
    .collection('likes')
    .doc(likedUser.id).get();

    if(!result.exists){

    
   await _firebaseFirestore
    .collection('users')
    .doc(likedUser.id)
    .collection('likes')
    .doc(userId)
    //.add(likedUser.toMap()..addAll({'userId' : likedUser.id}));
    .set(
      (await getUserbyId(userId)).toMap()
    );

    //var res = result;
    await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('viewedProfiles')
        .doc(likedUser.id)
        .set({'liked' : true});


    return false;
    }

    if(result.exists){
      await _firebaseFirestore
      .collection('users')
      .doc(userId)
      .collection('matches')
      .doc(likedUser.id)
      .set(UserMatch(userId: userId, matchedUser: likedUser, chat:'notOpened').toMap());

      await _firebaseFirestore
      .collection('users')
      .doc(likedUser.id)
      .collection('matches')
      .doc(userId)
      .set(
        UserMatch(userId: userId, matchedUser: await getUserbyId(userId), chat: 'notOpened').toMap() );
        
      

      await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('likes')
        .doc(likedUser.id)
        .delete();

      return true;

      
    }
    } catch (e) {
      print(e.toString());
    }
    return false;

    
  }
  
  @override
  Future<void> userPassed(String userId, User passedUser) async {
    
    await _firebaseFirestore.collection('users').doc(userId).collection('passed').doc(passedUser.id).set(passedUser.toMap());

    await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('viewedProfiles')
        .doc(passedUser.id)
        .set({'liked' : false});
  }
  
  @override
  Stream<List<UserMatch>> getMatches(String userId)  {
    return _firebaseFirestore.collection('users')
    .doc(userId)
    .collection('matches')
    .snapshots()
    .map((snap) => snap.docs
    .map((match) => UserMatch.fromSnapshoot(match)).toList());
    
  }
  
  @override
  Stream<List<User>> getLikedMeUsers(String userId) {
   return _firebaseFirestore.collection('users')
    .doc(userId)
    .collection('likes')
    .snapshots()
    .map((snap) => 
     snap.docs
     .map((user) => User.fromSnapshootOld(user)).toList()
    );
  }
  
  @override
  Future<void> deleteLikedMeUser(String userId, String likedMeUserId) async {
    await _firebaseFirestore
    .collection('users')
    .doc(userId)
    .collection('likes')
    .doc(likedMeUserId)
    .delete();
  }
  
  @override
  Future<void> likeLikedMeUser(String userId, User likedMeUser) async {
    try {
      await _firebaseFirestore
    .collection('users')
    .doc(userId)
    .collection('matches')
    .doc(likedMeUser.id)
    .set(likedMeUser.toMap());

    await _firebaseFirestore.collection('users')
    .doc(userId)
    .collection('likes')
    .doc(likedMeUser.id)
    .delete();
      
    } catch (e) {
      throw Exception(e);     
    }
    
  }
  
  @override
  Future<void> openChat(Message message) async {
    try {
      await _firebaseFirestore.collection('users')
      .doc(message.senderId)
      .collection('matches')
      .doc(message.receiverId)
      .update(
        {'chat': 'Opened'}
        ).then((value) {
         print('here');
        }
         )
      
      ;

      await _firebaseFirestore.collection('users')
      .doc(message.senderId)
      .collection('matches')
      .doc(message.receiverId)
      .collection('chats')
      .doc('chat')
      .set({'timestamp': DateTime.now()});
      
      //for the other user
      await _firebaseFirestore.collection('users')
      .doc(message.receiverId)
      .collection('matches')
      .doc(message.senderId)
      .update({'chat': 'Opened'});

      await _firebaseFirestore.collection('users')
      .doc(message.receiverId)
      .collection('matches')
      .doc(message.senderId)
      .collection('chats')
      .doc('chat')
      .set({'timestamp': DateTime.now()});
      //.set({'timestamp': message.timestamp})
      await sendMessage(message);

      //adding messages collection
      // await _firebaseFirestore.collection('users')
      // .doc(userId)
      // .collection('matches')
      // .doc(matchedUserId)
      // .collection('chat')
      // .doc('chat')
      // .collection('messages')
      // ;
      
    } catch (e) {
      throw Exception(e);
    }
  }
  
  @override
  Future<User> getUserbyId(String userId) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .get()
        .then((doc) => User.fromSnapshoot(doc));
        
  }
  
  @override
  Future<bool> isUserAlreadyRegistered(String userId) async {
   return await _firebaseFirestore
    .collection('users')
    .doc(userId)
    .get()
    .then((user) => user.exists);
  }

//************************ Messages repository *******************************

  @override
  Stream<List<Message>> getChats(String userId, String matchedUserId){
    return _firebaseFirestore.collection('users')
      .doc(userId)
      .collection('matches')
      .doc(matchedUserId)
      .collection('chats')
      .doc('chat')
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snap) => snap.docs
      .map((doc) => Message.fromSnapshoot(doc))
      .toList());
      
  }

  @override
  Future<Message> getLastMessage(String userId, String matchedUserId) async {
    return await _firebaseFirestore
    .collection('users')
    .doc(userId)
    .collection('chats')
    .doc(matchedUserId)
    .collection('messages')
    .orderBy('time-stamp', descending: true)
    .snapshots()
    .first
    .then((message) async => 
      await _firebaseFirestore.collection('messages')
      .doc(message.docs.first.id).get()
      .then((msg) => Message.fromSnapshoot(msg))

    );

  }
  
  @override
  Future<void> sendMessage(Message message) async{
    await _firebaseFirestore.collection('users')
        .doc(message.senderId)
        .collection('matches')
        .doc(message.receiverId)
        .collection('chats')
        .doc('chat')
        .collection('messages')
        .add(message.toMap());

    await _firebaseFirestore.collection('users')
        .doc(message.receiverId)
        .collection('matches')
        .doc(message.senderId)
        .collection('chats')
        .doc('chat')
        .collection('messages')
        .add(message.toMap());
    
  }

  //**************** UserPreference Repository ****************** */

  @override
  Stream<UserPreference> getUserPreference(String userId) {
    return  _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('userpreference')
        .doc('preference')
        .snapshots()
        .map((snap) => UserPreference.fromSnapshoot(snap));
  }
  
  @override
  Future<void> updateUserPreference(UserPreference userPreference) async{
    await _firebaseFirestore.collection('users')
      .doc(userPreference.userId)
      .collection('userpreference')
      .doc('preference')
      .set(userPreference.toMap());
  }
  
  @override
  Future<User> getUsersBasedonPreference(String userId)async {
    // final permission = await Geolocator.requestPermission();
    // Position myLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // geohash.MyGeoHash myGeoHash = geohash.MyGeoHash();
    // String hash = myGeoHash.geoHashForLocation(geohash.GeoPoint(myLocation.latitude, myLocation.longitude));
    // _firebaseFirestore.collection('users').snapshots()
    // .forEach((element) {
    //   element.docs.forEach((doc) {
    //    // updateUser(User.fromSnapshootOld(doc));
    //    _firebaseFirestore.collection('users').doc(doc.id)
    //    .update({'geohash': hash });
    //   });
    // });

    final preference = await _firebaseFirestore.collection('users')
    .doc(userId).collection('userpreference').doc('preference')
    .get().then((snap) => UserPreference.fromSnapshoot(snap));
    //.snapshots().map((snap) => UserPreference.fromSnapshoot(snap));
    //Position myLocation = await Geolocator.getCurrentPosition();
    final myLocation = await _firebaseFirestore.collection('users').doc(userId).get().then((value) => value.data()!['location']);
    geohash.MyGeoHash myGeoHash = geohash.MyGeoHash();
    String hash = myGeoHash.geoHashForLocation(geohash.GeoPoint(myLocation.latitude, myLocation.longitude));

    // _firebaseFirestore.collection('users').get().then(
    //   (value) => value.docs.(doc) => doc)


    geohash.GeoPoint center = geohash.GeoPoint(myLocation.latitude, myLocation.longitude);
    double radiusInM = preference.maximumDistance! * 1000;
    List<List<String>> bounds = myGeoHash.geohashQueryBounds(center, radiusInM);
    List<Future> futures = [];

    for(List<String> b in bounds){
      var q = _firebaseFirestore.collection('users')
                
                .where('age', isGreaterThan: 12)
                
                .orderBy('age')
  
                .orderBy('geohash')
                .startAt([b[0]])
                .endAt([b[1]])
                ;

      futures.add(q.get());
    }

    await Future.wait(futures).then((snapshots){
      var matchingUsers = [];
      
      
      for(var snap in snapshots){
        for(var  doc in snap.docs){
          matchingUsers.add(User.fromSnapshoot(doc));
        }
      }
      
      return matchingUsers;
    });

     throw Exception('error occured');
    
  }
  
}



