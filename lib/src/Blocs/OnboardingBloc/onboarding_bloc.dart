import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/Data/Repository/Storage/storage_repository.dart';

import '../../Data/Models/model.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final DatabaseRepository _databaseRepository;
  final StorageRepository _storageRepository;
 // StreamSubscription? databaseSubscription;
  OnboardingBloc({
    required DatabaseRepository databaseRepository,
    required StorageRepository storageRepository
  }) : 
  _databaseRepository = databaseRepository,
  _storageRepository = storageRepository,
  super(OnboardingLoading()) {
    on<StartOnBoarding>(_onStartOnboarding);
    on<UpdateUser>(_onUserUpdate);
    on<UpdateUserImages>(_onUpdateUserImages);
    on<EditUser>(_onEditUser);
  }

  void _onStartOnboarding(StartOnBoarding event, Emitter<OnboardingState> emit) async{

   // User user = User(id: '', name: '', age: 0, gender: 'gender', imageUrls: [], interests: [], school: '', birthday: '');

    try {
  await _databaseRepository.createUser(event.user);
  
  emit(OnboardingLoaded(user: event.user));
} on Exception catch (e) {
  // TODO
  //emit(Onboardinger)
  print(e.toString());
}

  }

  void _onUserUpdate(UpdateUser event, Emitter<OnboardingState> emit){
    if(state is OnboardingLoaded){
      _databaseRepository.updateUser(event.user);
      emit(OnboardingLoaded(user: event.user));
    }
    
  }

  void _onUpdateUserImages(UpdateUserImages event, Emitter<OnboardingState> emit) async{
    if(state is OnboardingLoaded){
     // databaseSubscription!.cancel();
     try {
      User user = (state as OnboardingLoaded).user;
      await _storageRepository.uploadImage(user, event.image);

      _databaseRepository.getUser(user.id!).listen((user) { 
        add(UpdateUser(user: user));
       });
       
     }on Exception catch (e) {
      print(e.toString());
       
     }
      
    }
    
  }

  void _onEditUser(EditUser event, Emitter<OnboardingState> emit){
    emit(OnboardingLoaded(user: event.user));
    
  }
}
