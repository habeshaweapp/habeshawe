import 'dart:developer';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lomi/src/ui/home/components/usercard.dart';

import '../../../Blocs/SwipeBloc/swipebloc_bloc.dart';
import '../../../dataApi/icons.dart';

class AppinioCard extends StatelessWidget {
  const AppinioCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppinioSwiperController();
    return BlocBuilder<SwipeBloc, SwipeState>(
      builder: (context, state) {
        if(state is SwipeLoading){
          return Center(child: CircularProgressIndicator());
        }

        if(state is SwipeLoaded){
          return 


          Column(
          children: [
            Expanded(
              child: Container(
               // margin: const EdgeInsets.only(top: 5),
                
                //height: MediaQuery.of(context).size.height * 0.865,
                width: MediaQuery.of(context).size.width,
                //margin: EdgeInsets.only(left: 25),
               
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  //color: Colors.black
                  
                  borderRadius: BorderRadius.circular(20)
                ),
            
                child: Stack(
                  children: [
                    Container(
                      
                      child: SizedBox(
              child: AppinioSwiper(
                backgroundCardsCount: 1,
                threshold: 100 ,
                maxAngle: 50,
                swipeOptions: const AppinioSwipeOptions.all(),
                unlimitedUnswipe: true,
                padding: EdgeInsets.all(0),
                controller: controller,
                onSwiping: (direction) {
                  debugPrint(direction.toString());
                },
                onSwipe: _swipe,
                onEnd: _onEnd,
                unswipe: _unSwipe,
                cardsCount: state.users.length,
            
                cardsBuilder: (context, index){
                  print(index);
                  return UserCard().userDrag(MediaQuery.of(context).size, state.users[index], context);
                }, 
                
                ),
                      )
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                color: Colors.transparent,
                
                child: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                List.generate(item_icons.length, (index) {
                  return InkWell(
                    onTap: (){
                      if(index == 1){controller.swipeLeft();
                      }
                      if(index == 3){controller.swipeRight();}
                      if(index == 2){controller.swipeUp();
                      }
                      if(index == 0){}
                      if(index == 4){ controller.unswipe();}
                    },
                    child: Container(
                      width: item_icons[index]['size'],
                      height: item_icons[index]['size'],
                      decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black12,
              
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
                  )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),

            
          ],
        );
        }
        else{
          return Center(child: Text('something went wrong...'),);
        }

        
      },
    );
  }

  void _swipe(int index, AppinioSwiperDirection direction) {
    log('the card is swiped to the : ' + direction.name);
  }

  void _onEnd() {
    log("end reached!");
  }

  void _unSwipe(bool unswiped) {
    if(unswiped){
      log('SUCCESS: card was unswiped');
    }else{
      log("FAIL: no card left to unswipe");
    }
  }
}