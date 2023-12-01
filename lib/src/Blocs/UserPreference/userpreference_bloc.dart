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

class UserpreferenceBloc extends Bloc<UserpreferenceEvent, UserPreferenceState> {
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _authSubscription;
  StreamSubscription? _prefesSubscription;
  UserpreferenceBloc({
    required DatabaseRepository databaseRepository,
    required AuthBloc authBloc
  }) : _databaseRepository = databaseRepository,
        _authBloc = authBloc,

  super(const UserPreferenceState()) {
    on<LoadUserPreference>(_onLoadUserPreference);
    on<UpdateUserPreference>(_onUpdateUserPreference);
    on<EditUserPreference>(_onEditUserPreference);

    
    add(LoadUserPreference(userId: _authBloc.state.user!.uid, users: _authBloc.state.accountType!));
    
    // _authSubscription = _authBloc.stream.listen((state) { 
    //   if(state.user != null && state.accountType != Gender.nonExist){
    //   add(LoadUserPreference(userId: state.user!.uid, users: state.accountType!));
    
    //   }
    // });
  }

  void _onLoadUserPreference(LoadUserPreference event, Emitter<UserPreferenceState> emit) {
     try {
  _prefesSubscription= _databaseRepository.getUserPreference(event.userId, event.users).listen((userPreference) {
       add(UpdateUserPreference(preference: userPreference));
   });
} on Exception catch (e) {
  // TODO
  print(e.toString());
}
  }

  void _onUpdateUserPreference(UpdateUserPreference event, Emitter<UserPreferenceState> emit){
    emit(state.copyWith(userPreference: event.preference, userPreferenceStatus: UserPreferenceStatus.loaded));
  }

  void _onEditUserPreference(EditUserPreference event, Emitter<UserPreferenceState> emit) async{
      try {
  await _databaseRepository.updateUserPreference(event.preference, event.users);
} on Exception catch (e) {
  // TODO
  print(e.toString());
}
    
  }


  @override
  Future<void> close() async {
    _authSubscription?.cancel();
    _prefesSubscription?.cancel();
    super.close();
  }
}

