import 'package:lomi/src/Data/Models/model.dart';

import '../../Models/userpreference_model.dart';

abstract class BaseDatabaseRepository{
  Stream<User> getUser(String userId);
  Stream<List<User>> getUsers(String userId, String gender);
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> updateUserPictures(User user, String imageName);
  Future<bool> userLike(String userId, User likedUser);
  Future<void> userPassed(String userId, User passedUser);
  Future<User> getUserbyId(String userId);


  Stream<List<UserMatch>> getMatches(String userId);
  Stream<List<User>> getLikedMeUsers(String userId);
  Future<void> deleteLikedMeUser(String userId, String likedMeUserId);
  Future<void> likeLikedMeUser(String userId, User likedMeUser);
  Future<void> openChat(Message message);
  Future<bool> isUserAlreadyRegistered(String userId);

//**************** Messages Repository ****************** */
  
  Stream<List<Message>> getChats(String userId, String matchedUserId);
  Future<Message> getLastMessage(String userId, String matchedUserId);

  Future<void> sendMessage(Message message);

  //**************** UserPreference Repository ****************** */
  Stream<UserPreference> getUserPreference(String userId);
  Future<void> updateUserPreference(UserPreference userPreference);
}