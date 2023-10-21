part of 'swipebloc_bloc.dart';

enum SwipeStatus{initial, loading, loaded, completed, itsamatch,error }
enum LoadFor{daily, ad,adOnline, adNearby, adRandom, adPrincess, adQueen }

class SwipeState extends Equatable {
  const SwipeState({
    this.swipeStatus = SwipeStatus.initial,
    this.users = const [],
    this.matchedUser,
    this.completedTime,
    this.boostedUsers=const [],
    this.loadFor
    
  });

  final SwipeStatus swipeStatus;
  final List<User> users;
  final User? matchedUser;
  final DateTime? completedTime;
  final List<User> boostedUsers;
  final LoadFor? loadFor;
  


  SwipeState copyWith({
    SwipeStatus? swipeStatus,
    List<User>? users,
    User? matchedUser,
    DateTime? completedTime,
    List<User>? boostedUsers,
    LoadFor? loadFor,
   
  }){
    return SwipeState(
      swipeStatus: swipeStatus ?? this.swipeStatus,
      users: users?? this.users,
      matchedUser: matchedUser?? this.matchedUser,
      completedTime: completedTime?? this.completedTime,
      boostedUsers: boostedUsers?? this.boostedUsers,
      loadFor: loadFor??this.loadFor
      
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
      'boostedUsers': boosted,
      'loadFor': loadFor?.index
     
    };
   
  }

  factory SwipeState.fromJson(Map<String, dynamic> json){
    try{
      
    var usersMap = json['users'] as List;
    var boostedMap = json['boostedUsers'] as List;
    List<User> users = usersMap.map(( user ) => User.fromMap(user)).toList() ;
    List<User> boosted = boostedMap.map((user) => User.fromMap(user )).toList();
    
    return SwipeState(
      swipeStatus: SwipeStatus.values[json['swipeStatus'] as int],
      users: users,
      completedTime: json['completedTime'] == null?null: DateTime.parse(json['completedTime'] as String),
      matchedUser: json['matchedUser'] == null?null: User.fromMap(json['matchedUser'] as Map<String, dynamic>),
      boostedUsers: boosted,
      loadFor: json['loadFor'] == null?null: LoadFor.values[json['loadFor'] as int]
      
    );

    }catch(e){
      print(e);
      return SwipeState();
    }
  }

  @override
  List<Object?> get props => [swipeStatus,users,matchedUser,completedTime, loadFor];
  
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

