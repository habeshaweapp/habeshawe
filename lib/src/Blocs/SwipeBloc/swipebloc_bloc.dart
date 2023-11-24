import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Models/user_model.dart';
import 'package:lomi/src/Data/Repository/Authentication/auth_repository.dart';
import 'package:lomi/src/Data/Repository/Database/ad_repository.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/dataApi/explore_json.dart';

import '../../Data/Models/boostedModel.dart';
import '../../Data/Models/likes_model.dart';
import '../../Data/Models/model.dart';
import '../../Data/Models/userpreference_model.dart';
import '../../Data/Repository/Notification/notification_service.dart';
import '../AdBloc/ad_bloc.dart';
import '../AuthenticationBloc/bloc/auth_bloc.dart';
import '../PaymentBloc/payment_bloc.dart';

part 'swipebloc_event.dart';
part 'swipebloc_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> with HydratedMixin   {
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  final AdBloc _adBloc;
  final PaymentBloc _paymentBloc;
  StreamSubscription? _authSubscription;
  StreamSubscription? _adSubscription;
  StreamSubscription? _boostedSubscription;
  SwipeBloc({
    required DatabaseRepository databaseRepository,
    required AuthBloc authBloc,
    required AdBloc adBloc,
    required PaymentBloc paymentBloc,
  }) :
  _databaseRepository = databaseRepository,
  _authBloc = authBloc,
  _adBloc = adBloc,
  _paymentBloc = paymentBloc,
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
    on<BoostMe>(_onBoostMe);
    on<CheckLastTime>(_onCheckLastTime);
    on<EmitBoosted>(_onEmitBoosted);
  

    //if(state.completedTime == null && state.users.isEmpty){
      if(_authBloc.state.firstTime!){
      add(LoadUsers(userId: _authBloc.state.user!.uid, users: _authBloc.state.accountType!));
      }else{
        add(CheckLastTime());
      }
      add(LoadUsers(userId: _authBloc.state.user!.uid, users: _authBloc.state.accountType!));
   // }
    // print(state);
    // print(state);

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
     event.prefes??=  await _databaseRepository.getPreference(event.userId, event.users);
     event.user??= await _databaseRepository.getUserbyId(event.userId, event.users.name);
     //event.p

    //  users = await _databaseRepository.getUsersBasedonPreference(event.userId, event.users, event.prefes!, event.user!);
    //     emit(state.copyWith(swipeStatus: SwipeStatus.completed));
     

    if(event.prefes!.discoverBy == 0){
      //try {
        users = await _databaseRepository.getUsersMainLogic(event.userId, event.users, event.prefes!)
        .timeout(const Duration(minutes: 30), onTimeout: () { 
        if(state.loadAttempt >=3){
          emit(state.copyWith(swipeStatus: SwipeStatus.completed)); throw Exception('something went wrong come back another time!');
        }
        
        add(LoadUsers(userId: event.userId, users: event.users, prefes: event.prefes!,user: event.user));
        emit(state.copyWith(loadAttempt: state.loadAttempt+1));
        throw Exception('took too long retrying...');
        
        },);
        
      // } catch (e) {
      //    print(e);
      //    emit(state.copyWith(swipeStatus: SwipeStatus.error, error: e.toString() ));
      // }
      
    }
    if(event.prefes!.discoverBy == 1){
      users = await _databaseRepository.getUsersBasedonPreference(event.userId, event.users, event.prefes!, event.user!)
      .timeout(const Duration(seconds: 30), onTimeout: () { 
        if(state.loadAttempt >=3){
          emit(state.copyWith(swipeStatus: SwipeStatus.completed)); throw Exception('toolong');
        }
        
        add(LoadUsers(userId: event.userId, users: event.users, prefes: event.prefes!,user: event.user));
        emit(state.copyWith(loadAttempt: state.loadAttempt+1));
        throw Exception('took too long retrying...');
        
        },);
    }
    if(event.prefes!.discoverBy == 2){

     users = await _databaseRepository.getUsersBasedonNearBy(event.userId, event.users,5)
     .timeout(const Duration(seconds: 30), onTimeout: () { 
        if(state.loadAttempt >=3){
          emit(state.copyWith(swipeStatus: SwipeStatus.completed)); throw Exception('toolong');
        }
        
        add(LoadUsers(userId: event.userId, users: event.users, prefes: event.prefes!,user: event.user));
        emit(state.copyWith(loadAttempt: state.loadAttempt+1));
        throw Exception('took too long retrying...');
        
        },);
    }
    if(event.prefes!.discoverBy == 3){
      users = await _databaseRepository.getOnlineUsers(userId: event.userId, gender: event.users)
      .timeout(const Duration(seconds: 30), onTimeout: () { 
        if(state.loadAttempt >=3){
          emit(state.copyWith(swipeStatus: SwipeStatus.completed)); throw Exception('toolong');
        }
        
        add(LoadUsers(userId: event.userId, users: event.users, prefes: event.prefes!,user: event.user));
        emit(state.copyWith(loadAttempt: state.loadAttempt+1));
        throw Exception('took too long retrying...');
        
        },);
    }

 
    emit(state.copyWith(swipeStatus: SwipeStatus.loaded, users: users, loadFor: LoadFor.daily ));

    _databaseRepository.updateLastTime(userId: event.userId, gender: event.users);

  
    
  // add(UpdateHome(users: users));
     
   }on TimeoutException catch (e) {
    print(e.toString());
    emit(state.copyWith(swipeStatus: SwipeStatus.error, error: e.toString()));
     
   }catch(e){
    emit(state.copyWith(swipeStatus: SwipeStatus.error, error: e.toString()));
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
  
      await _databaseRepository.userPassed(event.user, event.passedUser);
      //await _databaseRepository.addToQueensKings(event.passedUser);

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
     // List<User> users = List.from(state.users)..remove(event.user);
  
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
  //  if(state.completedTime != null){
  //   Future.delayed(const Duration(hours: 24), (){ 
      
  //     add(LoadUsers(userId: _authBloc.state.user!.uid , users: _authBloc.state.accountType! )); });
  //  }
    emit(state.copyWith(completedTime: event.completedTime, swipeStatus: SwipeStatus.completed));
  }

  FutureOr<void> _onBoostedLoaded(BoostedLoaded event, Emitter<SwipeState> emit) {
    var boosted = event.users;
      for(var boost in boosted){
        var boostedTime = boost.timestamp.toDate();
        int diff = DateTime.now().difference(boostedTime).inMinutes;
        if(diff >30){
          boosted.remove(boost);
          _databaseRepository.removeBoost(boost: boost);
        }
      }
    var users = boosted.map((boost) => boost.user).toList();

    if(state.users.isEmpty){
      emit(state.copyWith(users: users, swipeStatus: SwipeStatus.loaded, loadFor: LoadFor.boosted, boostedUsers: null));
      NotificationService().showMessageReceivedNotifications(title: 'Matches', body: 'You have match to see!', payload: 'boosted', channelId: 'boosted');
    }else{
    emit(state.copyWith(boostedUsers: users));
    }
  }

  FutureOr<void> _onLoadUserAd(LoadUserAd event, Emitter<SwipeState> emit)async {
    emit(state.copyWith( loadFor: event.loadFor));

    try {
      
    
    if(event.loadFor == LoadFor.adOnline){
      var user = await _databaseRepository.getOnlineUsers(userId: event.userId, gender: event.users,limit:event.limit);

      emit(state.copyWith(users: user, swipeStatus: SwipeStatus.loaded, loadFor: LoadFor.ad) );

    }
    if(event.loadFor == LoadFor.adNearby){
      //emit(state.copyWith(loadFor: event.loadFor));
      var users = await _databaseRepository.getUsersBasedonNearBy(event.userId, event.users,2 );

      emit(state.copyWith(users: users, swipeStatus: SwipeStatus.loaded, loadFor: LoadFor.ad ));

    }else
    if(event.loadFor == LoadFor.adRandom){
     // emit(state.copyWith(loadFor: event.loadFor));
      User? user = await _databaseRepository.getRandomMatch(userId: event.userId, gender: event.users);
      if(user !=null){
      emit(state.copyWith(users: [user], swipeStatus: SwipeStatus.loaded, loadFor: LoadFor.ad ));
      }else{
        emit(state.copyWith(swipeStatus: SwipeStatus.error ));
      }
    }
    else
    if(event.loadFor == LoadFor.adQueen ){
     // emit(state.copyWith(loadFor: event.loadFor));
      User queen = await _databaseRepository.getQueen(userId: event.userId, gender: event.users).timeout(const Duration(seconds: 15));
      emit(state.copyWith(users: [queen], swipeStatus: SwipeStatus.loaded, loadFor: LoadFor.ad ));
      if(_paymentBloc.state.subscribtionStatus != SubscribtionStatus.ET_USER){
        _paymentBloc.add(ConsumeBoost());
      }

    }
    else if(event.loadFor == LoadFor.adPrincess ){
      //emit(state.copyWith(loadFor: event.loadFor));
      User princ = await _databaseRepository.getPrincess(userId: event.userId, gender: event.users).timeout(const Duration(seconds: 15));
      emit(state.copyWith(users: [princ], swipeStatus: SwipeStatus.loaded, loadFor: LoadFor.ad ));
      if(_paymentBloc.state.subscribtionStatus != SubscribtionStatus.ET_USER){
        _paymentBloc.add(ConsumeSuperLike());
      }

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

  

  FutureOr<void> _onBoostMe(BoostMe event, Emitter<SwipeState> emit)async {
    try {
     await _databaseRepository.boostMe(event.user);
     _paymentBloc.add(ConsumeBoost());
      
    } catch (e) {
      
    }
  }

  FutureOr<void> _onCheckLastTime(CheckLastTime event, Emitter<SwipeState> emit) async{
    var prefs= await _databaseRepository.getPreference(_authBloc.state.user!.uid, _authBloc.state.accountType!);
    DateTime last = prefs.lastTime!.toDate();
    int diff =  DateTime.now().difference(last).inMinutes;
    if(diff >= 1440){
      add(LoadUsers(userId: _authBloc.state.user!.uid, users: _authBloc.state.accountType!, prefes: prefs ));
    }
  }

  FutureOr<void> _onEmitBoosted(EmitBoosted event, Emitter<SwipeState> emit) {

      emit(state.copyWith(users: state.boostedUsers, swipeStatus: SwipeStatus.loaded, loadFor: LoadFor.boosted, boostedUsers: null));
      NotificationService().showMessageReceivedNotifications(title: 'Matches', body: 'You have match to see!', payload: 'boosted', channelId: 'boosted');
   
  }
}
