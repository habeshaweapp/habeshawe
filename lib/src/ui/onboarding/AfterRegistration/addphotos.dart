import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/dataApi/interestslist.dart';
import 'package:lomi/src/ui/onboarding/AfterRegistration/enablelocation.dart';

import '../../../Blocs/ImagesBloc/images_bloc.dart';
import '../../../Blocs/blocs.dart';
import 'widgets/photoselector.dart';

class AddPhotos extends StatefulWidget {
  const AddPhotos({super.key});

  @override
  State<AddPhotos> createState() => _AddPhotosState();
}

class _AddPhotosState extends State<AddPhotos> {
 // bool _isSelected = false;
  List<String> _selectedList = [];

  @override
  Widget build(BuildContext context) {
    //context.read<OnboardingBloc>().add(onboa)
    return Scaffold(
      bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
      body: SafeArea(
        child:
        BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            if( state is OnboardingLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            if(state is OnboardingLoaded){
             var imagesCount = state.user.imageUrls.length;
             int count = 0;
             List<dynamic> images = state.user.imageUrls;
                              
                              images.forEach((element) {
                                if(element !=null){
                                  count +=1;
                                }
                              });
            return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LinearProgressIndicator(
                        value: 0.9
        
                      ),
                     Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: ()=>Navigator.pop(context),
                          
                          child: Icon(Icons.arrow_back,size: 35,)),
                      ),
        
                      Center(
                        child: Container(
                          width: 200,
                          margin: EdgeInsets.symmetric(horizontal:35),
                          child: Text('Add Photos',
                         // textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.headlineMedium
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                            width: MediaQuery.of(context).size.width*0.9,
                            margin: EdgeInsets.only(top: 10,left: 35,right: 35),
                            child: Text(
                              'Upload 2 photos to start. Add 4 or more to make your profile stand out.',
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Color.fromARGB(255, 192, 189, 189),),
                              textAlign: TextAlign.center,
                              )
                          ),
                      ),

                     
                     Spacer(flex: 1,),

                       state.user.gender=='women'? Center(
                        child: Container(
                            width: MediaQuery.of(context).size.width*0.9,
                            margin: EdgeInsets.only(top: 10,left: 35,right: 35),
                            child: Text(
                              'Make you first photo Habesha Kemis. keep the\nculture queen!',
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp),
                              textAlign: TextAlign.center,
                              )
                          ),
                      ):SizedBox(),

                      SizedBox(height: 10.h,),
        
                      // BlocBuilder<ImagesBloc, ImagesState>(
                      //   builder: (context, state) {
                      //     if(state is ImagesLoading){
                      //       return Center(child: CircularProgressIndicator(),);
                      //     }
        
                      //     if(state is ImagesLoaded){
                           
                             Padding(
                              padding: const EdgeInsets.only(left: 30.0, right: 25),
                              child: SizedBox(
                                height: 450,
                              
                                child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.66), 
                                  itemCount: 6,
                                  itemBuilder:  (context, index) {
                                    return 
                                    //(imagesCount > index) ?
                                    state.user.imageUrls[index] !=null?
                                    PhotoSelector(imageUrl: state.user.imageUrls[index],index:index):PhotoSelector(index: index,);
                                    // (state.selectedImages == null || state.selectedImages!.isEmpty)? PhotoSelector():
                                    // (state.selectedImages!.isNotEmpty)?
                                    //  PhotoSelector(selectedImage: File(state.selectedImages![index-imagesCount]!.path)):
                                     
                                     
                            
                                    
                                  }
                                  ),
                              ),
                            ),

                            

                           
              
            
                            
                            
                      //       // Column(
                      //       //   children: [
        
                      //       //     Row(
                      //       //           mainAxisAlignment: MainAxisAlignment.center,
                      //       //           children: [
                      //       //             (imagesCount > 0)? 
                      //       //             PhotoSelector(imageUrl: state.imageUrls[0],):
                      //       //             PhotoSelector(),
                      //       //             (imagesCount > 1)? 
                      //       //             PhotoSelector(imageUrl: state.imageUrls[1],):
                      //       //             PhotoSelector(),
                      //       //             (imagesCount > 2)? 
                      //       //             PhotoSelector(imageUrl: state.imageUrls[2],):
                      //       //             PhotoSelector(),
                                    
                      //       //           ],
                      //       //         ),
        
                      //       //         Row(
                      //       //             mainAxisAlignment: MainAxisAlignment.center,
                      //       //             children: [
                      //       //               (imagesCount > 3)? 
                      //       //             PhotoSelector(imageUrl: state.imageUrls[3],):
                      //       //             PhotoSelector(),
                      //       //             (imagesCount > 4)? 
                      //       //             PhotoSelector(imageUrl: state.imageUrls[4],):
                      //       //             PhotoSelector(),
                      //       //             (imagesCount > 5)? 
                      //       //             PhotoSelector(imageUrl: state.imageUrls[5],):
                      //       //             PhotoSelector(),
        
                      //       //             ],
                      //       //           ),
        
                      //       //   ],
                      //       // );
                      //     }
                      //     else{
                      //       return Text('something went wrong');
                      //     }
                        
                      //   },
                      // ),
        
                      
        
        
        
                      
        
                      
                     
        
        
        
                      Spacer(flex: 2,),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width*0.70,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (){
                              
                              if(count >=2){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => BlocProvider.value(value: context.read<OnboardingBloc>(),
                                                                                                      child: const EnableLocation() )));
                              }
                            }, 
                            child: Text('CONTINUE', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17.sp,color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              backgroundColor: count <2?Colors.grey:isDark?Colors.teal:Colors.green
                            ),
                            
                            ),
                        ),
                      ),
                      const SizedBox(height: 20,)
                     
        
                    ],
                  ),
                );
            }else{
              return Text('something went wrong');
            }
          },
        )
      )
    );
  }
}