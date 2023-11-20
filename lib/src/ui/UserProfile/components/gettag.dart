import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';

import '../../../Data/Models/enums.dart';
import '../../../Data/Models/user.dart';
import 'bottomprofile.dart';

class GetTag extends StatelessWidget {
  final User user;
  final void Function() ontap;
   GetTag({
    super.key,
    required this.user,
    required this.ontap
  });
final pageController = PageController();
  @override
  Widget build(BuildContext context) {
    
    if(user.verified == VerifiedStatus.notVerified.name){

    return Center(
      child: 
             
          Column(
            children: [
              SizedBox(
                height: 220.h,
                //width: 300,
                child: PageView(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: pageController ,
                  children: [
                    PageViewItem(icon: LineIcons.crown,
                    color: Colors.amber,
                    title: 'Get Your Crown', 
                    description: 'Get verified and we will reveal your profile and if you stand out you will get Queen tag', 
                    buttonText: user.gender == Gender.women.name? 'Apply  To Queen': 'Apply To King',
                    ontap: ontap 
                    ),
              
                    PageViewItem(icon: FontAwesomeIcons.userTie, 
                    color: Colors.grey,
                    title: user.gender == Gender.men.name? 'Get Your GentleMan Tag': 'Get Your Princess Tag' , 
                    description: 'Get verified and we will reveal your profile and if you stand out you will give you  gentlemans tag', 
                    buttonText: user.gender == Gender.men.name? 'Apply  To GentleMen': 'Apply  To Princess',
                    ontap: ontap
                    ),
              
                    PageViewItem(icon: Icons.verified, 
                    color: Colors.blue,
                    title: 'Get Your Verified Tag', 
                    description: 'Get verified and we will reveal your profile and if you stand out you will get Queen tag', 
                    buttonText: 'Get Verified Tag',
                    ontap: ontap
                    ),

                    
                  ],
                ),
              ),

              SizedBox(
                width: 60,
                child: DotIndicator(dots: 3, pageController: pageController),
              )
            ],
          )
          
      
      ,
    );
    }else if(user.verified == VerifiedStatus.pending.name){
      return Center(
        child: Column(
          children: [
            Icon(Icons.pending, color: Colors.grey,size: 30, ), 
            Container(
              child: Text('Your profile is,\nunder review, you will be verified in time...', style: TextStyle(fontSize: 12.sp, color: Colors.grey ), textAlign: TextAlign.center, ),
            ),
          ],
        ),
      );
    }else{
      Icon verifiedIcon =  Icon(Icons.verified_outlined);
      String title = '';
      String description = 'Your account has been verified. you are one of a gem, enjoy and have fun.';
            if(user.verified == VerifiedStatus.verified.name){
              verifiedIcon =  Icon(Icons.verified, color: Colors.blue, size: 50.sp,);
              title = 'Welcome';
              description = 'Your account has been verified. enjoy and have fun.';
            }else if(user.verified == VerifiedStatus.queen.name){
              verifiedIcon =  Icon(LineIcons.crown,size: 70.sp, color: Colors.amber,);
              title = 'Welcome Queen';
            }else if(user.verified == VerifiedStatus.princess.name){
              verifiedIcon =  Icon(LineIcons.crown,size: 60.sp, color: Colors.pink,);
              title = 'Welcome Princess';
            }else if(user.verified == VerifiedStatus.king.name){
              verifiedIcon =  Icon(FontAwesomeIcons.crown, color: Colors.amber,size:60.sp);
              title = 'Welcome King';
            }else if(user.verified == VerifiedStatus.gentelmen.name){
              verifiedIcon =  Icon(FontAwesomeIcons.userTie,size: 60.sp, color: Colors.grey,);
              title = 'Welcome Gent';
            }

     return Column(
                    children: [
    
                      //Image.asset(image, height: 70,),
                      verifiedIcon,
                      SizedBox(height: 15.h,),
                      Padding(
                        padding:  EdgeInsets.only(bottom: 10.0.h),
                        child: Text(title,
                        style: Theme.of(context).textTheme.titleLarge ,
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 35.w),
                        child: Text(description
                         ,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11.sp) ,
                          textAlign: TextAlign.center,
                          ),
                      ),
                        SizedBox(height: 15.h,),

                        
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

class DotIndicator extends StatefulWidget {
  const DotIndicator({
    super.key,
    required this.dots,
    required this.pageController
  });

  final int dots;
  final PageController pageController;

  @override
  State<DotIndicator> createState() => _DotIndicatorState();
}

class _DotIndicatorState extends State<DotIndicator> {
  int selectedIndex = 0;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.pageController.addListener(() {
      setState(() {
        selectedIndex = widget.pageController.page!.toInt();
      });
    
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right:5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: List.generate(widget.dots, 
            (index) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Divider(thickness: 1, color: selectedIndex == index? Colors.black : Colors.grey,),
              )
              ))
      ),
    );
  }
}