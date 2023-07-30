import 'package:location/location.dart';
import 'package:lomi/src/Data/Models/model.dart';

import '../../Models/likes_model.dart';
import '../../Models/userpreference_model.dart';

abstract class BaseDatabaseRepository{
  Stream<User> getUser(String userId);
  Stream<List<User>> getUsers(String userId, String gender);
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> updateUserPictures(User user, String imageName);
  Future<bool> userLike(User user, User matchUser);
  Future<void> userPassed(String userId, User passedUser);
  Future<User> getUserbyId(String userId);

 


  Stream<List<UserMatch>> getMatches(String userId);
  Stream<List<Like>> getLikedMeUsers(String userId);
  Future<void> deleteLikedMeUser(String userId, String likedMeUserId);
  Future<void> likeLikedMeUser(String userId, User likedMeUser);
  Future<void> openChat(Message message);
  Future<bool> isUserAlreadyRegistered(String userId);

//**************** Messages Repository ****************** */
  
  Stream<List<Message>> getChats(String userId, String matchedUserId);
  Stream<List<Message>> getLastMessage(String userId, String matchedUserId);

  Future<void> sendMessage(Message message);

  //**************** UserPreference Repository ****************** */
  Stream<UserPreference> getUserPreference(String userId);
  Future<void> updateUserPreference(UserPreference userPreference);

  //***************888 main logic getting ussers based on preference ***********8*8***8*//
  Future<List<User>> getUsersBasedonPreference(String userId);
  Stream<List<User>> getNearByUsers(String userId, LocationData locationData);
  Future<List<User>> getUsersBasedonLOmiLogic(String userId);


  //add user on verification list
  Future<void> addVerifyMeUser(User user, String type, String url);


  //Habeshawe main logic
  Future<List<User>> getUsersMainLogic(User user, UserPreference preference);
}