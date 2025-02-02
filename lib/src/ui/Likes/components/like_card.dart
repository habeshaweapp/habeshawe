import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lomi/src/Blocs/InternetBloc/internet_bloc.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/Data/Models/tag_helper.dart';

import '../../../Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import '../../../Blocs/PaymentBloc/payment_bloc.dart';
import '../../../Data/Models/likes_model.dart';
import 'package:blur/blur.dart';

import '../../../Data/Repository/Database/database_repository.dart';

class LikeCard extends StatelessWidget {
  final Like like;
  final bool showAd;
  const LikeCard({super.key, required this.like, required this.showAd});

  @override
  Widget build(BuildContext context) {
    var isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    return  Container(
        height: 150,
        width: 120,
        //margin: EdgeInsets.only(top: 8, left: 8),
        decoration: BoxDecoration(
          image: DecorationImage(
            //opacity: 1,
            //colorFilter: ColorFilter.mode(Colors.grey[900]!, BlendMode.modulate),
            image: CachedNetworkImageProvider(
              like.user.imageUrls[0],
              errorListener: (error) {
                if(context.read<InternetBloc>().state.isConnected == true){
                    context.read<DatabaseRepository>().changeMatchImage(
                                userId: context.read<AuthBloc>().state.user!.uid, 
                                userGender: context.read<AuthBloc>().state.accountType!,
                                match: {
                                  'id': like.userId,
                                  'gender': like.user.gender,
                                  'imageUrls':like.user.imageUrls
                                }, 
                                from: 'likes');
                          
                }
                
              },
              ),
            fit: BoxFit.cover,
            
            //opacity: 0.7,
            
            
            ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: !isDark?Colors.grey[300]: Colors.grey[800],
      
      
        ),
        child: 
          
          Stack(
            children: [
              Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                            gradient: LinearGradient(
                              colors: [
                                like.superLike!? Colors.blue:Color.fromARGB(200, 0, 0, 0),
                                //Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0),
                                
                                  
                            ],
                                  
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            
                            )
                          ),
                        ),
                      ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  
                  Text('${like.user.name}, ${like.user.age}',
                      style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 5.w,),
                  (like.user.verified != VerifiedStatus.notVerified.name && like.user.verified != VerifiedStatus.pending.name &&like.user.verified !=null)?
                   TagHelper.getTag(name: like.user.verified??'not',size: 20):const SizedBox(),
                  
                ]),
            ),
          ),
      
          Align(
            alignment: Alignment.bottomRight,
            child: like.superLike!? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.star,color: Colors.blue, size: 35,),
            ): SizedBox(),
            ),
      
         context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER? showAd? SizedBox(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Watch Ad', style: TextStyle(color: Colors.white,fontSize: 12.sp),),
                ),
              ),
            ),
          ): const SizedBox(): const SizedBox(),

          context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.notSubscribed?
          Center(
            child: ClipRRect(
              borderRadius:BorderRadius.all(Radius.circular(10)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY:10.0),
                  child: Container(
                  
                  )
                )
            ),
          ):const SizedBox()
        ],
      
      
        ),
      
      
    );
  }
}