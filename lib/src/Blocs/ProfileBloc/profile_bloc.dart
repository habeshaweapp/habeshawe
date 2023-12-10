import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';

import '../../Data/Repository/Storage/storage_repository.dart';
import '../SharedPrefes/sharedpreference_cubit.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc _authBloc;
  final DatabaseRepository _databaseRepository;
  final StorageRepository _storageRepository;
   StreamSubscription? _authSubscription;
  StreamSubscription? _profileSubscription;
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
    on<DeletePhoto>(_onDeletePhoto);

 
    add(LoadProfile(userId: _authBloc.state.user!.uid, users: _authBloc. state.accountType!));
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) {
       try {
        _profileSubscription= _databaseRepository.getUser(event.userId, event.users).listen((user) { 
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

       String url = await _storageRepository.uploadImage(event.user!, event.image);
       await _databaseRepository.updateUserPictures(event.user!, url);
        
      }on Exception catch (e) {

        print(e.toString());
        
      }
    }
  }

  void _onVerifyMe(VerifyMe event, Emitter<ProfileState> emit) async{
    try{
      String url= await _storageRepository.uploadVerifyMeImage(event.user, event.image, event.onlyVerifyMe!);
       await _databaseRepository.updateUser(event.user.copyWith(verified: 'pending'));
       await _databaseRepository.addVerifyMeUser(event.user, event.onlyVerifyMe!, url);
    }on Exception catch (e) {
      print(e.toString());

    }
  }



  @override
  Future<void> close() async{
    _authSubscription?.cancel();
    _profileSubscription?.cancel();
    super.close();
  }

  FutureOr<void> _onDeletePhoto(DeletePhoto event, Emitter<ProfileState> emit)async {
    try {
    await _databaseRepository.deletePhoto(imageUrl:event.imageUrl, userId: event.userId, users:event.users);
   
    } catch (e) {
      print(e.toString());
    }
  }


}
