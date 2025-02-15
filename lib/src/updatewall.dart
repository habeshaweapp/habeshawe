import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lomi/src/Blocs/UpdateWallBloc/update_wall_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateWall extends StatelessWidget {
  const UpdateWall({super.key});

  @override
  Widget build(BuildContext context) {
    final shutz = (context.read<UpdateWallBloc>().state as ShutDownThisApp).shutz;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child:shutz == Shuts.update?  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/images/habeshawelogo.png',width: 120,height: 120,)),
              Padding(
                padding: const EdgeInsets.only(top:15.0),
                child: Text('You\'re missing out',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
        
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('Update your HabeshaWe app for the newest\nFeatures',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
        
              SizedBox(
                width: 170.w,
                child: ElevatedButton(
                  onPressed: ()async{
                  const url = 'https://play.google.com/store/apps/details?id=com.ulend.habeshawe';

                  if(await canLaunchUrl(Uri.parse(url))){
                    await launchUrl(Uri.parse(url));

                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('please Go to playstore and update!')));
                  }
        
                  }, 
                  child: Text('Update'),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder()
                  ),
                  ),
              ),
              SizedBox(height: 35.h,)
              // TextButton(
              //   onPressed: (){
        
              // }, 
              // child: Text('Not now'))
        
            ],
          ):shutz == Shuts.fake? Column(
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/images/habeshawelogo.png',width: 120,height: 120,)),
              Padding(
                padding: const EdgeInsets.only(top:15.0),
                child: Text('You\'re BLOCKED',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red),
                ),
              ),

            ],
          ):const SizedBox(),
        ),
      ),
      
    );
  }
}