import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';

import '../../../Blocs/PaymentBloc/payment_bloc.dart';
import '../../../Data/Models/enums.dart';
import '../../../Data/Models/tag_helper.dart';
import '../../../Data/Models/usermatch_model.dart';

class MatchesImage extends StatelessWidget {
  final UserMatch? match;
  final String? url;
  final double height;
  final double width;
  final BoxShape shape;

  const MatchesImage({
    Key? key,
    this.match,
   this.url,
    this.height = 150,
    this.width = 120,
    this.shape = BoxShape.rectangle,
});

  @override
  Widget build(BuildContext context) {
    var isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    return Container(
              height: height,
              width: width,
              margin: EdgeInsets.only(top: 8, left: 8, ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(match?.imageUrls[0]??url)
                  //NetworkImage(url)
                  ),
                  borderRadius: shape == BoxShape.rectangle? BorderRadius.all(Radius.circular(10)):null,
                  //border: Border.all(width: 1, color: Colors.green.withOpacity(0.3)),
                  shape: shape,
                  color: !isDark?Colors.grey[300]: Colors.grey[800],

              ),

              child: match !=null? Stack(
        children: [
          Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8)),
                          gradient: LinearGradient(
                            colors: [
                              match!.superLike??false? Colors.blue:Color.fromARGB(200, 0, 0, 0),
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
          padding: const EdgeInsets.all(4.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Text('${match!.name}',
                    style: TextStyle(color: Colors.white, fontSize: 11.sp),
                ),
                SizedBox(width: 5.w,),
                (match!.verified != VerifiedStatus.notVerified.name && match!.verified != VerifiedStatus.pending.name && match!.verified !=null)?
                 TagHelper.getTag(name: match!.verified??'not',size: 20):const SizedBox(),
                
              ]),
          ),
        ),

        Align(
          alignment: Alignment.bottomRight,
          child: match!.superLike??false? Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(Icons.star,color: Colors.blue, size: 25,),
          ): SizedBox(),
          ),

       context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER? SizedBox(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white),
                borderRadius: BorderRadius.circular(10),
                color: Colors.black12
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Watch Ad', style: TextStyle(color: Colors.white,fontSize: 10.sp),),
              ),
            ),
          ),
        ): const SizedBox()
      ],


      ):const SizedBox(),
            );
  }
}