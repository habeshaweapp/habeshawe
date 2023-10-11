import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../../Data/Models/enums.dart';
import '../../../Data/Models/user.dart';
import 'bottomprofile.dart';

class GetTag extends StatelessWidget {
  final User user;
  const GetTag({
    super.key,
    required this.user
  });

  @override
  Widget build(BuildContext context) {
    if(user.verified == VerifiedStatus.notVerified.name){

    return Center(
      child: 
             
          SizedBox(
            height: 250,
            //width: 300,
            child: PageView(
              physics: const BouncingScrollPhysics(),
              children: [
                PageViewItem(icon: LineIcons.crown,
                color: Colors.amber,
                title: 'Get Your Crown', 
                description: 'Get verified and we will reveal your profile and if you stand out you will get Queen tag', 
                buttonText: user.gender == Gender.women.name? 'Apply  To Queen': 'Apply To King',
                ontap: () {
                  //showVerifyDialog(state.user);

                } 
                ),
          
                PageViewItem(icon: LineIcons.suitcase, 
                color: Colors.black,
                title: user.gender == Gender.men.name? 'Get Your GentleMan Tag': 'Get Your Princess Tag' , 
                description: 'Get verified and we will reveal your profile and if you stand out you will give you  gentlemans tag', 
                buttonText: user.gender == Gender.men.name? 'Apply  To GentleMen': 'Apply  To Princess',
                ontap: (){
                  //showVerifyDialog(user);
                  },
                ),
          
                PageViewItem(icon: Icons.verified, 
                color: Colors.blue,
                title: 'Get Your Verified Tag', 
                description: 'Get verified and we will reveal your profile and if you stand out you will get Queen tag', 
                buttonText: 'Get Verified Tag',
                ontap: (){
                  //showVerifyDialog(user);
                },
                ),
              ],
            ),
          )
          
      
      ,
    );
    }else if(user.verified == VerifiedStatus.pending){
      return Center(
        child: Container(
          child: Text('Your profile is under review, you will be verified in time...'),
        ),
      );
    }else{
      Icon verifiedIcon =  Icon(Icons.verified_outlined);
      String title = '';
      String description = 'Your account has been verified. you are one of a gem, enjoy and have fun.';
            if(user.verified == VerifiedStatus.verified.name){
              verifiedIcon = const Icon(Icons.verified, color: Colors.blue,);
              title = 'Welcome';
            }else if(user.verified == VerifiedStatus.queen.name){
              verifiedIcon = const Icon(LineIcons.crown,size: 60, color: Colors.amber,);
              title = 'Welcome Queen';
            }else if(user.verified == VerifiedStatus.princess.name){
              verifiedIcon = const Icon(LineIcons.crown, color: Colors.blue,);
              title = 'Welcome Princess';
            }else if(user.verified == VerifiedStatus.king.name){
              verifiedIcon = const Icon(LineIcons.crown, color: Colors.amber,);
              title = 'Welcome King';
            }else if(user.verified == VerifiedStatus.gentelmen.name){
              verifiedIcon = const Icon(LineIcons.suitcase, color: Colors.blue,);
              title = 'Welcome Gent';
            }

     return Column(
                    children: [
    
                      //Image.asset(image, height: 70,),
                      verifiedIcon,
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(title,
                        style: Theme.of(context).textTheme.titleLarge ,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 45),
                        child: Text(description
                         ,
                          style: Theme.of(context).textTheme.bodySmall ,
                          textAlign: TextAlign.center,
                          ),
                      ),
                        SizedBox(height: 15,),

                        
                    ],
                  );

    }
  }
}

class ProfileBox extends StatelessWidget {
  const ProfileBox({
    super.key,
    required this.isDark,
    required this.title,
    required this.icon,
    required this.onTap,
     this.superLikes,
     this.color
  });

  final bool isDark;
  final IconData icon;
  final String title;
  final void Function() onTap;
  final Color? color;

  final int? superLikes;
  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.115,
      width: MediaQuery.of(context).size.width * 0.3,
      child: Card(
        color: isDark? Colors.grey[900]: null,
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: onTap,
          // (){
          //   showPaymentDialog(context:context, paymentUi: PaymentUi.superlikes);
          // },
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                SizedBox(
                  height:title != 'Subscriptions'? 5:15,
                ),
                Icon(
                  icon,
                  color: color,
                ),
                SizedBox(
                  height: 8,
                ),
                Text( superLikes != null? '$superLikes $title' : title
                  ,style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),),
               title != 'Subscriptions'? SizedBox(
                  height: 5,
                ):SizedBox(),
                title != 'Subscriptions'?
                Text(
                  "GET MORE",
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ):SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
