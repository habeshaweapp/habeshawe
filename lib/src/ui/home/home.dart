import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Models/userpreference_model.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/Data/Repository/Notification/notification_service.dart';
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
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if(context.read<UserpreferenceBloc>().state.userPreference!.onlineStatus!){

    if(state == AppLifecycleState.resumed){
      //online
      context.read<DatabaseRepository>().updateOnlinestatus(
        userId: context.read<AuthBloc>().state.user!.uid, 
        gender: context.read<AuthBloc>().state.accountType!, 
        online: true
        );

    }
    if(state == AppLifecycleState.paused || state == AppLifecycleState.inactive){
      //offline
      context.read<DatabaseRepository>().updateOnlinestatus(
        userId: context.read<AuthBloc>().state.user!.uid, 
        gender: context.read<AuthBloc>().state.accountType!, 
        online: false
        );

    }

    }
  }

  listenToNotification(){
    NotificationService.onClickNotification.stream.listen((payload) {
      if(payload == 'chat'){
        setState(() {
          pageIndex = 2;
        });
      }
      
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  int pageIndex = 0;
 
  
  @override
  Widget build(BuildContext context) {
     bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: appBar(isDark),
      body: HomeBody(),
    );

    
  }

  AppBar appBar(bool isDark) {
    //bool isDark = Theme.of(context).brightness == Brightness.dark;
    var items = [
      pageIndex == 0 ? 'assets/images/explore_active_icon.svg' :'assets/images/explore_icon.svg',
      pageIndex == 1 ? 'assets/images/likes_active_icon.svg' :'assets/images/likes_icon.svg',
      pageIndex == 2 ? 'assets/images/chat_active_icon.svg' :'assets/images/chat_icon.svg',
      pageIndex == 3 ? 'assets/images/account_active_icon.svg' :'assets/images/account_icon.svg',

    ];

    var icons = [
      Icon(Icons.home, color: pageIndex == 0?isDark? Colors.white: Colors.black: Colors.grey ,size: 27,),
      Icon(Icons.home, color: pageIndex == 0?isDark? Colors.white: Colors.black: Colors.grey ,size: 27,),
      Icon(LineIcons.facebookMessenger , color: pageIndex == 2?isDark? Colors.white: Colors.black: Colors.grey ,size: 27,),
      Icon(Icons.person, color: pageIndex == 3?isDark? Colors.white: Colors.black: Colors.grey ,size: 27,),
      
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
            return IconButton(
              onPressed: (){
                setState(() {
                  pageIndex = index;
                });
              }, 
              icon: index == 1?SvgPicture.asset(items[index],height: 27, width: 27, ): icons[index]
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