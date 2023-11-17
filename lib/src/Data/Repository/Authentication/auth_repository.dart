import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lomi/src/Data/Repository/Authentication/base_auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

class AuthRepository extends BaseAuthRepository{
  final auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  //final obser = _googleSignIn.obs

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

  Future<void> verifyPhone({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async{
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
       verificationFailed: verificationFailed, 
       codeSent: codeSent, 
       codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
       );
  }

  //PhoneAuthCredential getCredential

  Future<UserCredential> signInWithCredential(AuthCredential credential )async{
    return await _firebaseAuth.signInWithCredential(credential);
  }
  
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    if(await _googleSignIn.isSignedIn()){
    await _googleSignIn.disconnect();
    }
  }
  
  @override
  Future<auth.User?> logInWithTwitter() async {
    try {

    final twitterLogin = TwitterLogin(
      apiKey: 'rLdjOZdpiItrFkbdOhdb0LDHE', 
      apiSecretKey: 'C0U6w9QXhp8EyC35d9VR5je8GndEVPezv0m4uBKo0x1QZLNOif', 
      redirectURI: 'habeshawe://');

    final twitterAuth = await twitterLogin.login();

    final twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: twitterAuth.authToken!, 
      secret: twitterAuth.authTokenSecret!);

    
    final userCredential = await _firebaseAuth.signInWithCredential(twitterAuthCredential);

    return userCredential.user;

    } catch (e) {
      throw Exception(e);
      
    }
  }

  Future<void> deleteAccount()async{
    try {
      await _firebaseAuth.currentUser!.delete();
      
    }on FirebaseAuthException catch (e){
      if(e.code == "requires-recent-login"){
        await _reauthenticateAndDelete();

      }
    }
     catch (e) {
      
    }
  }
  
  Future<void> _reauthenticateAndDelete() async {
  try {
    final providerData = _firebaseAuth.currentUser?.providerData.first;

    if (AppleAuthProvider().providerId == providerData!.providerId) {
      await _firebaseAuth.currentUser!
          .reauthenticateWithProvider(AppleAuthProvider());
    } else if (GoogleAuthProvider().providerId == providerData.providerId) {
      await _firebaseAuth.currentUser!
          .reauthenticateWithProvider(GoogleAuthProvider());
    }

    await _firebaseAuth.currentUser?.delete();
  } catch (e) {
    // Handle exceptions
  }
}
  
  
}