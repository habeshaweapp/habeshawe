// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:lomi/src/Data/Repository/Database/database_repository.dart';

// part 'images_event.dart';
// part 'images_state.dart';

// class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
//   final DatabaseRepository _databaseRepository;
//   StreamSubscription? _databaseSubscription;
//   ImagesBloc({required DatabaseRepository databaseRepository}) :
//       _databaseRepository = databaseRepository, 
//     super(ImagesLoaded()) {
//     on<LoadImages>(_loadImages);
//     on<UpdateImages>(_updateImages);
//   }

//   void _loadImages(LoadImages event, Emitter<ImagesState> emit) async{
//     _databaseSubscription?.cancel();
//     _databaseRepository.getUser().listen(
//       (user) => add(
//         UpdateImages(user.imageUrls)
//         )
//       );
//   }

//   void _updateImages(UpdateImages event, Emitter<ImagesState> emit) {
//     emit(ImagesLoaded(imageUrls: event.imageUrls));

//   }
// }
