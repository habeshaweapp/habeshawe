import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lomi/src/Data/Repository/Authentication/base_auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository extends BaseAuthRepository{
  final auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({auth.FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
  : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
    _googleSignIn = googleSignIn ?? GoogleSignIn.standard();
  

  @override
  Future<auth.User?> logInWithGoogle() async {
    try {
      late final auth.AuthCredential credential;
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;

      credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final cred =  await _firebaseAuth.signInWithCredential(credential);

      final user = cred.user;
      return user;
    } on auth.FirebaseAuthException catch (e){
      throw 'login with google failure ${e.code}';
    }
     catch (e) { 
      print(e.toString());
      
    }
    
  }

  @override
  // TODO: implement user
  Stream<User?> get user => _firebaseAuth.userChanges();
  
  // @override
  // Future<auth.User?> registerWithPhone(String mobile) {
  //   try {
  //     final user = _firebaseAuth.verifyPhoneNumber(
  //       phoneNumber: mobile,
  //       verificationCompleted: ((phoneAuthCredential) {
  //         //code for signing in
  //         final result = _firebaseAuth.signInWithCredential(phoneAuthCredential);

  //       }
  //       ), 
  //       verificationFailed: ((authExc){
  //         throw authExc;
  //       }), 
  //       codeSent: (codeSent, id){
  //         _verifyCodeSent(codeSent, id);
  //       }, 
  //       codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
  //       );
  //   } catch (e) {
      
  //   }
  // }

  void _verifyCodeSent(String codeSent, int? id, String? optCode){


  }
  
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
  
}