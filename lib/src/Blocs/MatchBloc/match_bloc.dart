import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';

import '../../Data/Models/likes_model.dart';
import '../../Data/Models/model.dart';

part 'match_event.dart';
part 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _authSubscription;
  StreamSubscription? _matchesSubscription;
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
    
   // on<UpdateLikes>(_onUpdateLikes);

    // _authSubscription = _authBloc.stream.listen((state) { 
    //   if(state.user != null && state.accountType != Gender.nonExist){
    //     add(LoadMatchs(userId: state.user!.uid, users: state.accountType!));       
    //   }
    // });
  }

  void _onLoadMatchs(LoadMatchs event, Emitter<MatchState> emit) {
    try{
      emit(state.copyWith(matchStatus: MatchStatus.loading));

    _matchesSubscription = _databaseRepository.getMatches(event.userId, event.users).listen((matches) {

      add(UpdateMatches(matchedUsers: matches));

    });

    }on Exception catch(e){
      print(e);
    }

  }

  void _onUpdateMatches(UpdateMatches event, Emitter<MatchState> emit){
    try {
      //emit(MatchLoaded(matchedUsers: event.matchedUsers!));
      emit(state.copyWith(matchedUsers: event.matchedUsers, matchStatus: MatchStatus.loaded));
      
    }on Exception catch (e) {
      print(e.toString());
    }
  }


  void _onOpenChat(OpenChat event, Emitter<MatchState> emit) async{
    try {
       _databaseRepository.openChat(event.message, event.users);
      //await _databaseRepository.sendMessage(event.message, event.users);
      
    }on Exception catch (e) {
      print(e.toString());
      
    }
  }

  

  @override
  Future<void> close() {
    // TODO: implement close
    _authSubscription?.cancel();
    _matchesSubscription?.cancel();
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

  

  
}
