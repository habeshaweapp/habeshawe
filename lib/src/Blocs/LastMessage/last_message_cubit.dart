import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';

part 'last_message_state.dart';

class LastMessageCubit extends Cubit<LastMessageState> {
  final DatabaseRepository _databaseRepository;

  LastMessageCubit({
    required DatabaseRepository databaseRepository
  }) : _databaseRepository = databaseRepository, 
   super(LastMessageInitial());

  void getLastMessage(String userId, String matchedUserId){
    emit(LastMessageLoading());
    try {
      _databaseRepository.getLastMessage(userId, matchedUserId).listen((message) {
      emit(LastMessageLoaded(message: message[0]));
    });
      
    }on Exception catch (e) {
      print(e);
    }

     
  }
}
