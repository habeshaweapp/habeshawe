import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Blocs/InternetBloc/internet_bloc.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/ui/chat/components/fullimage.dart';

import '../../../Blocs/ChatBloc/chat_bloc.dart';
import '../../../Blocs/MatchBloc/match_bloc.dart';
import '../../../Data/Models/enums.dart';
import 'view_profile.dart';

class Body extends StatefulWidget {
   Body(this.userMatch,this.ctx);
   final UserMatch userMatch;
   final BuildContext ctx;

   

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
    Offset? tapxy;

    Size? overlay;

  final msgController = TextEditingController();

  FocusNode focusNode = FocusNode(); 
  bool editMode = false;
  Message? tobeEdited;
  bool deleteAlso = true;

  @override
  Widget build(BuildContext context) {
    String msg= '';
   // final msgController = TextEditingController();
    //final scrollController = ScrollController();
    bool chatOpened = widget.userMatch.chatOpened;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    //overlay = Overlay.of(context).context.findRenderObject();
    overlay = MediaQuery.of(context).size;

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
                              if(state.messages[index].senderId == widget.userMatch.userId){
                                if(state.messages[index].seen == null) {
                                  context.read<ChatBloc>().add(SeenMessage(message: state.messages[index].copyWith(seen: Timestamp.fromDate(DateTime.now())), users: context.read<AuthBloc>().state.accountType!));
                              }
                              }
                              var separatorDate = '';
                              if(index == 0 && state.messages.length == 1){
                                separatorDate = groupMessages(state.messages[index].timestamp?.toDate());

                              }else if(index ==state.messages.length -1){
                                separatorDate = groupMessages(state.messages[state.messages.length-1].timestamp!.toDate());
                              }else{

                              var date = state.messages[index].timestamp?.toDate();
                              var prevDate = state.messages[index+1].timestamp?.toDate();


                              //bool isSameDate = date ==null?true: date.isAtSameMomentAs(prevDate!);
                              bool isSameDate  = (date ==null || prevDate == null)?true:false;
                               isSameDate =date ==null?true: (date.year == prevDate!.year && date.month == prevDate.month && date.day == prevDate.day)?true:false;
                              
                              separatorDate= isSameDate? '': groupMessages(state.messages[index].timestamp!.toDate());

                              }

                              return Column(
                                children: [
                                  separatorDate != ''? Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.circular(25)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal:10.0, vertical: 5),
                                        child: Text(separatorDate, style: TextStyle(fontSize: 10.sp, color: Colors.white),),
                                      )
                                    ),
                                  ) :const SizedBox(),
                                  ListTile(
                                    
                                    title: !(state.messages[index].senderId == widget.userMatch.userId) ?
                                    //userMatch.chat![0].messages[index].senderId == 1? 
                                    state.messages[index].imageUrl ==null?
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTapDown: getPosition,
                                        onTap: (){
                                          messagePressed(context, state.messages[index]);
                                        },
                                        onLongPress:()=> messagePressed(context, state.messages[index]),
                                        child: Container(
                                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.83),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)
                                              ),
                                            color: isDark?Colors.teal.shade900 : Colors.green.shade200,
                                          ),
                                          child:  Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                state.messages[index].message,                                    
                                                //userMatch.chat![0].messages[index].message,
                                                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: !isDark? Colors.black:null)
                                                //TextStyle(color: Colors.black)
                                                ,),
                                                Row(
                                                  //mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    //Icon(Icons.check, size: 13,),
                                                   context.read<InternetBloc>().state.isConnected ==true ?
                                                    Text(state.messages[index].timestamp != null ? DateFormat('hh:mm a').format(state.messages[index].timestamp!.toDate() ):DateFormat('hh:mm a').format(DateTime.now()) ,
                                                        style: TextStyle(fontSize: 8.sp),
                                                        
                                                    ):Icon(Icons.access_time, size: 11,),
                                      
                                                    state.messages[index].seen ==null? const Icon(Icons.done, size: 13,): Icon(Icons.done_all, color:isDark?Colors.teal: Colors.green.shade700, size: 13,),
                                                  ],
                                                )
                                            ],
                                          )
                                        ),
                                      )
                                    )
                                      :Align(
                                        alignment: Alignment.topRight,
                                        child:GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> FullScreenImage(imageUrl: state.messages[index].imageUrl!)) );
                                            
                                          },
                                          onTapDown: getPosition,
                                          onLongPress : () => ImagePressed(context, state.messages[index]),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: Stack(
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: state.messages[index].imageUrl!,
                                                  fit: BoxFit.cover,
                                                  height: 300,
                                                  placeholder:(context, name)=> Container(color: isDark? Colors.grey[800]: Colors.grey),
                                                  width: MediaQuery.of(context).size.width*0.5,
                                                  ),

                                                  Positioned(
                                                    right: 10,
                                                    bottom: 10,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15),
                                                        color: Colors.black45,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(3.0),
                                                        child: Row(
                                                        //mainAxisSize: MainAxisSize.min,
                                                                                                 // mainAxisAlignment: MainAxisAlignment.end,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          //Icon(Icons.check, size: 13,),
                                                          context.read<InternetBloc>().state.isConnected ==true ?
                                                          Text(state.messages[index].timestamp != null ? DateFormat('hh:mm a').format(state.messages[index].timestamp!.toDate() ):DateFormat('hh:mm a').format(DateTime.now()) ,
                                                              style: TextStyle(fontSize: 8.sp, color: Colors.white),
                                                              
                                                          ):Icon(Icons.access_time, size: 11,),
                                                                                                    
                                                          state.messages[index].seen ==null? const Icon(Icons.done, size: 13,color: Colors.grey,):const Icon(Icons.done_all, color: Colors.white, size: 13,),
                                                        ],
                                                                                                ),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
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
                                          child: GestureDetector(
                                            onTapDown: getPosition,
                                            onTap: (){
                                              messagePressedMatch(context, state.messages[index]);
                                            },
                                            onLongPress:()=> messagePressedMatch(context, state.messages[index]),
                                            child: Container(
                                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.83),
                                              padding:const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:const BorderRadius.only(
                                              bottomRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)
                                              ),
                                                color: isDark? Colors.grey[800] : Colors.grey.shade200,
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    state.messages[index].message,
                                                    //userMatch.chat![0].messages[index].message,
                                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color:!isDark? Colors.black: null),),
                                          
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                         //Icon(Icons.check, size: 13,),
                                                   
                                                        Text( DateFormat('hh:mm a').format(state.messages[index].timestamp!.toDate() ),
                                                        style: TextStyle(fontSize: 8.sp )),
                                                      ],
                                                    )
                                                ],
                                              )
                                            ),
                                          )
                                      //   ],
                                      // )
              
              
                                  ):GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> FullScreenImage(imageUrl: state.messages[index].imageUrl!)) );

                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Stack(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: state.messages[index].imageUrl!,
                                                fit: BoxFit.cover,
                                                height: 300,
                                                //width: 300,
                                                placeholder:(context, name)=> Container(color: isDark? Colors.grey[800]: Colors.grey),
                                                width: MediaQuery.of(context).size.width * 0.5,
                                                
                                                ),

                                                Positioned(
                                                    right: 10,
                                                    bottom: 10,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15),
                                                        color: Colors.black45,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(3.0),
                                                        child: Row(
                                                        //mainAxisSize: MainAxisSize.min,
                                                                                                 // mainAxisAlignment: MainAxisAlignment.end,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          //Icon(Icons.check, size: 13,),
                                                          context.read<InternetBloc>().state.isConnected ==true ?
                                                          Text(state.messages[index].timestamp != null ? DateFormat('hh:mm a').format(state.messages[index].timestamp!.toDate() ):DateFormat('hh:mm a').format(DateTime.now()) ,
                                                              style: TextStyle(fontSize: 8.sp, color: Colors.white),
                                                              
                                                          ):Icon(Icons.access_time, size: 11,),
                                                                                                    
                                                          //state.messages[index].seen ==null? const Icon(Icons.done, size: 13,color: Colors.grey,):const Icon(Icons.done_all, color: Colors.white, size: 13,),
                                                        ],
                                                                                                ),
                                                      ),
                                                    ),
                                                  )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                    ),
                                ],
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
                    
                    
                    GestureDetector(
                      onTap: (){
                         Navigator.push(context, MaterialPageRoute(
                             builder: (ctxt)=>
    
                                    ViewProfile(match: widget.userMatch,ctrx: widget.ctx,profileFrom: ProfileFrom.chat,)));
                      },
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: 
                        // NetworkImage(
                        //   userMatch.matchedUser.imageUrls[0],
                        // ),
                        CachedNetworkImageProvider(widget.userMatch.imageUrls.isNotEmpty?
                                widget.userMatch.imageUrls[0]
                                :'x',
                              ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text('You matched with ${widget.userMatch.name}'),
                    Text(matchedTimecal(widget.userMatch.timestamp!), style: Theme.of(context).textTheme.bodySmall,),
                    SizedBox(height: 15,),
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
                    color: isDark ? Color.fromARGB(255, 44, 42, 42): Colors.grey.shade200,
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
                    focusNode: focusNode,
                   // cursorColor: is Colors.black,
                    decoration:  InputDecoration(
                      border: InputBorder.none,
                      
                      //contentPadding: EdgeInsets.zero,
                      hintText: 'Type Here!',
                      //hintStyle: TextStyle(color: Colors.black),
                      
                      //hintStyle: Theme.of(context).textTheme.bodySmall,
                      icon: !editMode? Padding(
                        padding: const EdgeInsets.all(0),
                        child: GestureDetector(
                          onTap: ()async{
                            final picker = ImagePicker();
                            final img = await picker.pickImage(source: ImageSource.gallery);
                            if(img != null){
                            final lastIndex = img.path.lastIndexOf(RegExp(r'.jp'));
                            final splitted = img.path.substring(0, (lastIndex));
                            final outPath = "${splitted}_out_${DateTime.now().toString().replaceAll(' ', '_')}${img.path.substring(lastIndex)}";
                            var image = await FlutterImageCompress.compressAndGetFile(img.path, outPath, quality: 75
                            );

                            context.read<ChatBloc>().add(SendMessage(
                              message: Message(
                                id: '', 
                                senderId: context.read<AuthBloc>().state.user!.uid, 
                                receiverId: widget.userMatch.userId, 
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
                      ): Padding(
                        padding: EdgeInsets.zero,
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              editMode = false;
                              tobeEdited = null;
                              msgController.clear();
                            });
                          },
                          child: Icon(Icons.cancel, color: Colors.grey[400],),
                        ),
                        ),
                        // suffix: Icon(
                        //   FontAwesomeIcons.paperclip,
                        //   color: Colors.grey,
                        //   size: 20,
                        // )
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
                    icon: editMode?Icon(Icons.edit, color: Colors.white,): Icon(FontAwesomeIcons.paperPlane,
                    color: Colors.white,
                    size: 20,
                    ),
                    onPressed: ()async{
                      if(msgController.text == ''){

                      }else{
                      if(editMode){
                        context.read<ChatBloc>().add(EditMessage(message: tobeEdited!, gender: context.read<AuthBloc>().state.accountType!, newMessage: msgController.text));
                        setState(() {
                          editMode =false;
                          tobeEdited = null;
                          msgController.clear();
                        });
                      }
                      //msg='';
                      if(!chatOpened){
                        //BlocProvider.of<MatchBloc>(context).add(OpenChat(message: Message(id: 'non', senderId: user.id, receiverId: context.read<AuthBloc>().state.user!.uid, message: msg, timestamp: DateTime.now())));
        
                        context.read<MatchBloc>().add(OpenChat(users: context.read<AuthBloc>().state.accountType! ,message: Message(id: 'id', senderId: context.read<AuthBloc>().state.user!.uid, receiverId: widget.userMatch.userId, message: msgController.text,  )));

                        context.read<ChatBloc>().add(FirstMessageSent(message: Message(id: 'id', senderId: context.read<AuthBloc>().state.user!.uid, receiverId: widget.userMatch.userId, message: msgController.text,  )));
                        chatOpened = true;
                        msgController.clear();
                      }else{
                      
                      context.read<ChatBloc>().add(SendMessage(users: context.read<AuthBloc>().state.accountType!, message: Message(id: 'id', senderId: context.read<AuthBloc>().state.user!.uid, receiverId: context.read<AuthBloc>().state.user!.uid == widget.userMatch.userId ? widget.userMatch.id! : widget.userMatch.userId, message: msgController.text, timestamp: Timestamp.fromDate(DateTime.now()) )));
                      msgController.clear();
                      }

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

  String groupMessages(DateTime? date){
    var todaydDate = DateTime.now();
    var today = DateTime(todaydDate.year, todaydDate.month, todaydDate.day );
    var yesterday = DateTime(todaydDate.year, todaydDate.month, todaydDate.day-1 );
    var aDate = null;
    if(date == null){
      aDate = DateTime.now();
    }else{
     aDate = DateTime(date.year, date.month, date.day );
    }

    if(aDate == today){
      return 'today';

    }else if(aDate == yesterday){
      return 'yesterday';
    }
    else{
      if(aDate.year == today.year){
        return DateFormat.MMMMd().format(aDate).toString();
      }
      return DateFormat.yMMMd().format(aDate).toString();
    }
  }

  void messagePressedMatch(BuildContext context, Message message, ) {
    showMenu(
      context: context, 
      position: relrectsize,
      items: [
        PopupMenuItem(
          onTap: (){
            Clipboard.setData(ClipboardData(text: message.message));
          

          },
          child: Row(children: [Icon(Icons.copy),SizedBox(width: 10,), Text('Copy') ],)
          ),
      ]
    );
  }

  void ImagePressed(BuildContext context, Message message, ) {
    showMenu(
      context: context, 
      position: relrectsize,
      items: [
        PopupMenuItem(
          //padding: EdgeInsets.all(0),
          height: 25,
         
          onTap: (){
           // Navigator.pop(context);
            
            //context.read<ChatBloc>().add(DeleteMessage(message: message, gender: context.read<AuthBloc>().state.accountType!));
          },
          child: GestureDetector(
            onTap: (){
              //Navigator.pop(context);
              showDialog(
              context: context, 
              builder: (ctx)=> AlertDialog(
                title: Text('Delete message'),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width*0.8,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(child: Text('Are you sure you want to delete this\nmessage?',textAlign: TextAlign.start, style: TextStyle(fontSize: 12.sp),)),
                      Row(
                        children: [
                          Checkbox(value: deleteAlso, 
                          onChanged: (value){
                            setState(() {
                              deleteAlso = value!;
                            });
                
                          }
                          ),
                          Text('Also delete for ${widget.userMatch.name}',style: TextStyle(fontSize: 11.sp))
                          ],)
                
                    ],
                  ),
                ),

                actions: [
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }, 
                    child: Text('cancel', style: TextStyle(color: Colors.teal),)
                    ),
                  TextButton(
                    onPressed: (){
                      context.read<ChatBloc>().add(DeleteMessage(message: message, gender: context.read<AuthBloc>().state.accountType!, deleteAlso: deleteAlso));
                      Navigator.pop(context);
                      Navigator.pop(context);

                    }, 
                    child: Text('Delete', style: TextStyle(color: Colors.red),)
                    ),
                  
                ],

              ) );

            },
            child: Row(children: [Icon(Icons.delete,size:18.sp ),SizedBox(width: 10,), Text('Delete', style: TextStyle(fontSize: 12.sp),) ],))
          ),
      ]
    );
  }

  void messagePressed(BuildContext context, Message message ) {
    showMenu(
      context: context, 
      position: relrectsize,
      items: [
        PopupMenuItem(
          onTap: (){
            Clipboard.setData(ClipboardData(text: message.message));
          

          },
          child: Row(children: [Icon(Icons.copy),SizedBox(width: 10,), Text('Copy') ],)
          ),
        
        PopupMenuItem(
          onTap: (){
            msgController.text = message.message;
            
            setState(() {
              editMode = true;
              tobeEdited = message;
            });
            FocusScope.of(context).requestFocus(focusNode);

          },
          child: Row(children: [Icon(Icons.edit),SizedBox(width: 10,), Text('Edit') ],)
          ),

        PopupMenuItem(
          value: 3,
          onTap: (){
           // Navigator.pop(context);
            
            //context.read<ChatBloc>().add(DeleteMessage(message: message, gender: context.read<AuthBloc>().state.accountType!));
          },
          child: GestureDetector(
            onTap: (){
              //Navigator.pop(context);
              showDialog(
              context: context, 
              builder: (ctx)=> AlertDialog(
                title: Text('Delete message'),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width*0.8,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(child: Text('Are you sure you want to delete this\nmessage?',textAlign: TextAlign.start, style: TextStyle(fontSize: 12.sp),)),
                      Row(
                        children: [
                          Switch(value: deleteAlso, 
                          onChanged: (value){
                           // setState(() {
                              deleteAlso = value!;
                           // });
                
                          }
                          ),
                          Text('Also delete for ${widget.userMatch.name}',style: TextStyle(fontSize: 11.sp))
                          ],)
                
                    ],
                  ),
                ),

                actions: [
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }, 
                    child: Text('cancel', style: TextStyle(color: Colors.teal),)
                    ),
                  TextButton(
                    onPressed: (){
                      context.read<ChatBloc>().add(DeleteMessage(message: message, gender: context.read<AuthBloc>().state.accountType!, deleteAlso: deleteAlso));
                      Navigator.pop(context);
                      Navigator.pop(context);

                    }, 
                    child: Text('Delete', style: TextStyle(color: Colors.red),)
                    ),
                  
                ],

              ) );

            },
            child: Row(children: [Icon(Icons.delete, ),SizedBox(width: 10,), Text('Delete') ],))
          ),

      ]
      );
  }

   // ↓ create the relativerect from size of screen and where you tapped
  RelativeRect get relrectsize => RelativeRect.fromSize(tapxy! & const Size(40,40), overlay!);

  void getPosition(TapDownDetails details) {
    tapxy = details.globalPosition;
  }

  String matchedTimecal(Timestamp timestamp){
    String result = '';
    if(DateTime.now().difference(timestamp.toDate()).inMinutes <60){
      result = '${DateTime.now().difference(timestamp.toDate()).inMinutes} minutes ago';
    }
    else 
    if(DateTime.now().difference(timestamp.toDate()).inHours <48){
      result = '${DateTime.now().difference(timestamp.toDate()).inHours} hour ago';
    }
    else{
      result = '${DateTime.now().difference(timestamp.toDate()).inDays} days ago';
    }


    return result;


    // ${DateTime.now().difference(widget.userMatch.timestamp!.toDate()).inMinutes <60?
    //                       DateTime.now().difference(widget.userMatch.timestamp!.toDate()).inMinutes:DateTime.now().difference(widget.userMatch.timestamp!.toDate()).inHours
    //                 } ${DateTime.now().difference(widget.userMatch.timestamp!.toDate()).inMinutes>60?'hours':'minutes'} ago
  }
}
 
        
      
    
   
  
