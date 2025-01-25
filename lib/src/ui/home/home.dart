import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Blocs/InternetBloc/internet_bloc.dart';
import 'package:lomi/src/Blocs/SharedPrefes/sharedpreference_cubit.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/Data/Models/userpreference_model.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/Data/Repository/Notification/notification_service.dart';
import 'package:lomi/src/Data/Repository/SharedPrefes/sharedPrefes.dart';
import 'package:lomi/src/ui/Likes/likes.dart';
import 'package:lomi/src/ui/home/ExplorePage.dart';
import 'package:lomi/src/ui/matches/matches_screen.dart';
import 'package:lomi/src/ui/onboarding/onboardAllScreens.dart';

import '../../Blocs/UserPreference/userpreference_bloc.dart';
import '../UserProfile/userprofile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {

  @override
  void initState() {
    // TODO: implement initState
    listenToNotification();
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    //  if(SharedPrefes.getFirstLogIn() == true){
    //       SharedPrefes.setFirstLogIn(false);
    //     }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.paused || state == AppLifecycleState.resumed){
      if(context.read<ProfileBloc>().state is ProfileLoaded){
        if(context.read<SharedpreferenceCubit>().howManyRequests <5){
      context.read<SharedpreferenceCubit>().checkLocationChange((context.read<ProfileBloc>().state as ProfileLoaded).user.location!);
        }
      //context.read<ProfileBloc>().add(UpdateLocation());
      }
    }
 

    if(context.read<UserpreferenceBloc>().state.userPreference?.onlineStatus!??false){

    if(state == AppLifecycleState.resumed){
      //online
      // context.read<DatabaseRepository>().updateOnlinestatus(
      //   userId: context.read<AuthBloc>().state.user!.uid, 
      //   gender: context.read<AuthBloc>().state.accountType!, 
      //   online: true
      //   );
      context.read<AuthBloc>().add(const ActivityStatus(active: true));
      
     

    }
    else if(state == AppLifecycleState.paused){
      context.read<AuthBloc>().add(const ActivityStatus(active: false));
      
      //offline
      // context.read<DatabaseRepository>().updateOnlinestatus(
      //   userId: context.read<AuthBloc>().state.user!.uid, 
      //   gender: context.read<AuthBloc>().state.accountType!, 
      //   online: false
      //   );

      // FlutterBackgroundService().invoke('activityStatus',
      //       {
      //         'userId': context.read<AuthBloc>().state.user!.uid, 
      //         'gender': context.read<AuthBloc>().state.accountType!.index, 
      //         'online': false
      //       });

      // FlutterBackgroundService().sendData(
      //       {
      //         'action':'activityStatus',
      //         'userId': context.read<AuthBloc>().state.user!.uid, 
      //         'gender': context.read<AuthBloc>().state.accountType!.index, 
      //         'online': false
      //       });

        

       

    }

    }

    if(state == AppLifecycleState.resumed){
       SharedPrefes.setAppState(true);
      SharedPrefes.setInBackground(false);

    }else{
      SharedPrefes.setAppState(false);
      SharedPrefes.setInBackground(true);
      if(state == AppLifecycleState.paused){
      if(SharedPrefes.getFirstLogIn() == true){
        SharedPrefes.setFirstLogIn(false);
      }
      }

    }
  }

  listenToNotification(){
    listNav= NotificationService.onClickNotification.stream.listen((payload) {
      if(payload == 'chat'){
        setState(() {
          pageIndex = 2;
        });
        NotificationService.onClickNotification.add('home');
      }

      if(payload == 'like'){
        setState(() {
          pageIndex = 1;
        });
        NotificationService.onClickNotification.add('home');
      }

      
      
    });
  }

  StreamSubscription? listNav;

  @override
  void dispose() { 
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    listNav?.cancel();
    super.dispose();
  }


  int pageIndex = 0;
 
  
  @override
  Widget build(BuildContext context) {
     bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: appBar(isDark),
      body: 
      //HomeBody()
       BlocConsumer<InternetBloc,InternetStatus>(
        listener: (context, state) {
          if(state.isConnected==false){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No Connection...',style: TextStyle(fontSize: 11.sp,color: Colors.white), ),backgroundColor: Colors.black38, duration: Duration(seconds: 60),));

          }
          if(state.isConnected == true){
            context.read<SwipeBloc>().add(CheckLastTime());
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        },
        //buildWhen: (previous, current) => (previous.isConnected == false&&current.isConnected==true),
        builder: (context,state) {
          return HomeBody();
        }
      ),
    );

    
  }

  AppBar appBar(bool isDark) {
    //bool isDark = Theme.of(context).brightness == Brightness.dark;
    var items = [
      'assets/images/home_active.png',
      pageIndex == 1 ? 'assets/images/likes_active_icon.svg' :'assets/images/likes_icon.svg',
      pageIndex == 2 ? 'assets/images/chat_icon.svg' :'assets/images/chat_icon.svg',
      pageIndex == 3 ? 'assets/images/account_active_icon.svg' :'assets/images/account_icon.svg',

    ];

    var icons = [
      Icon(Icons.home, color: pageIndex == 0?isDark? Colors.white: Colors.black: Colors.grey ,size: 27,),
      Icon(Icons.home, color: pageIndex == 0?isDark? Colors.white: Colors.black: Colors.grey ,size: 27,),
      Icon(LineIcons.facebookMessenger , color: pageIndex == 2?isDark? Colors.white: Colors.black: Colors.grey ,size: 27,),
      Icon(Icons.person, color: pageIndex == 3?isDark? Colors.white: Colors.black: Colors.grey ,size: 28.sp,),
      
    ];
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: null,
      automaticallyImplyLeading: false,
      elevation: 0,
      systemOverlayStyle: 
     // isDark? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      SystemUiOverlayStyle(
        systemNavigationBarColor: isDark? Color.fromARGB(255, 22, 22, 22): Colors.white, //Color.fromARGB(51, 182, 180, 180)
        systemNavigationBarIconBrightness: !isDark? Brightness.dark: Brightness.light,
      ),
      title: Padding(
        padding:  EdgeInsets.only(left: 10.w, right: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(items.length, (index) {
            Widget icn = SizedBox();

            if(index == 0){
               icn = Image.asset(items[index], height: 22.sp, width: 22.sp,color:pageIndex == 0?isDark?Colors.white:Colors.black: Colors.grey,);

            }else if(index == 1){
             // icn = SvgPicture.asset(items[index] );
              icn = Stack(
                alignment: Alignment.topRight,
                children: [
                  SvgPicture.asset(items[index],height: isDark?28.sp:32.sp, ),
                  
                  StreamBuilder(
                    stream: SharedPrefes.newLike,
                    builder: (context,AsyncSnapshot<String> snapshot){
                      if(snapshot.hasError){
                        return SizedBox();
                      }
                      if(snapshot.hasData){
                        if(snapshot.data == 'newLike'){
                          return Container(
                                            height: 6,
                                            width: 6,
                                            decoration: BoxDecoration(
                                              shape:  BoxShape.circle,
                                              color: Colors.red,
                                              
                            
                                            ),
                                          
                                  );
                        }else{
                          return const SizedBox();
                        }
                      }else{
                        return const SizedBox();
                      }
                    },
                  )
                  
                 
                 ],
              );
            }
            else if(index == 2){
              icn = Stack(
                alignment: Alignment.topRight,
                children: [
                 SvgPicture.asset(items[index],
                  height: 21.sp, width: 21.sp,
                  colorFilter:pageIndex == 2? ColorFilter.mode(isDark?Colors.white:Colors.black, BlendMode.srcIn):null, 
                 ),
                 StreamBuilder(
                    stream: SharedPrefes.newMessage,
                    builder: (context, AsyncSnapshot<String> snapshot){
                      if(snapshot.hasError){
                        return SizedBox();
                      }
                      if(snapshot.hasData){
                        if(snapshot.data == 'newMessage'){
                          return Container(
                                            height: 6,
                                            width: 6,
                                            decoration: BoxDecoration(
                                              shape:  BoxShape.circle,
                                              color: Colors.red,
                                              
                            
                                            ),
                                          
                                  );
                        }else{
                          return const SizedBox();
                        }
                      }else{
                        return const SizedBox();
                      }
                    },
                  )
                 
                 ],
              );
            }
            else if(index == 3){
              icn = icons[index];
            }
            return IconButton(
              onPressed: (){
                setState(() {
                  pageIndex = index;
                });
                if(index == 1){
                  int temp = SharedPrefes.getTempLikesCounts()??-1;
                  if(temp != -1){
                    SharedPrefes.setLikesCount(temp);
                    SharedPrefes.setTempLikesCount(-1);
                  }
                  SharedPrefes.newLike.add('null');
                }
                if(index == 2){
                  SharedPrefes.newMessage.add('null');
                }
              }, 
             // icon: index != 0?SvgPicture.asset(items[index],height: 27, width: 27, ): Image.asset(items[index], height: 23, width: 27, )
             icon: icn,
              );

          })
        ),
      ),

    );
  }


Widget HomeBody(){
  return IndexedStack(
    index: pageIndex,
    children: const  [
       ExplorePage(),
       LikesScreen(),
       MatchesScreen(),
       UserProfile() 
    ],
  );
}
}