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
  StreamSubscription? _boostedSubscription;
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
    on<LoadUserAd>(_onLoadUserAd);
    on<AdSwipeEnded>(_onAdSwipeEnded);

    if(state.completedTime == null && state.users.isEmpty){
      add(LoadUsers(userId: _authBloc.state.user!.uid, users: _authBloc.state.accountType!));
    }
    print(state);
    print(state);

    // _authSubscription = _authBloc.stream.listen((state) {
    //   if(state.user != null && state.accountType != Gender.nonExist){
    //   add(LoadUsers(userId: state.user!.uid, users: state.accountType!));
    //   }
    //  });

    //add(LoadUsers(userId: _authBloc. state.user!.uid, users: _authBloc. state.accountType! ));

    _boostedSubscription = _databaseRepository.boostedUsers(_authBloc.state.accountType!).listen((boosted) {
      add(BoostedLoaded(users: boosted));
     },onDone: () {
       
     },);

    
  }

  void _loadusers(LoadUsers event, Emitter<SwipeState> emit) async {
    
    try {
    emit(state.copyWith(swipeStatus: SwipeStatus.loading, loadFor: LoadFor.daily));
     List<User> users =[];
     if(event.prefes ==null) event.prefes = await _databaseRepository.getPreference(event.userId, event.users);
     //event.p

    if(event.prefes!.discoverBy == 0){
      users = await _databaseRepository.getUsersMainLogic(event.userId, event.users, event.prefes!);
    }
    if(event.prefes!.discoverBy == 1){
      users = await _databaseRepository.getUsersBasedonPreference(event.userId, event.users, event.prefes!, event.user!);
    }
    if(event.prefes!.discoverBy == 2){

     users = await _databaseRepository.getUsersBasedonNearBy(event.userId, event.users );
    }
    if(event.prefes!.discoverBy == 3){
      users = await _databaseRepository.getOnlineUsers(userId: event.userId, gender: event.users);
    }

    //_databaseRepository.getNearByUsers(event.userId,_locationData).listen((users) {
      //var ads = [];
    //var last = const User(id: 'last', name: 'last', age: 0, gender: 'last', imageUrls: [], interests: []);
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
    _adSubscription?.cancel();
    _boostedSubscription?.cancel();
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
   if(state.completedTime != null){
    Future.delayed(const Duration(hours: 24), (){ 
      
      add(LoadUsers(userId: _authBloc.state.user!.uid , users: _authBloc.state.accountType! )); });
   }
    emit(state.copyWith(completedTime: event.completedTime, swipeStatus: SwipeStatus.completed));
  }

  FutureOr<void> _onBoostedLoaded(BoostedLoaded event, Emitter<SwipeState> emit) {
    emit(state.copyWith(boostedUsers: event.users));
  }

  FutureOr<void> _onLoadUserAd(LoadUserAd event, Emitter<SwipeState> emit)async {
    //emit(state.copyWith(swipeStatus: SwipeStatus.loading, loadFor: LoadFor.ad));

    try {
      
    
    if(event.loadFor == LoadFor.adOnline){
      var user = await _databaseRepository.getOnlineUsers(userId: event.userId, gender: event.users,limit:event.limit);

      emit(state.copyWith(users: user, swipeStatus: SwipeStatus.loaded, loadFor: LoadFor.ad) );

    }
    if(event.loadFor == LoadFor.adNearby){
      var users = await _databaseRepository.getUsersBasedonNearBy(event.userId, event.users );

      emit(state.copyWith(users: users, swipeStatus: SwipeStatus.loaded, loadFor: LoadFor.ad ));

    }else
    if(event.loadFor == LoadFor.adPrincess){
      User user = await _databaseRepository.getRandomMatch(userId: event.userId, gender: event.users);
      emit(state.copyWith(users: [user], swipeStatus: SwipeStatus.loaded, loadFor: event.loadFor ));
    }
    else
    if(event.loadFor == LoadFor.adQueen ){
      User queen = await _databaseRepository.getQueen(userId: event.userId, gender: event.users).timeout(const Duration(seconds: 15));
      emit(state.copyWith(users: [queen], swipeStatus: SwipeStatus.loaded, loadFor: event.loadFor ));
    }
    else if(event.loadFor == LoadFor.adPrincess ){
      User princ = await _databaseRepository.getPrincess(userId: event.userId, gender: event.users).timeout(const Duration(seconds: 15));
      emit(state.copyWith(users: [princ], swipeStatus: SwipeStatus.loaded, loadFor: event.loadFor ));

    }


    } on TimeoutException catch(e){
      emit(state.copyWith(swipeStatus: SwipeStatus.completed));
    }
    catch (e) {
      print(e);
      
    }

  }

  FutureOr<void> _onAdSwipeEnded(AdSwipeEnded event, Emitter<SwipeState> emit) {
    emit(state.copyWith(swipeStatus: SwipeStatus.completed));
  }
}
