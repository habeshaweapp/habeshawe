import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';

import '../../Data/Models/likes_model.dart';
import '../../Data/Models/model.dart';
import '../PaymentBloc/payment_bloc.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  final PaymentBloc _paymentBloc;
  StreamSubscription? _authSubscription;
  StreamSubscription? _likesSubscription;
  ScrollController likeController = ScrollController();
  LikeBloc({
    required DatabaseRepository databaseRepository,
    required AuthBloc authBloc,
    required PaymentBloc paymentBloc
  }) : _databaseRepository = databaseRepository,
        _authBloc = authBloc,
        _paymentBloc = paymentBloc,
  super(LikeLoading()) {
    on<LoadLikes>(_onLoadLikes);
    on<UpdateLikes>(_onUpdateLikes);
    on<LikeLikedMeUser>(_onLikeLikedMeUser);
    on<DeleteLikedMeUser>(_onDeleteLikedMeUser);
    on<LoadMoreLikes>(_onLoadMoreLikes);

    // _authSubscription = _authBloc.stream.listen((state) {
    //   if(state.user != null && state.accountType != Gender.nonExist){
    //     add(LoadLikes(userId: state.user!.uid, users: state.accountType!));
    //   }
    // });
    likeController.addListener(() {
      if(likeController.position.pixels == likeController.position.maxScrollExtent ){
        var likes = (state as LikeLoaded).likedMeUsers.last;
        add(LoadMoreLikes(userId: _authBloc.state.user!.uid, gender: _authBloc.state.accountType!, startAfter: likes.timestamp));

      }
    });
  }

void _onLikeLikedMeUser(LikeLikedMeUser event, Emitter<LikeState> emit) async{
   try {
  await  _databaseRepository.likeLikedMeUser(event.user, event.likedMeUser, event.isSuperLike!);
  if(event.isSuperLike!){
    _paymentBloc.add(ConsumeSuperLike());

  }

  var likes = (state as LikeLoaded).likedMeUsers;
 // likes.remove(event.likedMeUser);
  List<Like> modLikes = [...likes];
  modLikes.remove(event.likedMeUser);
  add(UpdateLikes(users: modLikes));

//shwutii is enii mini mo lavarrrrrr
//the code above is dope i descovered it 
  
} on Exception catch (e) {
  // TODO
  print(e.toString());
}

  }

  FutureOr<void> _onLoadLikes(LoadLikes event, Emitter<LikeState> emit) {
    try {
       _likesSubscription = _databaseRepository.getLikedMeUsers(event.userId, event.users).listen((users) { 
        add(UpdateLikes(users: users));
      });
      
    } catch (e) {
      
    }
  }

  FutureOr<void> _onUpdateLikes(UpdateLikes event, Emitter<LikeState> emit) {
    //if(event.users.isNotEmpty){
      emit(LikeLoaded(likedMeUsers: event.users));
    //}
  }

  void _onDeleteLikedMeUser(DeleteLikedMeUser event, Emitter<LikeState> emit) async{
    try {
      _databaseRepository.deleteLikedMeUser(event.userId,event.users, event.likedMeUserId);

      var likes = (state as LikeLoaded).likedMeUsers;
      List<Like> modLikes = [...likes];
 // modLikes.remove(event.likedMeUser);
      modLikes.removeWhere((element) => element.userId == event.likedMeUserId);
      add(UpdateLikes(users: modLikes));
    }on Exception catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _authSubscription?.cancel();
    _likesSubscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onLoadMoreLikes(LoadMoreLikes event, Emitter<LikeState> emit)async {
    try {
      var newLikes = await _databaseRepository.loadMoreLikes(userId: event.userId, gender:event.gender,startAfter:event.startAfter);
      var like = (state as LikeLoaded).likedMeUsers;
      add(UpdateLikes(users: [...like,...newLikes]));
      
    } catch (e) {
      
    }
  }
}
