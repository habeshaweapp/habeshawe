part of 'swipebloc_bloc.dart';

abstract class SwipeState extends Equatable {
   SwipeState();
  
  @override
  List<Object> get props => [];
}

//class SwipeblocInitial extends SwipeState {}

class SwipeLoading extends SwipeState{}

//class SwipeProcessingLeftOrRight extends SwipeState{}

class SwipeLoaded extends SwipeState{
  final List<User> users;
   SwipeLoaded({required this.users});

   //SwipeLoaded copyWith({})

  @override
  List<Object> get props => [users];

  factory SwipeLoaded.fromJson(List<dynamic> json){
    List<User> users = json.map((user) => User.fromMap(user)).toList();
    return SwipeLoaded(users: users);
  }
  List<Map<String, dynamic>> toJson(){
    List<Map<String, dynamic>> newUser =  [];
    users.forEach((user) {
      //user.location.toString();
      newUser.add(user.toJson());
      });

    
    return newUser;
   
  }
}

class SwipeError extends SwipeState {}

class ItsaMatch extends SwipeState{
  final User user;
  ItsaMatch({required this.user});

  @override
  // TODO: implement props
  List<Object> get props => [user];
}

class SwipeCompleted extends SwipeState{
  final DateTime completedTime;
  
  SwipeCompleted({required this.completedTime});
   
   @override
  // TODO: implement props
  List<Object> get props => [completedTime];

  Map<String,dynamic> toJson(){
    return {
      'completedTime': completedTime.toIso8601String(),
      'stateType': 'SwipeCompleted',
    };
  }

  factory SwipeCompleted.fromJson(Map<String,dynamic> json){
    return SwipeCompleted(completedTime: DateTime.parse(json['completedTime']));
  }
}

