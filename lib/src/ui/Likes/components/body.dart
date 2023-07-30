import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lomi/src/Data/Models/model.dart';

import '../../../Blocs/MatchBloc/match_bloc.dart';
import '../../Profile/profile.dart';
import '../../chat/chatscreen.dart';
import 'likes_image.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    //final inactiveMatches = UserMatch.matches.where((match) => match.userId == 1 && match.chat!.isEmpty,).toList();
    //final activeMatches = UserMatch.matches.where((match) => match.userId == 1 && match.chat!.isNotEmpty,).toList();


    return SingleChildScrollView(
      child: BlocBuilder<MatchBloc, MatchState>(
        builder: (context, state) {
          if(state is MatchLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          
          if(state is MatchLoaded){
            return
           Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Likes", style: Theme.of(context).textTheme.bodyLarge,),
              SizedBox(height: 10,),
      
              // SizedBox(
              //   //height: 150,
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     scrollDirection: Axis.vertical,
              //     itemCount: inactiveMatches.length,
              //     itemBuilder: (context, index){
              //       return LikesImage(url: state.likedMeUsers[index].imageUrls[0], height: 120, width: 100,);
              //     }
              //     ),
              // ),
              

              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: GridView.builder(
                  
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.66
                    ) ,
                    physics: NeverScrollableScrollPhysics(), 
                    shrinkWrap: true,
                  
                  itemCount: state.likedMeUsers.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                       // Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(likeUser: state.likedMeUsers[index])));
                      },
                      
                      child: LikesImage(url: state.likedMeUsers[index].imageUrls[0], height: 20,));
                  } ),
              ),
              
              
             // SizedBox(height: 25,),
      
              
      
      
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