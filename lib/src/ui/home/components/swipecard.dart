import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lomi/src/ui/home/components/usercard.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../../Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import '../../../Blocs/SwipeBloc/swipebloc_bloc.dart';
import '../../../Data/Repository/Authentication/auth_repository.dart';
import '../../../dataApi/icons.dart';

class SwipeCard extends StatelessWidget {
  const SwipeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwipeBloc, SwipeState>(
      builder: (context, state) {
        if(state is SwipeLoading){
          return Center(child: CircularProgressIndicator() );
        }
        if(state is SwipeLoaded){
          List<SwipeItem> _swipeItems = [];
          MatchEngine? _matchEngine;
          //state.users.forEach((user)
          for(var user in state.users)
           {
            _swipeItems.add(
              SwipeItem(
                content: user,
                likeAction: (){
                //   context.read<SwipeBloc>().add(
                // SwipeLeftEvent(
                //   userId: context.read<AuthBloc>().state.user!.uid,
                //   user: state.users[0]));

                },
                nopeAction: (){
                //   context.read<SwipeBloc>().add(
                // SwipeLeftEvent(
                //   userId: context.read<AuthBloc>().state.user!.uid,
                //   user: state.users[0]));
                },
                onSlideUpdate: (SlideRegion? region) async {
                  print("Region $region");
             },
                superlikeAction: (){
                //   context.read<SwipeBloc>().add(
                // SwipeLeftEvent(
                //   userId: context.read<AuthBloc>().state.user!.uid,
                //   user: state.users[0]));
                }
              )
            );
          }

          _matchEngine = MatchEngine(swipeItems: _swipeItems);
          //_matchEngine!.cycleMatch();
          MatchEngine backUp = _matchEngine;
        return Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.79,
              //width: MediaQuery.of(context).size.width,
              //margin: EdgeInsets.only(left: 25),
             
              alignment: Alignment.center,
              decoration: BoxDecoration(
                //color: Colors.black
                borderRadius: BorderRadius.circular(20)
              ),

              child: Stack(
                children: [
                  Container(
                    
                    child: SwipeCards(
                      matchEngine: _matchEngine, 
                      onStackFinished: (){
                        //_matchEngine = backUp;
                        //_matchEngine!.cycleMatch();
                      }, 
                      itemBuilder: (context, index){
                        return UserCard().userDrag(MediaQuery.of(context).size, _swipeItems[index].content, context);
                      },
                      leftSwipeAllowed: true,
                      rightSwipeAllowed: true,

                      likeTag: Container(
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green,width: 5),
                          borderRadius: BorderRadius.circular(10)
                          

                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('LIKE', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 35),),
                        ),
                      ),

                      nopeTag: Container(
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 5),
                          borderRadius: BorderRadius.circular(10)

                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('NOPE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 35),),
                        ),
                      ),

                      superLikeTag: Container(
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 5),
                          borderRadius: BorderRadius.circular(10)

                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('SUPER\nLIKE',textAlign: TextAlign.center, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),),
                        ),
                      ),
                      ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),

            Container(
    //width: size.width,
    //height: 120,
    //decoration: BoxDecoration(color: Colors.brown),
    
    child: Padding(
  padding: const EdgeInsets.only(bottom: 2),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children:
    List.generate(item_icons.length, (index) {
      return InkWell(
        onTap: (){

          if(index == 1){
            _matchEngine!.currentItem?.nope();
          }
          // if(index == 0){
          //   context.read<AuthRepository>().signOut();
          // }
          if(index == 3){
            _matchEngine!.currentItem?.like();
          }

          if(index == 3){
            _matchEngine!.currentItem?.superLike();
          }
          

          if(index == 0){
            //context.read<AuthRepository>().signOut();
            _matchEngine!.rewindMatch();
          }
        },
        child: Container(
          width: item_icons[index]['size'],
          height: item_icons[index]['size'],
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 10,
              )
            ]
          ),
      
          child: Center(
            child: SvgPicture.asset(
              item_icons[index]['icon'],
              width: item_icons[index]['icon_size'],
              
              ),
          ),
      
        ),
      );

    }),
  ),
    ),

  ),
          ],
        );


        }else{
          return Center(child: Text('Get back after a while...'));
        }
      },
    );
  }
}