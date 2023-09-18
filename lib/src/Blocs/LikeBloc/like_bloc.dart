import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';

import '../../Data/Models/likes_model.dart';
import '../../Data/Models/model.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _authSubscription;
  LikeBloc({
    required DatabaseRepository databaseRepository,
    required AuthBloc authBloc
  }) : _databaseRepository = databaseRepository,
        _authBloc = authBloc,
  super(LikeLoading()) {
    on<LoadLikes>(_onLoadLikes);
    on<UpdateLikes>(_onUpdateLikes);
    on<LikeLikedMeUser>(_onLikeLikedMeUser);
    on<DeleteLikedMeUser>(_onDeleteLikedMeUser);

    // _authSubscription = _authBloc.stream.listen((state) {
    //   if(state.user != null && state.accountType != Gender.nonExist){
    //     add(LoadLikes(userId: state.user!.uid, users: state.accountType!));
    //   }
    // });
  }

void _onLikeLikedMeUser(LikeLikedMeUser event, Emitter<LikeState> emit) async{
   try {
  await  _databaseRepository.likeLikedMeUser(event.userId, event.users, event.likedMeUser);
} on Exception catch (e) {
  // TODO
  print(e.toString());
}

  }

  FutureOr<void> _onLoadLikes(LoadLikes event, Emitter<LikeState> emit) {
    try {
      _databaseRepository.getLikedMeUsers(event.userId, event.users).listen((users) { 
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
    }on Exception catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    return super.close();
  }
}
