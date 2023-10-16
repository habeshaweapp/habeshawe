import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Blocs/InternetBloc/internet_bloc.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/ui/chat/components/fullimage.dart';

import '../../../Blocs/ChatBloc/chat_bloc.dart';
import '../../../Blocs/MatchBloc/match_bloc.dart';

class Body extends StatelessWidget {
   Body(this.userMatch,);
   final UserMatch userMatch;

  @override
  Widget build(BuildContext context) {
    String msg= '';
    final msgController = TextEditingController();
    //final scrollController = ScrollController();
    bool chatOpened = userMatch.chatOpened;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context,state) {
        return Column(
            children: [ 
              chatOpened ?
              BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
            if(state is ChatLoading){
              
                return const Expanded(child: Center(child: CircularProgressIndicator(),));
        
              
              
            }
            
            if(state is ChatLoaded){
              //scrollController.jumpTo(scrollController.position.maxScrollExtent);

             return  
              Expanded(
                child: state.messages != null ? 
                        Container(
                          child: ListView.builder(
                            
                            controller: context.read<ChatBloc>().scrollController,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.messages.length,
                            reverse: true,
                            
                            //userMatch.chat![0].messages.length,
                            itemBuilder: ((context, index) {
                              if(state.messages[index].senderId == userMatch.userId){
                                if(state.messages[index].seen == null) {
                                  context.read<ChatBloc>().add(SeenMessage(message: state.messages[index].copyWith(seen: Timestamp.fromDate(DateTime.now())), users: context.read<AuthBloc>().state.accountType!));
                              }
                              }
                              return ListTile(
                                
                                title: !(state.messages[index].senderId == userMatch.userId) ?
                                //userMatch.chat![0].messages[index].senderId == 1? 
                                state.messages[index].imageUrl ==null?
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.83),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)
                                        ),
                                      color: Colors.green.shade200,
                                    ),
                                    child:  Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          state.messages[index].message,                                    
                                          //userMatch.chat![0].messages[index].message,
                                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black)
                                          //TextStyle(color: Colors.black)
                                          ,),
                                          Row(
                                            //mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              //Icon(Icons.check, size: 13,),
                                              (context.read<InternetBloc>().state as InternetStatus).isConnected ?
                                              Text(state.messages[index].timestamp != null ? DateFormat('hh:mm a').format(state.messages[index].timestamp!.toDate() ):DateFormat('hh:mm a').format(DateTime.now()) ,
                                                  style: TextStyle(fontSize: 8),
                                                  
                                              ):Icon(Icons.access_time, size: 11,),

                                              state.messages[index].seen ==null? const Icon(Icons.done, size: 13,):const Icon(Icons.done_all, color: Colors.blue, size: 13,),
                                            ],
                                          )
                                      ],
                                    )
                                  )
                                )
                                  :Align(
                                    alignment: Alignment.topRight,
                                    child:GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> FullScreenImage(imageUrl: state.messages[index].imageUrl!)) );

                                      },
                                      child: UnconstrainedBox(
                                        child: Container(
                                          alignment: Alignment.topRight,
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width * 0.73,
                                            minHeight: 10
                                            ),
                                          decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                         // color: Colors.green.shade200,
                                                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: CachedNetworkImage(
                                              imageUrl: state.messages[index].imageUrl!,
                                              fit: BoxFit.cover,
                                              height: 300,
                                              ),
                                          )),
                                      ),
                                    )
                                    ) 
                                  
                                   :
              
                                  // Row(
                                  //   children: [
                                  //     CircleAvatar(
                                        
                                  //        backgroundImage: NetworkImage(userMatch.matchedUser.imageUrls[0]),
                    
                                  //          ),
                                  //          SizedBox(width: 10,),
                                  state.messages[index].imageUrl == null?
                                      Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.83),
                                        padding:const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:const BorderRadius.only(
                                        bottomRight: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)
                                        ),
                                          color: Colors.grey.shade200,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              state.messages[index].message,
                                              //userMatch.chat![0].messages[index].message,
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                   //Icon(Icons.check, size: 13,),
                                             
                                                  Text( DateFormat('hh:mm a').format(state.messages[index].timestamp!.toDate() ),
                                                  style: TextStyle(fontSize: 8 )),
                                                ],
                                              )
                                          ],
                                        )
                                      )
                                  //   ],
                                  // )
              
              
                              ):Align(
                                    alignment: Alignment.topLeft,
                                    child:GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> FullScreenImage(imageUrl: state.messages[index].imageUrl!)) );

                                      },
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        constraints: BoxConstraints(
                                           minHeight: 10,
                                           //maxHeight: 300,
                                          // maxWidth: 300,
                                          // minWidth: 100
                                          maxWidth: MediaQuery.of(context).size.width * 0.73,
                                          //maxHeight: MediaQuery.of(context).size.height * 0.33
                                          ),
                                        // height: 300,
                                        // width: 150,
                                        decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        //color: Colors.green.shade200,
                                                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: CachedNetworkImage(
                                            imageUrl: state.messages[index].imageUrl!,
                                            fit: BoxFit.cover,
                                            height: 300,
                                            //width: 300,
                                            
                                            ),
                                        )),
                                    )
                                    )
                                )
                              ;
                            })),
                        ):
                        SizedBox(),
                
              );
            }else{
              return Text('something went wrong...');
            }
        }): Expanded(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //SizedBox(height: 25,),
                    Spacer(flex: 1,),
                    Text('You matched with ${userMatch.name}'),
                    Text('21 minutes ago', style: Theme.of(context).textTheme.bodySmall,),
                    SizedBox(height: 25,),
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: 
                      // NetworkImage(
                      //   userMatch.matchedUser.imageUrls[0],
                      // ),
                      CachedNetworkImageProvider(
                              userMatch.imageUrls[0],
                            ),
                    ), 
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        Text('Say Hi!', ),
                        Icon(FontAwesomeIcons.faceSmileWink,color: Colors.green),
                      ],
                    ),
                    SizedBox(height: 10),
                    
        
        
                    Spacer(flex: 2,),
                  ],
                )
              )
                  ),
        
        
              
              
        
        
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   //height: 100,
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
        
              //       Expanded(
              //         child: Container(
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Colors.grey
              //           ),
              //           child: TextField(
              //             onChanged: (value) {
              //               msg = value;
              //             },
              //             decoration: InputDecoration(
              //               filled: true,
              //               fillColor: Colors.white,
              //               hintText: 'Type here...',
              //               contentPadding: const EdgeInsets.only(top: 5, left: 20, bottom: 5 ),
                            
              //             ),
              //             maxLines: 6,
              //             minLines: 1,
              //           ),
              //         ),
              //       ),
        
              //       IconButton(
              //         onPressed: (){
              //           context.read<ChatBloc>().add(SendMessage(message: Message(id: 'id', senderId: context.read<AuthBloc>().state.user!.uid, receiverId: context.read<AuthBloc>().state.user!.uid == state.messages![0].senderId ? state.messages![0].receiverId : state.messages![0].senderId, message: msg, timestamp: DateTime.now())));
              //         }, 
              //         icon: Icon(Icons.send_rounded, color: Colors.green,))
              //     ],
              //   ),
                  
              //   )
        
              Container(
                //margin: EdgeInsets.only(top: 10),
          //height: 60,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  //height: 40,
                  width: MediaQuery.of(context).size.width/1.3,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade900: Colors.grey.shade200,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20)
                    ),
                  ),
                  child:  TextField(
                    //keyboardType: TextInputType.,
                    controller: msgController,
                    maxLines: 6,
                    minLines: 1,
                    onChanged: (value){
                      msg = value;
                    },
                   // cursorColor: is Colors.black,
                    decoration:  InputDecoration(
                      border: InputBorder.none,
                      
                      //contentPadding: EdgeInsets.zero,
                      hintText: 'Type Here!',
                      //hintStyle: TextStyle(color: Colors.black),
                      
                      //hintStyle: Theme.of(context).textTheme.bodySmall,
                      icon: Padding(
                        padding: const EdgeInsets.all(0),
                        child: GestureDetector(
                          onTap: ()async{
                            final picker = ImagePicker();
                            final img = await picker.pickImage(source: ImageSource.gallery);
                            if(img != null){
                            final lastIndex = img.path.lastIndexOf(RegExp(r'.jp'));
                            final splitted = img.path.substring(0, (lastIndex));
                            final outPath = "${splitted}_out${img.path.substring(lastIndex)}";
                            var image = await FlutterImageCompress.compressAndGetFile(img.path, outPath, quality: 75
                            );

                            context.read<ChatBloc>().add(SendMessage(
                              message: Message(
                                id: '', 
                                senderId: context.read<AuthBloc>().state.user!.uid, 
                                receiverId: userMatch.userId, 
                                message: '',
                                ),
                                users: context.read<AuthBloc>().state.accountType!,
                                image: image
                                 ));

                            }
                          },
                          child: Icon(
                            FontAwesomeIcons.image, 
                            color: Colors.grey,
                            size: 20,
                            ),
                        ),
                      ),
                        suffix: Icon(
                          FontAwesomeIcons.paperclip,
                          color: Colors.grey,
                          size: 20,
                        )
                    ),
                  ),
                ),
        
                SizedBox(width: 7,),
        
                Container(
                  padding: EdgeInsets.only(right: 5),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.paperPlane,
                    color: Colors.white,
                    size: 20,
                    ),
                    onPressed: ()async{
                      //msg='';
                      if(!chatOpened){
                        //BlocProvider.of<MatchBloc>(context).add(OpenChat(message: Message(id: 'non', senderId: user.id, receiverId: context.read<AuthBloc>().state.user!.uid, message: msg, timestamp: DateTime.now())));
        
                        context.read<MatchBloc>().add(OpenChat(users: context.read<AuthBloc>().state.accountType! ,message: Message(id: 'id', senderId: context.read<AuthBloc>().state.user!.uid, receiverId: userMatch.userId, message: msgController.text,  )));

                        context.read<ChatBloc>().add(FirstMessageSent(message: Message(id: 'id', senderId: context.read<AuthBloc>().state.user!.uid, receiverId: userMatch.userId, message: msgController.text,  )));
                        chatOpened = true;
                        msgController.clear();
                      }else{
                      
                      context.read<ChatBloc>().add(SendMessage(users: context.read<AuthBloc>().state.accountType!, message: Message(id: 'id', senderId: context.read<AuthBloc>().state.user!.uid, receiverId: context.read<AuthBloc>().state.user!.uid == userMatch.userId ? userMatch.id! : userMatch.userId, message: msgController.text, timestamp: Timestamp.fromDate(DateTime.now()) )));
                      msgController.clear();
                      }
                    },
                  ),
                )
              ],
          
            ),
          ),
        ),
        SizedBox(height: 5,),
        
                
            ],
         );
      }
    );

  }
 
  }
 
        
      
    
   
  
