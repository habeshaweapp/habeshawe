import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';

import '../../Data/Models/model.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _authSubscription;

  ChatBloc({
    required DatabaseRepository databaseRepository,
    required AuthBloc authBloc,
  }) : 
  _databaseRepository = databaseRepository,
  _authBloc = authBloc,
  super(ChatLoading()) {
    on<LoadChats>(_onLoadChats);
    on<UpdateChats>(_onUpdateChats);
    on<SendMessage>(_onSendMessage);

    _authSubscription = _authBloc.stream.listen((state) {
      if(state.user!.uid != null){
       // add(LoadChats(userId: state.user!.uid));
      }
     });
  }

  void _onLoadChats(LoadChats event, Emitter<ChatState> emit) {
    
    try {
  _databaseRepository.getChats(event.userId, event.matchedUserId).listen((messages) {
    add(UpdateChats(messages: messages));
   });
} on Exception catch (e) {
  // TODO
  print(e);
}

  }

  void _onUpdateChats(UpdateChats event, Emitter<ChatState> emit) {
    
    //final lastMessages = _databaseRepository.getLastMessage(event.chats, matchedUserId)
    emit(ChatLoaded(messages: event.messages));

  }


void _onSendMessage(SendMessage event, Emitter<ChatState> emit) async{
    try {
  await _databaseRepository.sendMessage(event.message);
} on Exception catch (e) {
  // TODO
  print(e);
}
}

}
