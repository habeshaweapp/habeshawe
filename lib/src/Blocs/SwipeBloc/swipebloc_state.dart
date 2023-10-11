part of 'swipebloc_bloc.dart';

enum SwipeStatus{initial, loading, loaded, completed, itsamatch,error }

class SwipeState extends Equatable {
  const SwipeState({
    this.swipeStatus = SwipeStatus.initial,
    this.users = const [],
    this.matchedUser,
    this.completedTime,
    this.boostedUsers=const []
  });

  final SwipeStatus swipeStatus;
  final List<User> users;
  final User? matchedUser;
  final DateTime? completedTime;
  final List<User> boostedUsers;


  SwipeState copyWith({
    SwipeStatus? swipeStatus,
    List<User>? users,
    User? matchedUser,
    DateTime? completedTime,
    List<User>? boostedUsers
  }){
    return SwipeState(
      swipeStatus: swipeStatus ?? this.swipeStatus,
      users: users?? this.users,
      matchedUser: matchedUser?? this.matchedUser,
      completedTime: completedTime?? this.completedTime,
      boostedUsers: boostedUsers?? this.boostedUsers
    );
  }


  Map<String, dynamic> toJson(){
    List<Map<String, dynamic>> newUser =  [];
    users.forEach((user) {
      newUser.add(user.toJson());
      });

    List<Map<String, dynamic>> boosted =  [];
    boostedUsers.forEach((user) {
      newUser.add(user.toJson());
      });

    
    return {
      'swipeStatus': swipeStatus.index,
      'users': newUser,
      'completedTime': completedTime?.toIso8601String(),
      'matchedUser': matchedUser?.toJson(),
      'boostedUsers': boosted
    };
   
  }

  factory SwipeState.fromJson(Map<String, dynamic> json){
    List<User> users = json['users'].map((user) => User.fromMap(user)).toList();
    List<User> boosted = json['boostedUsers'].map((user) => User.fromMap(user)).toList();
    return SwipeState(
      swipeStatus: json['swipeStatus'],
      users: users,
      completedTime: DateTime.parse(json['completedTime']),
      matchedUser: User.fromMap(json['matchedUser']),
      boostedUsers: boosted
    );
  }


  
  @override
  List<Object?> get props => [swipeStatus,users,matchedUser,completedTime];
}

//class SwipeblocInitial extends SwipeState {}

// class SwipeLoading extends SwipeState{}

// //class SwipeProcessingLeftOrRight extends SwipeState{}

// class SwipeLoaded extends SwipeState{
//   final List<User> users;
//    SwipeLoaded({required this.users});

//    //SwipeLoaded copyWith({})

//   @override
//   List<Object> get props => [users];

//   factory SwipeLoaded.fromJson(List<dynamic> json){
//     List<User> users = json.map((user) => User.fromMap(user)).toList();
//     return SwipeLoaded(users: users);
//   }
//   List<Map<String, dynamic>> toJson(){
//     List<Map<String, dynamic>> newUser =  [];
//     users.forEach((user) {
//       //user.location.toString();
//       newUser.add(user.toJson());
//       });

    
//     return newUser;
   
//   }
// }

// class SwipeError extends SwipeState {}

// class ItsaMatch extends SwipeState{
//   final User user;
//   ItsaMatch({required this.user});

//   @override
//   // TODO: implement props
//   List<Object> get props => [user];
// }

// class SwipeCompleted extends SwipeState{
//   final DateTime completedTime;
  
//   SwipeCompleted({required this.completedTime});
   
//    @override
//   // TODO: implement props
//   List<Object> get props => [completedTime];

//   Map<String,dynamic> toJson(){
//     return {
//       'completedTime': completedTime.toIso8601String(),
//       'stateType': 'SwipeCompleted',
//     };
//   }

//   factory SwipeCompleted.fromJson(Map<String,dynamic> json){
//     return SwipeCompleted(completedTime: DateTime.parse(json['completedTime']));
//   }
// }

