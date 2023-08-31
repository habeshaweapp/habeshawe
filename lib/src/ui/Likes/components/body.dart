import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lomi/src/Blocs/LikeBloc/like_bloc.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/ui/Likes/components/like_card.dart';

import '../../../Blocs/MatchBloc/match_bloc.dart';
import '../../../Blocs/PaymentBloc/payment_bloc.dart';
import '../../Profile/profile.dart';
import '../../chat/chatscreen.dart';
import '../../payment/payment.dart';
import 'likes_image.dart';
import '../../payment/showPaymentDialog.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    //final inactiveMatches = UserMatch.matches.where((match) => match.userId == 1 && match.chat!.isEmpty,).toList();
    //final activeMatches = UserMatch.matches.where((match) => match.userId == 1 && match.chat!.isNotEmpty,).toList();


    return SingleChildScrollView(
      child: BlocBuilder<LikeBloc, LikeState>(
        builder: (context, state) {
          if(state is LikeLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          
          if(state is LikeLoaded){
            return
           Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text("Likes", style: Theme.of(context).textTheme.bodyLarge,),
              ),
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
                    childAspectRatio: 0.66,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8
                    ) ,
                    physics: NeverScrollableScrollPhysics(), 
                    shrinkWrap: true,
                  
                  itemCount: state.likedMeUsers.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        showPaymentDialog(context);
                        BlocListener<PaymentBloc, PaymentState>(
                          listener: (context, stateP) {
                            // TODO: implement listener
                            if(state is NotSubscribed){
                              showPaymentDialog(context);
                            }
                            if(stateP is Subscribed){
                              //if(stateP.subscribtionType == 'ET-USER'){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(user: state.likedMeUsers[index].user)));

                              //}
                            }
                          },
                          child: Container(),
                        );
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(user: state.likedMeUsers[index].user)));
                        
                       //Navigator.push(context, MaterialPageRoute(builder: (context) => Payment() ));
                      },
                     
                      
                     child: LikeCard(user: state.likedMeUsers[index].user)
                      //LikesImage(url: state.likedMeUsers[index].user.imageUrls[0], height: 20,)
                      );
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