import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/Data/Repository/Storage/base_storage_repository.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../Models/model.dart';

class StorageRepository extends BaseStorageRepository{
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;


  @override
  Future<String> uploadImage(User user, XFile image) async {
    try {
      return await storage.ref('${user.id}/${image.name}')
      .putFile(File(image.path))
      .then((p0) async {
         return await getDownloadURL(user, image.name);
         }
      //DatabaseRepository().updateUserPictures(user,image.name)
      );
      
      //throw Exception('upload failed');
      
    } catch (
      e
      ) {
        throw Exception(e.toString());
      
    }
  }

  Future<String> uploadVerifyMeImage(User user, XFile image, bool onlyVerifyMe ) async{
    try{
     // DatabaseRepository databaseRepository = DatabaseRepository();
      return await storage.ref('${user.id}/verifyMe/${image.name}')
            .putFile(File(image.path))
            .then((p0) async {
              String url = await storage.ref('${user.id}/verifyMe/${image.name}').getDownloadURL();
              return url;
             } );


    }on Exception catch(e){
      print(e.toString());
      throw Exception(e);
    }
  }
  
  @override
  Future<String> getDownloadURL(User user, String imageName) async {
    String downloadURL = await storage.ref('${user.id}/${imageName}').getDownloadURL();
    
    return downloadURL;
  }

  Future<String> sendMessageImage({required String userId, required Gender gender,required XFile image})async {
    try {
      return await storage.ref('${userId}/messages/${image.name}')
              .putFile(File(image.path))
              .then((p0) async {
                return await storage.ref('${userId}/messages/${image.name}').getDownloadURL();
              });
      
    } catch (e) {
      throw Exception(e);
      
    }

  }
  
}