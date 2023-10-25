import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/Data/Repository/Storage/storage_repository.dart';

import '../../Data/Models/model.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final DatabaseRepository _databaseRepository;
  final StorageRepository _storageRepository;
  final AuthBloc _authBloc;
 // StreamSubscription? databaseSubscription;
  OnboardingBloc({
    required DatabaseRepository databaseRepository,
    required StorageRepository storageRepository,
    required AuthBloc authBloc
  }) : 
  _databaseRepository = databaseRepository,
  _storageRepository = storageRepository,
  _authBloc = authBloc,
  super(OnboardingLoading()) {
    on<StartOnBoarding>(_onStartOnboarding);
    on<UpdateUser>(_onUserUpdate);
    on<UpdateUserImages>(_onUpdateUserImages);
    on<EditUser>(_onEditUser);
    on<CompleteOnboarding>(_onCompleteOnboarding);
    on<ImagesSelected>(_onImagesSelected);
    on<RemovePhoto>(_onRemovePhoto);
  }

  void _onStartOnboarding(StartOnBoarding event, Emitter<OnboardingState> emit) async{

   // User user = User(id: '', name: '', age: 0, gender: 'gender', imageUrls: [], interests: [], school: '', birthday: '');

    try {
  //await _databaseRepository.createUser(event.user);
  
  emit(OnboardingLoaded(user: event.user));
} on Exception catch (e) {
  // TODO
  //emit(Onboardinger)
  print(e.toString());
}

  }

  void _onUserUpdate(UpdateUser event, Emitter<OnboardingState> emit){
    if(state is OnboardingLoaded){
      var st = (state as OnboardingLoaded);
      //_databaseRepository.updateUser(event.user);
      emit(OnboardingLoaded(user: event.user));
      //emit(st.copyWith(user: event.user, selectedImages: st.selectedImages!.sublist(1)) );
    }
    
  }

  void _onUpdateUserImages(UpdateUserImages event, Emitter<OnboardingState> emit) async{
    if(state is OnboardingLoaded){
     // databaseSubscription!.cancel();
     try {
      User user = (state as OnboardingLoaded).user;
      var url = await _storageRepository.uploadImage(user, event.image);
      user = (state as OnboardingLoaded).user;
      List<dynamic> imageUrls = [...user.imageUrls, url];
      //List<dynamic> imageUrls = user.imageUrls;
      //imageUrls.add(url);   this code doesnt work and its your greatest finding in flutter it doesnt copy but changes the user
      //user.imageUrls..add(url);
       
      //add(UpdateUser(user: user.copyWith(imageUrls: imageUrls)));
      var st = (state as OnboardingLoaded);

      emit(st.copyWith(user: user.copyWith(imageUrls: imageUrls), selectedImages: st.selectedImages!.length <= 1?null: st.selectedImages!.sublist(1)) );
    
       
     }on Exception catch (e) {
      print(e.toString());
       
     }
      
    }
    
  }

  void _onEditUser(EditUser event, Emitter<OnboardingState> emit){
    emit(OnboardingLoaded(user: event.user));
    
  }

  FutureOr<void> _onCompleteOnboarding(CompleteOnboarding event, Emitter<OnboardingState> emit) async {
    try {
      //_databaseRepository.createUser(event.user.copyWith(country: event.placeMark.country, countryCode: event.placeMark.isoCountryCode));
      if(!event.isMocked){
      bool completed = await _databaseRepository.completeOnboarding(placeMark: event.placeMark, user: event.user, isMocked: event.isMocked);
     

      if(completed){
        _authBloc.add(AuthUserChanged(user: _authBloc.state.user));
      }
      }
      
    } catch (e) {
      
    }
  }

  FutureOr<void> _onImagesSelected(ImagesSelected event, Emitter<OnboardingState> emit) {
    final stateLod = (state as OnboardingLoaded);
    emit(stateLod.copyWith(selectedImages: event.images));
  }

  FutureOr<void> _onRemovePhoto(RemovePhoto event, Emitter<OnboardingState> emit) {
    var st = (state as OnboardingLoaded);
    var urls = [...st.user.imageUrls];
    urls.remove(event.imageUrl);

    emit(st.copyWith(user: st.user.copyWith(imageUrls: urls )));
  }
}
