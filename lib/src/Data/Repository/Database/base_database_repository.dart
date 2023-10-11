import 'package:location/location.dart';
import 'package:lomi/src/Data/Models/model.dart';

import '../../Models/enums.dart';
import '../../Models/likes_model.dart';
import '../../Models/userpreference_model.dart';

abstract class BaseDatabaseRepository{
  Stream<User> getUser(String userId, Gender users);
  Stream<List<User>> getUsers(String userId, Gender users);
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> updateUserPictures(User user, String imageName);
  Future<bool> userLike(User user, User matchUser, bool superLike);
  Future<void> userPassed(User userId, User passedUser);
  Future<User> getUserbyId(String userId);

 


  Stream<List<UserMatch>> getMatches(String userId,Gender users);
  Stream<List<Like>> getLikedMeUsers(String userId, Gender users);
  Future<void> deleteLikedMeUser(String userId,Gender users, String likedMeUserId);
  Future<void> likeLikedMeUser(User user, Like likedMeUser, bool isSuperLike);
  Future<void> openChat(Message message,Gender users);
  Future<Gender> isUserAlreadyRegistered(String userId);

//**************** Messages Repository ****************** */
  
  Stream<List<Message>> getChats(String userId,Gender users, String matchedUserId);
  Stream<List<Message>> getLastMessage(String userId, Gender users, String matchedUserId);

  Future<void> sendMessage(Message message,Gender users);

  //**************** UserPreference Repository ****************** */
  Stream<UserPreference> getUserPreference(String userId, Gender users);
  Future<void> updateUserPreference(UserPreference userPreference, Gender users);

  //***************888 main logic getting ussers based on preference ***********8*8***8*//
  Future<List<User>> getUsersBasedonNearBy(String userId, Gender users);
  //Stream<List<User>> getNearByUsers(String userId, Position locationData);
  Future<List<User>> getUsersBasedonLOmiLogic(String userId,Gender users);


  //add user on verification list
  Future<void> addVerifyMeUser(User user, String type, String url);


  //Habeshawe main logic
  Future<List<User>> getUsersMainLogic(String userId, Gender gender, UserPreference preference);
}