part of 'swipebloc_bloc.dart';

enum SwipeStatus{initial, loading, loaded, completed, itsamatch,error,left,right }
enum LoadFor{daily, ad,adOnline, adNearby, adRandom, adPrincess, adQueen,boosted }

class SwipeState extends Equatable {
  const SwipeState({
    this.swipeStatus = SwipeStatus.initial,
    this.users = const [],
    this.matchedUser,
    this.completedTime,
    this.boostedUsers=const [],
    this.loadFor,
    this.loadAttempt =0,
    this.error,
    this.recentUsers=const []
   
  });

  final SwipeStatus swipeStatus;
  final List<User> users;
  final User? matchedUser;
  final DateTime? completedTime;
  final List<Boosted> boostedUsers;
  final LoadFor? loadFor;
  final int loadAttempt;
  final String? error;
  final List<User> recentUsers;
  
  


  SwipeState copyWith({
    SwipeStatus? swipeStatus,
    List<User>? users,
    User? matchedUser,
    DateTime? completedTime,
    List<Boosted>? boostedUsers,
    LoadFor? loadFor,
    int? loadAttempt,
    String? error,
    List<User>? recentUsers
    
  }){
    return SwipeState(
      swipeStatus: swipeStatus ?? this.swipeStatus,
      users: users?? this.users,
      matchedUser: matchedUser?? this.matchedUser,
      completedTime: completedTime?? this.completedTime,
      boostedUsers: boostedUsers?? this.boostedUsers,
      loadFor: loadFor??this.loadFor,
      loadAttempt: loadAttempt?? this.loadAttempt,
      error: error?? this.error,
      recentUsers: recentUsers?? this.recentUsers
      
    );
  }


  Map<String, dynamic> toJson(){
    List<Map<String, dynamic>> newUser =  [];
    users.forEach((user) {
      newUser.add(user.toJson());
      });

    // List<Map<String, dynamic>> boosted =  [];
    // boostedUsers.forEach((user) {
    //   newUser.add(user.toJson());
    //   });

    
    return {
      'swipeStatus': swipeStatus.index,
      'users': newUser,
      'completedTime': completedTime?.toIso8601String(),
      'matchedUser': matchedUser?.toJson(),
      'boostedUsers': [],
      'loadFor': loadFor?.index,
      
     
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
      //boostedUsers: boosted,
      loadFor: json['loadFor'] == null?null: LoadFor.values[json['loadFor'] as int],      
    );

    }catch(e){
      print(e);
      return SwipeState();
    }
  }

  @override
  List<Object?> get props => [swipeStatus,users,matchedUser,completedTime, loadFor, error,loadAttempt,recentUsers];
  
}
