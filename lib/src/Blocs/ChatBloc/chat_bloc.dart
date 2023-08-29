import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';

import '../../Data/Models/model.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _authSubscription;

  ScrollController scrollController = ScrollController();
  late String userId;
  late String matchedUserId;

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
    on<LoadMoreChats>(_onLoadMoreChats);

    _authSubscription = _authBloc.stream.listen((state) {
      if(state.user!.uid != null){
       // add(LoadChats(userId: state.user!.uid));
      }
     });

     scrollController.addListener(() {
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        var msg = (state as ChatLoaded).messages.last;
        add(LoadMoreChats(userId: userId, matchedUserId: matchedUserId, startAfter: msg.timestamp!));
      }
     });
  }

  void _onLoadChats(LoadChats event, Emitter<ChatState> emit) {
    
    try {
  _databaseRepository.getChats(event.userId, event.matchedUserId).listen((messages) {
    add(UpdateChats(messages: messages));
   });

  userId = event.userId;
  matchedUserId = event.matchedUserId;

} on Exception catch (e) {
  // TODO
  print(e);
}

  }

  void _onUpdateChats(UpdateChats event, Emitter<ChatState> emit) {
    
    //final lastMessages = _databaseRepository.getLastMessage(event.chats, matchedUserId)
    //final firstMessages = (state as ChatLoaded).messages;
    
    emit(ChatLoaded(messages: event.messages ));

  }


void _onSendMessage(SendMessage event, Emitter<ChatState> emit) async{
    try {
  await _databaseRepository.sendMessage(event.message);
} on Exception catch (e) {
  // TODO
  print(e);
}
}

void _onLoadMoreChats(LoadMoreChats event, Emitter<ChatState> emit) async{
  try {
    List<Message> newMessages = await _databaseRepository.getMoreChats(userId: event.userId, matchedUserId: event.matchedUserId, startAfter: event.startAfter);
    List<Message> messages = (state as ChatLoaded).messages;
    
    emit(ChatLoaded(messages: [...messages, ...newMessages]));
 
  } catch (e) {
    
  }
}

  // @override
  // ChatState? fromJson(Map<String, dynamic> json) {
  //   // TODO: implement fromJson
  //   if(json['stateType'] == 'chatLoading'){
  //     return ChatLoading();
  //   }
  //   if(json['stateType'] == ChatLoaded){
  //     var res = json['state'] as List<Map<String, dynamic>>;
      
  //     return ChatLoaded(messages: res.map((msg) => Message.fromMap(msg)).toList());

  //   }
  // }

  // @override
  // Map<String, dynamic>? toJson(ChatState state) {
  //   // TODO: implement toJson
  //   if(state is ChatLoaded){
  //     return {
  //       'stateType': 'chatLoaded',
  //       'state' :state.toMap()};
  //   }
  //   if(state is ChatLoading){
  //     return {'stateType': 'chatLoading'};
  //   }else{
  //     return null;
  //   }
     
  // }

}
