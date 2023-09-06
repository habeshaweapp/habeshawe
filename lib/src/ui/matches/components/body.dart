import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Blocs/ChatBloc/chat_bloc.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';

import '../../../Blocs/MatchBloc/match_bloc.dart';
import '../../chat/chatscreen.dart';
import 'chat_list.dart';
import 'matches_image_small.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
   // final inactiveMatches = UserMatch.matches.where((match) => match.userId == 1 && match.chat!.isEmpty,).toList();
   // final activeMatches = UserMatch.matches.where((match) => match.userId == 1 && match.chat!.isNotEmpty,).toList();


    return SingleChildScrollView(
      child: BlocBuilder<MatchBloc, MatchState>(
        builder: (context, state) {
          if(state is MatchLoading){
            return Center(child: CircularProgressIndicator(),); 
          }
          
          if(state is MatchLoaded){
            final inactiveMatches = state.matchedUsers.where((match) => !match.chatOpened).toList();
            final activeMatches = state.matchedUsers.where((match) => match.chatOpened).toList(); 
            return
           Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20),
                child: Text("New Matches", style: Theme.of(context).textTheme.bodyLarge,),
              ),
              SizedBox(height: 10,),
      
              Padding(
                padding: const EdgeInsets.only(left:0.0),
                child: SizedBox(
                  height: 150,
                  child: inactiveMatches.length !=0 ? ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: inactiveMatches.length,
                    itemBuilder: (context, index){
                      return GestureDetector(
                        onTap: (){Navigator.push(context,MaterialPageRoute(builder: (context) => ChatScreen(inactiveMatches[index])));},
                        child: MatchesImage(url: inactiveMatches[index].imageUrls[0], height: 120, width: 100,));
                    }
                    ):
                    Padding(
                      padding: const EdgeInsets.only(left:20.0),
                      child: Container(
                                      height: 150,
                                      width: 120,
                                      decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Center(child: Text('New matches\nwill appear\n here',textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 10,fontWeight: FontWeight.w300),)),
                      ),
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0, left: 28),
                child: Text("Likes", style: Theme.of(context).textTheme.bodyLarge,),
              ),
              
              SizedBox(height: 25,),
      
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Messages", style: Theme.of(context).textTheme.bodyLarge,),
              ),
              SizedBox(height: 25,),
              ListView.builder(
                shrinkWrap: true,
                itemCount: activeMatches.length,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      context.read<ChatBloc>().add(LoadChats(userId: context.read<AuthBloc>().state.user!.uid, users: context.read<AuthBloc>().state.accountType! , matchedUserId: activeMatches[index].userId));
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(activeMatches[index]) ));
                    },
                    child: ChatList(match: activeMatches[index])
                    
                    
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 10.0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       MatchesImage(url: activeMatches[index].imageUrls[0],
                    //        height: 60,width: 60,shape: BoxShape.circle,),
                    //        Padding(
                    //          padding: const EdgeInsets.all(8.0),
                    //          child: Column(
                              
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //            children: [
                    //             SizedBox(height: 5,),
                    //              Text(activeMatches[index].name,
                    //                   style: Theme.of(context).textTheme.bodyLarge,
                                 
                    //              ),
                    //             const SizedBox(height: 5,),

                                
                                  //width: double.infinity,
                            //  StreamBuilder(
                            //         stream: DatabaseRepository().getLastMessage(activeMatches[index].userId, activeMatches[index].userId),
                            //         //context.read()<DatabaseRepository>().getLastMessage,
                            //         builder: (context, AsyncSnapshot<List<Message>> snapshot) {
                            //           return 
                            //           Row(
                            //             //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //             //mainAxisSize: MainAxisSize.max,
                            //             children: [
                            //               // Container(
                            //               //   width: MediaQuery.of(context).size.width * 0.4,
                            //               //   child: Text(
                            //               //     snapshot.data.isNotEmpty? snapshot.data?[0].message ?? '', 
                            //               //     overflow: TextOverflow.ellipsis, 
                            //               //     softWrap: true, 
                            //               //    // maxLines: 1,
                            //               //     ),
                            //               // ),
                            //               SizedBox(width: MediaQuery.of(context).size.width * 0.06,),
                            //               Text('${snapshot.data?[0].timestamp.hour}:${snapshot.data?[0].timestamp.minute} PM')
                            //             ],
                            //           );
                                      
                            //         }
                            //       ),
                              
                                               
                                //   Text(
                                //     'Hello from the other side',

                                //    // activeMatches[index].chat,
                                //     //activeMatches[index].chat![0].messages[0].message,
                                //       style: Theme.of(context).textTheme.bodySmall,
                                 
                                //  ),
                                //  const SizedBox(height: 5,),
                                //  Text(
                                //   activeMatches[index].chat,
                                //   //activeMatches[index].chat![0].messages[0].timeString,
                                //       style: Theme.of(context).textTheme.bodySmall,
                                 
                              //     )
                              //  ],
                          //    );
                          //  ),
                          //  Spacer(),

                          //  Padding(
                          //    padding: const EdgeInsets.only(top: 15.0),
                          //    child: Text('7:03 PM',
                          //    style: Theme.of(context).textTheme.bodySmall,
                          //    ),
                          //  )
                    //     ],
                    //   ),
                    // ),
                  );
                })
      
      
            ]),
          );

          }else{
            return Text('something went wrong...');
          }
        },
      ),
      );
    
  }
}