import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';

import '../report/report.dart';
import 'components/body.dart';
import 'components/bottomsendmessage.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen(this.userMatch, {super.key});
  final UserMatch userMatch;


  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
       // backgroundColor: Colors.white.withOpacity(0.8),
       backgroundColor: isDark? Color.fromARGB(255, 22, 22, 22):null,
        elevation: 0,
        //toolbarHeight: 100,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            icon: Icon(Icons.arrow_back, color: !isDark ? Colors.black.withOpacity(0.7) : Colors.white),
            ),
          ),
        title: Row(
          
          children: [
            CircleAvatar(
                radius: 20,
                backgroundImage: CachedNetworkImageProvider(userMatch.imageUrls[0]),                       
              ),
           
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userMatch.name,style: Theme.of(context).textTheme.bodyMedium,),
                  
                  StreamBuilder(
                    stream: context.read<DatabaseRepository>().onlineStatusChanged(userId: userMatch.userId, gender: userMatch.gender),
                    builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String,dynamic>>> snapshot) {
                      if(snapshot.hasError){
                        return SizedBox();
                      }
                      if(snapshot.hasData){

                      return snapshot.data?['showstatus'] ? snapshot.data!['online']? Row(
                        children: [
                          
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              shape:  BoxShape.circle,
                              color: Colors.green,
                              border: Border.all(
                                width: 2,
                                color: isDark? Color.fromARGB(255, 22, 22, 22): Colors.white,
                              )
            
                            ),
                          ),
                          SizedBox(width: 3,),
                          Text('Active now', style: 
                          //Theme.of(context).textTheme.bodySmall,
                          TextStyle(color: Colors.grey, fontSize: 12
                          ),
                          )
                        ],
                      ):

                      Text(
                        'last Seen ${DateFormat('hh:mm a').format(snapshot.data?['lastseen'].toDate())}',
                        style: Theme.of(context).textTheme.bodySmall,
                        ): const Text('last seen recently', style: TextStyle(fontSize: 12, color: Colors.grey));
                      

                    }else{
                      return Text('updating...',
                          style: TextStyle(color: Colors.grey, fontSize: 12
                          ),
                      );
                    }




                    }
                  )
            
            
                ],),
            )
          ],
        ),
       // leading: Icon(Icons.arrow_back_ios_new, color: Colors.black,),
       actions: [
        IconButton(
         onPressed: (){
          showbottomchatoptions(context);
         },
            // PopupMenuButton(
            //   onSelected: (value){
                
            //   },
            //   itemBuilder: (context){
            //     return const [
            //       PopupMenuItem(
            //         child: Text('UnMatch')
            //         ),
                  
            //       PopupMenuItem(
            //         child: Text('Bloc and Report')
            //         )

            //     ];
            //   }
              // )
          
          
          icon: Icon(Icons.more_vert, color: isDark? Colors.white : Colors.black ))
       ],
       systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor:isDark? Color.fromARGB(255, 22, 22, 22) : Colors.white,
        systemNavigationBarIconBrightness:isDark?Brightness.light: Brightness.dark,
      ),
      ),
      body: Body(userMatch),

      //bottomNavigationBar: BottomSendMessage(userMatch) ,
    );
    
  }

  void showbottomchatoptions(BuildContext context){
    showModalBottomSheet(
      context: context,
      builder: ((ctx) {
        return SizedBox(
          height: 120,
          child: Column(
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      showUnMatchSheet(context, userMatch);
                     
              
                    },
                    child: Center(child: Text('UnMatch')),
                  )
                ),
              ),

              Divider(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      showReportOptions(context, userMatch);
              
                    },
                    child: Center(child: Text('Block And Report')),
                  )
                ),
              ),
            ]
          ),
        );
        
      }
    ));
  }


   void showUnMatchSheet(BuildContext context, UserMatch userMatch){
    showModalBottomSheet(
      context: context,
      builder: ((ctx) {
        return SizedBox(
          height: 290,
          child: Column(
            children: [
              //SizedBox(height: 20,),
              Container(
                color: Colors.green,
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text('Unmatch this person', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 18),),
                    )
                    ,Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      child: Text(
                        
                   '''when you unmatch someone, you\n won't be able to contact each other\n and you wont't see each other/'s profiles.\n if unmatching someone isn't enough,\nwe'd urge you to block and report them\n - your safty comes first''',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                      ),
                    )
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Center(
                  child: InkWell(
                    onTap: (){
                      showDialog(
                        context: context, 
                        builder: (ctx)=> AlertDialog(
                          title: const Text('Are you sure?'),
                          content: const Text('This can\'t be undone!'),
                          actions: [
                            TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                               child: Text('No')),

                             TextButton(
                              onPressed: (){
                                context.read<ChatBloc>().add(UnMatch(
                                  userId: context.read<AuthBloc>().state.user!.uid, 
                                  gender: context.read<AuthBloc>().state.accountType!, 
                                  matchUser: userMatch
                                  ));

                                   Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                              },
                               child: Text('Yes')), 
                          ],
                        ));
              
                    },
                    child: Center(child: Text('UnMatch')),
                  )
                ),
              ),

              Divider(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      showReportOptions(context, userMatch);
              
                    },
                    child: Center(child: Text('Unmatch And Report')),
                  )
                ),
              ),

              
            ]
          ),
        );
        
      }
    ));
  }

  void showReportOptions(BuildContext context, UserMatch userMatch){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: ((ctx) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.66,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Column(
                children: [
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:30),
                    child: Text('Bloc and report this person',
                        style: TextStyle(fontSize: 18),
                    ),
                    ),
                    Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text('Don\'t worry, your feedback is anonymous and\n they won\'t know that you\'ve blocked or reported them.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall,
                                ),
                    ),
                    SizedBox(height: 10,),
                    const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Report(matchedUser: userMatch, index: 0,name:'Fake Profile', ctx: context,) ));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.person_off, color: Colors.green,),
                          SizedBox(width: 10,),
                          Text('Fake profile')
                        
                        ]
                        ),
                    ),
                  ),

                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> Report(matchedUser: userMatch,index: 1,name:'Rude or abusive behavior', ctx: context,) ));
                      },
                      child: Row(children: [
                        Icon(Icons.chat_bubble, color: Colors.green),
                        SizedBox(width: 10),
                        Text('Rude or abusive behavior')
                        
                        ]
                        ),
                    ),
                  ),

                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Report(matchedUser: userMatch, index: 2,name:'Inappropriate content',ctx: context,) ));
                      },
                      child: Row(children: [
                        Icon(Icons.warning, color:Colors.green),
                        SizedBox(width: 10,),
                        Text('Inappropriate content')
                        
                        ]
                        ),
                    ),
                  ),
                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Report(matchedUser: userMatch,index: 3,name:'Scam or commercial',ctx: context,) ));
                      },
                      child: Row(children: [
                        Icon(Icons.flag, color:Colors.green),
                        SizedBox(width: 10),
                        Text('Scam or commercial')
                        
                        ]
                        ),
                    ),
                  ),
                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Report(matchedUser: userMatch,index: 4,name:'Identity-based hate',ctx: context,) ));
                      },
                      child: Row(children: [
                        Icon(Icons.record_voice_over, color: Colors.green),
                        SizedBox(width: 10),
                        Text('Identity-based hate')
                        
                        ]
                        ),
                    ),
                  ),
                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Report(matchedUser: userMatch,index: 5,name:'Off Habeshawi behavior',ctx: context,) ));
                      },
                      child: Row(children: [
                        Icon(Icons.block, color:Colors.green),
                        SizedBox(width: 10),
                        Text('Off Habeshawi behavior')
                        
                        ]
                        ),
                    ),
                  ),
                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Report(matchedUser: userMatch,index: 6,name:'Underage',ctx: context,) ));
                      },
                      child: Row(children: [
                        Icon(Icons.access_time_filled_sharp, color:Colors.green),
                        SizedBox(width: 10),
                        Text('Underage')
                        
                        ]
                        ),
                    ),
                  ),
                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (contextb)=> BlocProvider.value(
                            value: context.read<ChatBloc>(),
                            child: Report(matchedUser: userMatch, index: 7,name:'Too Much beautiful...',ctx: context,),
                          ) ));
                      },
                      child: Row(children: [
                        Icon(Icons.emoji_emotions, color:Colors.green),
                        SizedBox(width: 10),
                        Text('Too Much beautiful...')
                        
                        ]
                        ),
                    ),
                  ),
                ]
              ),
            ],
          ),
        );
        
      }
    ));
  }


}