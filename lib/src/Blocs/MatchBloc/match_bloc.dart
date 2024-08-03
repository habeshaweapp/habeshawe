import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/Data/Repository/SharedPrefes/sharedPrefes.dart';

import '../../Data/Models/likes_model.dart';
import '../../Data/Models/model.dart';
import '../../Data/Repository/Notification/notification_service.dart';

part 'match_event.dart';
part 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _authSubscription;
  StreamSubscription? _matchesSubscription;
  StreamSubscription? _activeSubscription;
  ScrollController matchController = ScrollController();
  ScrollController activeController = ScrollController();
  MatchBloc({
    required DatabaseRepository databaseRepository,
    required AuthBloc authBloc,
  }) : 
  _databaseRepository = databaseRepository,
  _authBloc = authBloc,
  super(const MatchState()) {
    on<LoadMatchs>(_onLoadMatchs);
    //on<LikeLikedMeUser>(_onLikeLikedMeUser);
    on<OpenChat>(_onOpenChat);
    //on<DeleteLikedMeUser>(_onDeleteLikedMeUser);

    on<UpdateMatches>(_onUpdateMatches);
    on<SearchName>(_onSearchName);
    on<LoadMoreMatches>(_onLoadMoreMatches);
    on<UpdateactiveMatches>(_onUpdateInactiveMatches);
    on<LoadMoreActiveMatches>(_onLoadMoreActiveMatches);
    on<CheckImage>(_onCheckImage);
    
    matchController.addListener(() {
      if(matchController.position.pixels == matchController.position.maxScrollExtent){
        var last= state.matchedUsers.last.timestamp;
        add(LoadMoreMatches(userId: _authBloc.state.user!.uid, gender: _authBloc.state.accountType!, startAfter: last!));
      }
    });

    activeController.addListener((){
      if(activeController.position.pixels == activeController.position.maxScrollExtent){
        var last = state.activeMatches.last.timestamp;
        add(LoadMoreActiveMatches(userId: _authBloc.state.user!.uid, gender: _authBloc.state.accountType!, startAfter: last!));

      }
    });
  }

  void _onLoadMatchs(LoadMatchs event, Emitter<MatchState> emit) {
    try{
      emit(state.copyWith(matchStatus: MatchStatus.loading));

    _matchesSubscription = _databaseRepository.getMatches(event.userId, event.users).listen((matches) {

      add(UpdateMatches(matchedUsers: matches));
      if(SharedPrefes.inBackground()==true){ 
        NotificationService().showMessageReceivedNotifications(title: 'New Match', body: "You have a new Match!---", payload: 'chat', channelId: 'backgroundMatch');

      }

    });

    _activeSubscription = _databaseRepository.getactiveMatches(event.userId,event.users).listen((inactive){
      add(UpdateactiveMatches(activeMatches: inactive ));
      if(SharedPrefes.inBackground() == true){
         NotificationService().showMessageReceivedNotifications(title: 'Message', body: 'Someone Messaged you!----', payload: 'chat', channelId: 'backgroundMessage');
      }

    });

    }on Exception catch(e){
      print(e);
    }

  }

  void _onUpdateMatches(UpdateMatches event, Emitter<MatchState> emit){
      //emit(MatchLoaded(matchedUsers: event.matchedUsers!));
      emit(state.copyWith(matchedUsers: event.matchedUsers, matchStatus: MatchStatus.loaded));
 
  }


  void _onOpenChat(OpenChat event, Emitter<MatchState> emit) async{
    try {
       await _databaseRepository.openChat(event.message, event.users);
      //await _databaseRepository.sendMessage(event.message, event.users);
      // var matches = [...state.matchedUsers];
      // var newMatches = matches.remove(event.)

      // emit(state.copyWith(matchedUsers: state.matchedUsers))
      
    }on Exception catch (e) {
      print(e.toString());
      
    }
  }

  

  @override
  Future<void> close() {
    // TODO: implement close
    _authSubscription?.cancel();
    _matchesSubscription?.cancel();
    _activeSubscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onSearchName(SearchName event, Emitter<MatchState> emit)async {
    try {
      if(event.name.length > 25 ){
        emit(state.copyWith(searchResultFor: SearchResultFor.findMe, isUserSearching: true));
        User? user = await _databaseRepository.findMeOnHabeshaWe(id: event.name, gender: event.gender);
        print('hi');
        emit(state.copyWith(findMeResult: user == null? []: [user] ));


      }else
      if(event.name != ''){
        emit(state.copyWith(searchResultFor: SearchResultFor.matched , isUserSearching: true));

     List<UserMatch> result = await _databaseRepository.searchMatchName(userId: event.userId, gender: event.gender, name: event.name.toLowerCase().replaceFirst(event.name[0], event.name[0].toUpperCase()) );
     emit(state.copyWith(searchResult: result));
     

      }else{
       
        emit(state.copyWith(searchResult: [], findMeResult: [], isUserSearching: false));
      }
      
    } catch (e) {
      
    }
  }

  

  

  FutureOr<void> _onLoadMoreMatches(LoadMoreMatches event, Emitter<MatchState> emit) async{
    try {
      var newMatches = await _databaseRepository.loadMoreMatches(userId: event.userId, gender:event.gender,startAfter:event.startAfter);
      var matches = state.matchedUsers;
      emit(state.copyWith(matchedUsers: [...matches, ...newMatches]));
      
    } catch (e) {
      
    }
  }

  FutureOr<void> _onUpdateInactiveMatches(UpdateactiveMatches event, Emitter<MatchState> emit) {
    emit(state.copyWith(activeMatches: event.activeMatches,matchStatus: MatchStatus.loaded));
  }

  FutureOr<void> _onLoadMoreActiveMatches(LoadMoreActiveMatches event, Emitter<MatchState> emit)async {
    try{
      var newActives = await _databaseRepository.loadMoreActiveMatches(userId: event.userId, gender:event.gender,startAfter:event.startAfter);
      var actives = state.activeMatches;
      emit(state.copyWith(activeMatches: [...actives,...newActives]));


    }catch(e){

    }
  }

  FutureOr<void> _onCheckImage(CheckImage event, Emitter<MatchState> emit)async {

    // var newImages = (await _databaseRepository.getUserbyId(event.match.id!, event.match.gender)).imageUrls;
    // if(!listEquals(newImages, event.match.imageUrls)){
    //   _databaseRepository.changeMatchImage(user: event.user, matchId: event.match.id, newImages: newImages, from: 'matches' );
    // }

  }
}
