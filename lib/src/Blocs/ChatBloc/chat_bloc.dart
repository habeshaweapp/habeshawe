import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';

import '../../Data/Models/enums.dart';
import '../../Data/Models/model.dart';
import '../../Data/Repository/Storage/storage_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final DatabaseRepository _databaseRepository;
  final StorageRepository _storageRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _authSubscription;
  StreamSubscription? _loadChatSubscription;

  ScrollController scrollController = ScrollController();
  late String userId;
  late String matchedUserId;

  ChatBloc({
    required DatabaseRepository databaseRepository,
    required AuthBloc authBloc,
    required StorageRepository storageRepository
  }) : 
  _databaseRepository = databaseRepository,
  _authBloc = authBloc,
  _storageRepository = storageRepository,
  super(ChatLoading()) {
    on<LoadChats>(_onLoadChats);
    on<UpdateChats>(_onUpdateChats);
    on<SendMessage>(_onSendMessage);
    on<LoadMoreChats>(_onLoadMoreChats);
    on<FirstMessageSent>(_onFirstMessageSent);
    on<SeenMessage>(_onSeenMessage);
    on<UnMatch>(_onUnMatch);
    on<ReportMatch>(_onReportMatch);
    on<DeleteMessage>(_onDeleteMessage);
    on<EditMessage>(_onEditMessage);

    _authSubscription = _authBloc.stream.listen((state) {
      if(state.user != null){
       // add(LoadChats(userId: state.user!.uid));
      }
     });

     scrollController.addListener(() {
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        var msg = (state as ChatLoaded).messages.last;
        add(LoadMoreChats(userId: _authBloc.state.user!.uid,users:_authBloc.state.accountType! , matchedUserId: matchedUserId, startAfter: msg.timestamp!));
      }
     });
  }

  void _onLoadChats(LoadChats event, Emitter<ChatState> emit) {
    
    try {
     _loadChatSubscription =  _databaseRepository.getChats(event.userId, event.users, event.matchedUserId).listen((messages) {
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
      if(event.image == null){
        await _databaseRepository.sendMessage(event.message, event.users);
      }
      else{
        var imageUrl = await _storageRepository.sendMessageImage(userId: event.message.senderId,gender: event.users, image: event.image!,);
        await _databaseRepository.sendMessage(event.message.copyWith(imageUrl: imageUrl), event.users);
      }
  
} on Exception catch (e) {
  // TODO
  print(e);
}
}

void _onLoadMoreChats(LoadMoreChats event, Emitter<ChatState> emit) async{
  try {
    List<Message> newMessages = await _databaseRepository.getMoreChats(userId: event.userId, users: event.users,  matchedUserId: event.matchedUserId, startAfter: event.startAfter);
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


  FutureOr<void> _onFirstMessageSent(FirstMessageSent event, Emitter<ChatState> emit) {
    List<Message> msgs=[];
    if(state is ChatLoaded){
      msgs = (state as ChatLoaded).messages;
    }
    msgs.add(event.message);
    
    emit(ChatLoaded(messages: msgs));
  }


  FutureOr<void> _onSeenMessage(SeenMessage event, Emitter<ChatState> emit) {
    try {
      _databaseRepository.seenMessage(message: event.message, gender: event.users);
      
    } catch (e) {
      
    }
  }

  FutureOr<void> _onUnMatch(UnMatch event, Emitter<ChatState> emit) {
    try {
      _databaseRepository.unMatch(userId: event.userId, gender: event.gender, matchUser: event.matchUser);
      
    } catch (e) {
      
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _authSubscription?.cancel();
    _loadChatSubscription?.cancel();
    
    return super.close();
  }


  FutureOr<void> _onReportMatch(ReportMatch event, Emitter<ChatState> emit)async {
    try{
    await _databaseRepository.reportMatch(userId: event.userId, gender: event.gender,index: event.index, reportedUser: event.matchUser, reportName: event.reportName, description: event.description );
    }catch(e){
      print(e);
    }
  }

  FutureOr<void> _onDeleteMessage(DeleteMessage event, Emitter<ChatState> emit) {
    try {
      _databaseRepository.deleteMessage(message: event.message, deletealso: event.deleteAlso, gender: event.gender);
    } catch (e) {
      
    }
  }

  FutureOr<void> _onEditMessage(EditMessage event, Emitter<ChatState> emit) {
    try {
      _databaseRepository.editMessage(message: event.message, gender:event.gender, newMessage: event.newMessage );
      
    } catch (e) {
      
    }
  }
}
