import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lomi/src/Data/Models/user_model.dart';
import 'package:lomi/src/Data/Repository/Authentication/auth_repository.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/dataApi/explore_json.dart';

import '../../Data/Models/model.dart';
import '../AuthenticationBloc/bloc/auth_bloc.dart';

part 'swipebloc_event.dart';
part 'swipebloc_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _authSubscription;
  SwipeBloc({
    required DatabaseRepository databaseRepository,
    required AuthBloc authBloc,
  }) :
  _databaseRepository = databaseRepository,
  _authBloc = authBloc,
   super(SwipeLoading()) 
  {
    on<LoadUsers>(_loadusers);

    on<SwipeLeftEvent>(_swipedLeft);

    on<SwipeRightEvent>(_swipedRight);
    on<UpdateHome>(_onUpdateHome);

    _authSubscription = _authBloc.stream.listen((state) {
      if(state.user!.uid != null){
      add(LoadUsers(userId: state.user!.uid));

      }
     });

    
  }

  void _loadusers(LoadUsers event, Emitter<SwipeState> emit)  {
   // final users = explore_json;
    _databaseRepository.getUsers(event.userId , 'Male').listen((users) {
      add(UpdateHome(users: users));
    },);
   // emit(SwipeLoaded(users: event.users));
    

  }

  void _onUpdateHome(UpdateHome event, Emitter<SwipeState> emit)  {
      
      if(event.users != null){
      emit(SwipeLoaded(users: event.users!));
      }
  }

  void _swipedLeft(SwipeLeftEvent event, Emitter<SwipeState> emit) async{

    if(state is SwipeLoaded){
      final state = this.state as SwipeLoaded;
      List<User> users = List.from(state.users)..remove(event.user);

      if (users.isNotEmpty){
        emit(SwipeLoaded(users: users));
      }else{
        emit(SwipeError());
      }

      await _databaseRepository.userPassed(event.userId, event.user);

    }
    // try {
    //   final users = event.users.sublist(1);
    //   //emit( SwipeLoaded(users: users) );

    // } catch (_) {}

  }

  void _swipedRight(SwipeRightEvent event, Emitter<SwipeState> emit) async{
    
    if(state is SwipeLoaded){
      
      final state = this.state as SwipeLoaded;
      List<User> users = List.from(state.users)..remove(event.user);

      if (users.isNotEmpty){
        emit(SwipeLoaded(users: users));
      }else{
        emit(SwipeError());
      }

     final result = await _databaseRepository.userLike(event.userId, event.user);
     if(result){
      emit(ItsaMatch(user: event.user));
      List<User> users = List.from(state.users)..remove(event.user);

     if (users.isNotEmpty){
        emit(SwipeLoaded(users: users));
      }else{
        emit(SwipeError());
      }
     }

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

  
}
