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

class SwipeBloc extends Bloc<SwipeEvent, SwipeState>   {
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
   super(SwipeLoading()) 
  {
    on<LoadUsers>(_loadusers);

    on<SwipeLeftEvent>(_swipedLeft);

    on<SwipeRightEvent>(_swipedRight);
    on<UpdateHome>(_onUpdateHome);
    on<SwipeEnded>(_onSwipeEnded);

    // _authSubscription = _authBloc.stream.listen((state) {
    //   if(state.user != null && state.accountType != Gender.nonExist){
    //   add(LoadUsers(userId: state.user!.uid, users: state.accountType!));
    //   }
    //  });

    add(LoadUsers(userId: _authBloc. state.user!.uid, users: _authBloc. state.accountType!));

    
  }

  void _loadusers(LoadUsers event, Emitter<SwipeState> emit) async {
    // Location location = Location();

    // bool _serviceEnabled = await location.serviceEnabled();
    // if(!_serviceEnabled){
    //   _serviceEnabled = await location.requestService();
    // }
    // PermissionStatus _permissionGranted = await location.hasPermission();
    // if(_permissionGranted == PermissionStatus.denied){
    //   _permissionGranted = await location.requestPermission();
    // }

    // LocationData _locationData = await location.getLocation();
   // final users = explore_json;



    try {
  //  emit(SwipeLoading());
  //   _databaseRepository.getUsers(event.userId , 'Male').listen((users) {
  //     add(UpdateHome(users: users));
  //   },);



   //emit(SwipeLoaded(users: event.users));
   //  
  
final users = await _databaseRepository.getUsersBasedonPreference(event.userId, event.users == Gender.men? Gender.women : event.users );
    //_databaseRepository.getNearByUsers(event.userId,_locationData).listen((users) {
      //var ads = [];
      var last = const User(id: 'last', name: 'last', age: 0, gender: 'last', imageUrls: [], interests: []);
      //List<dynamic> usersads = [...users, User(id: id, name: name, age: age, gender: gender, imageUrls: imageUrls, interests: interests)];
      users.add(last);
      // _adBloc.add(LoadNativeAd());
      // _adBloc.add(LoadNativeAd());
      // _adBloc.add(LoadNativeAd());

      // _adBloc.stream.listen((adstate) {
      //   if(adstate is AdLoaded){
      //     ads.add(adstate.nativeAd);
      //   }
        
      // },);
      //var ad = AdRepository().createNativeAd(onAdLoaded: (ad){}, onAdFailedToLoad: (ad,er){});
      
      

     // usersads.insert(1,'ad');
      

      // for(int i = usersads.length - 2; i>=0; i-1){
      //   int j=0;
      //   usersads.insert(i, ads[j]);
      //   j++;
      // }
      
      //add(UpdateHome(users: users));
      emit(SwipeLoaded(users: users));
   // });
    
  // add(UpdateHome(users: users));
     
   }on Exception catch (e) {
    print(e.toString());
     
   }
   
    

  }

  void _onUpdateHome(UpdateHome event, Emitter<SwipeState> emit)  {
      
      if(event.users != null){
      emit(SwipeLoaded(users: event.users!));
      }
  }

  void _swipedLeft(SwipeLeftEvent event, Emitter<SwipeState> emit) async{

    try {
  if(state is SwipeLoaded){
    final state = this.state as SwipeLoaded;
    List<User> users = List.from(state.users)..remove(event.passedUser);
  
    if (users.isNotEmpty){
      emit(SwipeLoaded(users: users));
    }else{
      emit(SwipeError());
    }
  
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
  if(state is SwipeLoaded){
    
    final state = this.state as SwipeLoaded;
    List<User> users = List.from(state.users)..remove(event.user);
  
    if (users.isNotEmpty){
      emit(SwipeLoaded(users: users));
    }else{
      emit(SwipeError());
    }
  
   final result = await _databaseRepository.userLike(event.user, event.matchUser);
  //  if(result){
  //   emit(ItsaMatch(user: event.user));
  //  // List<User> users = List.from(state.users)..remove(event.user);
  
  //  if (users.isNotEmpty){
  //    // emit(SwipeLoaded(users: users));
  //   }else{
  //     emit(SwipeError());
  //   }
  //  }
  
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
  
  // @override
  // SwipeState? fromJson(Map<String, dynamic> json) {
  //   // TODO: implement fromJson
  //   if(json.isEmpty){
  //     return null;
  //   }else{
  //     var u = json['ere'] ;
  //     var users = json['users'] ;
      
  //     return SwipeLoaded.fromJson(users);
  //   }
  // }
  
  // @override
  // Map<String, dynamic>? toJson(SwipeState state) {
  //   // TODO: implement toJson
  //   if(state is SwipeLoaded){
  //     return {
  //       'users' : state.toJson(),
  //       'ere': 'gude',
  //       'mnew': 'mnewww'
  //     };
  //   }else{
  //     return null;
  //   }
  // }

  

  FutureOr<void> _onSwipeEnded(SwipeEnded event, Emitter<SwipeState> emit) {
    emit(SwipeCompleted(completedTime: event.completedTime));
  }
}
