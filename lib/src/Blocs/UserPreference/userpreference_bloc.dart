import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lomi/src/Blocs/ContinueWith/continuewith_cubit.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';

import '../../Data/Models/userpreference_model.dart';
import '../AuthenticationBloc/bloc/auth_bloc.dart';

part 'userpreference_event.dart';
part 'userpreference_state.dart';

class UserpreferenceBloc extends Bloc<UserpreferenceEvent, UserpreferenceState> {
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _authSubscription;
  UserpreferenceBloc({
    required DatabaseRepository databaseRepository,
    required AuthBloc authBloc
  }) : _databaseRepository = databaseRepository,
        _authBloc = authBloc,

  super(UserPreferenceLoading()) {
    on<LoadUserPreference>(_onLoadUserPreference);
    on<UpdateUserPreference>(_onUpdateUserPreference);
    on<EditUserPreference>(_onEditUserPreference);


    _authSubscription = _authBloc.stream.listen((state) { 
      if(state.user != null && state.accountType != Gender.nonExist){
      add(LoadUserPreference(userId: state.user!.uid, users: state.accountType!));
    
      }
    });
  }

  void _onLoadUserPreference(LoadUserPreference event, Emitter<UserpreferenceState> emit) {
     try {
  _databaseRepository.getUserPreference(event.userId, event.users).listen((userPreference) {
       add(UpdateUserPreference(preference: userPreference));
   });
} on Exception catch (e) {
  // TODO
  print(e.toString());
}
  }

  void _onUpdateUserPreference(UpdateUserPreference event, Emitter<UserpreferenceState> emit){
    emit(UserPreferenceLoaded(userPreference: event.preference));
  }

  void _onEditUserPreference(EditUserPreference event, Emitter<UserpreferenceState> emit) async{
      try {
  await _databaseRepository.updateUserPreference(event.preference, event.users);
} on Exception catch (e) {
  // TODO
  print(e.toString());
}
    
  }


  @override
  Future<void> close() async {
    _authSubscription!.cancel();
    super.close();
  }
}

