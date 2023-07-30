import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';

import '../../Data/Repository/Storage/storage_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc _authBloc;
  final DatabaseRepository _databaseRepository;
  final StorageRepository _storageRepository;
   StreamSubscription? _authSubscription;
  ProfileBloc({
    required AuthBloc authBloc,
    required DatabaseRepository databaseRepository,
    required StorageRepository storageRepository,
  }) 
  : _authBloc = authBloc,
    _databaseRepository = databaseRepository,
    _storageRepository = storageRepository,
  super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateProfileImages>(_onUpdateProfileImages);
    on<EditUserProfile>(_onEditUserProfile);

    on<VerifyMe>(_onVerifyMe);

    _authSubscription = _authBloc.stream.listen((state) { 
      if(state.user!.uid != null){
        add(LoadProfile(userId: state.user!.uid));
      }
    });
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) {
       try {
        _databaseRepository.getUser(event.userId).listen((user) { 
        add(UpdateProfile(user: user));

      });
         
       } catch (e) {
         
       }
      


  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) {
      emit(ProfileLoaded(user: event.user));
    
  }

  void _onEditUserProfile(EditUserProfile event, Emitter<ProfileState> emit) async{
      try {
  await _databaseRepository.updateUser(event.user);
} on Exception catch (e) {
  // TODO
  print(e.toString());
}
    
  }

  void _onUpdateProfileImages(UpdateProfileImages event, Emitter<ProfileState> emit) async{
    if(state is ProfileLoaded){
      try {

       await _storageRepository.uploadImage(event.user!, event.image);
        
      }on Exception catch (e) {
        print(e.toString());
      }
    }
  }

  void _onVerifyMe(VerifyMe event, Emitter<ProfileState> emit) async{
    try{
      await _storageRepository.uploadVerifyMeImage(event.user, event.image, event.type!);
    }on Exception catch (e) {
      print(e.toString());

    }
  }



  @override
  Future<void> close() async{
    _authSubscription!.cancel();
    super.close();
  }
}
