import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Models/model.dart';

import '../../../Blocs/ChatBloc/chat_bloc.dart';

class Body extends StatelessWidget {
  const Body(this.userMatch);
  final UserMatch userMatch;

  @override
  Widget build(BuildContext context) {
    String msg= '';
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if(state is ChatLoading){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if(state is ChatLoaded){
        return  Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: state.messages != null ? 
                      Container(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.messages!.length,
                          reverse: true,
                          //userMatch.chat![0].messages.length,
                          itemBuilder: ((context, index) {
                            return ListTile(
                              
                              title: state.messages![index].senderId == userMatch.userId ?
                              //userMatch.chat![0].messages[index].senderId == 1? 
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    color: Colors.green,
                                  ),
                                  child: Text(
                                    state.messages![index].message,                                    
                                    //userMatch.chat![0].messages[index].message,
                                    style: TextStyle(color: Colors.white),))
                                ) :
          
                                Row(
                                  children: [
                                    CircleAvatar(
                                      
                                       backgroundImage: NetworkImage(userMatch.matchedUser.imageUrls[0]),
                  
                                         ),
                                         SizedBox(width: 10,),
                                    Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        color: Colors.grey.shade400,
                                      ),
                                      child: Text(
                                        state.messages![index].message,
                                        //userMatch.chat![0].messages[index].message,
                                        style: TextStyle(color: Colors.white),))
                                    ),
                                  ],
                                )
          
          
                            );
                          })),
                      ):
                      SizedBox(),
            ),
            
          ),
    
    
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            //height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
    
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey
                    ),
                    child: TextField(
                      onChanged: (value) {
                        msg = value;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Type here...',
                        contentPadding: const EdgeInsets.only(top: 5, left: 20, bottom: 5 ),
                        
                      ),
                      maxLines: 6,
                      minLines: 1,
                    ),
                  ),
                ),
    
                IconButton(
                  onPressed: (){
                    context.read<ChatBloc>().add(SendMessage(message: Message(id: 'id', senderId: context.read<AuthBloc>().state.user!.uid, receiverId: context.read<AuthBloc>().state.user!.uid == state.messages![0].senderId ? state.messages![0].receiverId : state.messages![0].senderId, message: msg, timestamp: DateTime.now())));
                  }, 
                  icon: Icon(Icons.send_rounded, color: Colors.green,))
              ],
            ),
              
            )
        ],
      );
        }else{
          return Text('something went wrong...');
        }
      }
    
    );
  }
}