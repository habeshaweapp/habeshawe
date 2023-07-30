import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';

import '../../Data/Models/likes_model.dart';
import '../../Data/Models/model.dart';

part 'match_event.dart';
part 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _authSubscription;
  MatchBloc({
    required DatabaseRepository databaseRepository,
    required AuthBloc authBloc,
  }) : 
  _databaseRepository = databaseRepository,
  _authBloc = authBloc,
  super(MatchLoading()) {
    on<LoadMatchs>(_onLoadMatchs);
    on<LikeLikedMeUser>(_onLikeLikedMeUser);
    on<OpenChat>(_onOpenChat);
    on<DeleteLikedMeUser>(_onDeleteLikedMeUser);

    on<UpdateMatches>(_onUpdateMatches);
   // on<UpdateLikes>(_onUpdateLikes);

    _authSubscription = _authBloc.stream.listen((state) { 
      if(state.user!.uid != null){
        add(LoadMatchs(userId: state.user!.uid));       
      }
    });
  }

  void _onLoadMatchs(LoadMatchs event, Emitter<MatchState> emit) {
    try{

    _databaseRepository.getMatches(event.userId).listen((matches) {

      _databaseRepository.getLikedMeUsers(event.userId).listen((likes) {
        
        add(UpdateMatches(matchedUsers: matches, likedMeUsers: likes));
        
      });
    });

    }on Exception catch(e){
      print(e);
    }
    // final likes = _databaseRepository.getLikedMeUsers(event.userId);

    // add(UpdateMatches(matchedUsers: matches., likedMeUsers: likes))

    //  _databaseRepository.getMatches(event.userId).listen((users) {
    //   add(UpdateMatches(users: users));
    //  });

    //  _databaseRepository.getLikedMeUsers(event.userId).listen((users) { 
    //   add(UpdateLikes(users: users));
    //  });

  }

  void _onUpdateMatches(UpdateMatches event, Emitter<MatchState> emit){
    try {
      emit(MatchLoaded(matchedUsers: event.matchedUsers!, likedMeUsers: event.likedMeUsers!));
      
    }on Exception catch (e) {
      print(e.toString());
    }
  }

  // void _onUpdateLikes(UpdateLikes event, Emitter<MatchState> emit){
  //   try {
  //     emit(LikeLoaded(likedMeUsers: event.users!));
      
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  void _onLikeLikedMeUser(LikeLikedMeUser event, Emitter<MatchState> emit) async{
   try {
  await  _databaseRepository.likeLikedMeUser(event.userId, event.likedMeUser);
} on Exception catch (e) {
  // TODO
  print(e.toString());
}

  }

  void _onOpenChat(OpenChat event, Emitter<MatchState> emit) async{
    try {
      _databaseRepository.openChat(event.message);
      
    }on Exception catch (e) {
      print(e.toString());
      
    }
  }

  void _onDeleteLikedMeUser(DeleteLikedMeUser event, Emitter<MatchState> emit) async{
    try {
      _databaseRepository.deleteLikedMeUser(event.userId, event.likedMeUserId);
    }on Exception catch (e) {
      print(e.toString());
    }
  }


}
