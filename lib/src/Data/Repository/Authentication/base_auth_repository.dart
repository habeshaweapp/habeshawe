import 'package:lomi/src/Data/Models/model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class BaseAuthRepository{
  Stream<auth.User?> get user;
  Future<auth.User?> logInWithGoogle();
 // Future<auth.User?> registerWithPhone(String mobile);
  Future<void> signOut();
}