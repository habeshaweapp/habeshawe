import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:location/location.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Models/user_model.dart';
import 'package:lomi/src/Data/Repository/Authentication/auth_repository.dart';
import 'package:lomi/src/Data/Repository/Database/ad_repository.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/dataApi/explore_json.dart';

import '../../Data/Models/likes_model.dart';
import '../../Data/Models/model.dart';
import '../../Data/Models/userpreference_model.dart';
import '../AdBloc/ad_bloc.dart';
import '../AuthenticationBloc/bloc/auth_bloc.dart';

part 'swipebloc_event.dart';
part 'swipebloc_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> with HydratedMixin   {
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  final AdBloc _adBloc;
  StreamSubscription? _authSubscription;
  StreamSubscription? _adSubscription;
  SwipeBloc({
    required DatabaseRepository databaseRepository,
    required AuthBloc authBloc,
    required AdBloc adBloc
  }) :
  _databaseRepository = databaseRepository,
  _authBloc = authBloc,
  _adBloc = adBloc,
   super(const SwipeState()) 
  {
    on<LoadUsers>(_loadusers);

    on<SwipeLeftEvent>(_swipedLeft);

    on<SwipeRightEvent>(_swipedRight);
    on<UpdateHome>(_onUpdateHome);
    on<SwipeEnded>(_onSwipeEnded);
    on<BoostedLoaded>(_onBoostedLoaded);

    // _authSubscription = _authBloc.stream.listen((state) {
    //   if(state.user != null && state.accountType != Gender.nonExist){
    //   add(LoadUsers(userId: state.user!.uid, users: state.accountType!));
    //   }
    //  });

    add(LoadUsers(userId: _authBloc. state.user!.uid, users: _authBloc. state.accountType! ));

    _databaseRepository.boostedUsers(_authBloc.state.accountType!).listen((boosted) {
      add(BoostedLoaded(users: boosted));
     });

    
  }

  void _loadusers(LoadUsers event, Emitter<SwipeState> emit) async {
    
    try {
    emit(state.copyWith(swipeStatus: SwipeStatus.loading));
     List<User> users;
     var prefes = await _databaseRepository.getPreference(event.userId, event.users);

    if(prefes.discoverBy == 0){
      users = await _databaseRepository.getUsersMainLogic(event.userId, event.users, prefes);
    }
    if(prefes.discoverBy == 1){
      users = await _databaseRepository.getUsersBasedonPreference(event.userId, event.users, prefes);
    }else{

     users = await _databaseRepository.getUsersBasedonNearBy(event.userId, event.users == Gender.men? Gender.women : event.users );
    }
    //_databaseRepository.getNearByUsers(event.userId,_locationData).listen((users) {
      //var ads = [];
    var last = const User(id: 'last', name: 'last', age: 0, gender: 'last', imageUrls: [], interests: []);
     // users.add(last);

    //emit(SwipeLoaded(users:users.length>3? users.sublist(0,3): users ));

       // emit(SwipeLoaded(users: users ));
        emit(state.copyWith(swipeStatus: SwipeStatus.loaded, users: users ));

  
    
  // add(UpdateHome(users: users));
     
   }on Exception catch (e) {
    print(e.toString());
     
   }
   
    

  }

  void _onUpdateHome(UpdateHome event, Emitter<SwipeState> emit)  {
      
      if(event.users != null){
      //emit(SwipeLoaded(users: event.users!));
      emit(state.copyWith(swipeStatus: SwipeStatus.loaded, users: event.users ));
      }
  }

  void _swipedLeft(SwipeLeftEvent event, Emitter<SwipeState> emit) async{

    try {
  if(state.swipeStatus == SwipeStatus.loaded){
    //final state = this.state as SwipeLoaded;
    List<User> users = List.from(state.users)..remove(event.passedUser);

     // emit(SwipeLoaded(users: users));
      await _databaseRepository.userPassed(event.user, event.passedUser);
  
  }
} on Exception catch (e) {
  // TODO
  print(e.toString());
}
    // try {
    //   final users = event.users.sublist(1);
    //   //emit( SwipeLoaded(users: users) );

    // } catch (_) {}

  }

  void _swipedRight(SwipeRightEvent event, Emitter<SwipeState> emit) async{
    
    try {
      if(state.swipeStatus == SwipeStatus.loaded){
    
      //final state = this.state as SwipeLoaded;
      List<User> users = List.from(state.users)..remove(event.user);
  
     // emit(SwipeLoaded(users: users));
    
   final result = await _databaseRepository.userLike(event.user, event.matchUser,event.superLike);
  
  }
} on Exception catch (e) {
  // TODO
  print(e.toString());
}
    
    //emit(SwipeError());
    // var users = event.users.sublist(1);
    // try {
    //   emit(SwipeLoaded(users: users));

    // } catch (_) {}
    
  }

  @override
  Future<void> close() async{
    _authSubscription?.cancel();
    super.close();
  }
  
  @override
  SwipeState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    return SwipeState.fromJson(json);
  }
  
  @override
  Map<String, dynamic>? toJson(SwipeState state) {
    // TODO: implement toJson
    return state.toJson();
 
  }

  

  FutureOr<void> _onSwipeEnded(SwipeEnded event, Emitter<SwipeState> emit) {
   // emit(SwipeCompleted(completedTime: event.completedTime));
    emit(state.copyWith(completedTime: event.completedTime, swipeStatus: SwipeStatus.completed));
  }

  FutureOr<void> _onBoostedLoaded(BoostedLoaded event, Emitter<SwipeState> emit) {
    emit(state.copyWith(boostedUsers: event.users));
  }
}
