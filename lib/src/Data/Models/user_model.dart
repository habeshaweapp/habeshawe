import 'package:equatable/equatable.dart';

import 'model.dart';

class UserModel extends Equatable{
  String name;
  String age;
  String image;
  List<String> likes;

  UserModel({required this.name, required this.age, required this.image, required this.likes});


  factory UserModel.fromJson(Map<String, dynamic> parsedJson){
    return UserModel(
      name: parsedJson['name'], 
      age: parsedJson['age'], 
      image: parsedJson['img'], 
      likes: parsedJson['likes']);

  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [name, age, image, likes];






 

}