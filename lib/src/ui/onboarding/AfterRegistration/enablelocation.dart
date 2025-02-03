
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geo_hash/geohash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_icons/line_icons.dart';
import 'package:go_router/go_router.dart';

import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/Data/Models/userpreference_model.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/ui/home/home.dart';
import 'package:lomi/src/ui/splash/splashscreen.dart';

import '../../../Blocs/UserPreference/userpreference_bloc.dart';



class EnableLocation extends StatelessWidget {
  const EnableLocation({super.key});
 
  Future<Position> _determineLocation() async{
    bool serviceEnabled;
    LocationPermission permission;

    // if(!serviceEnabled){
    //   return Future.error('Location services are disabled');
    // }

    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){

        return Future.error('Location permissions are denied');
      }
    }

    if(permission == LocationPermission.deniedForever){
      return Future.error(
        //'Location permission are permanently denied, we cannot request permission'
        'Location permissions are denied'
      );
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    return Scaffold(
      body: SafeArea(
        child:BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            if(state is OnboardingLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            
            if(state is OnboardingLoaded){
            return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                const SizedBox(height: 50,),
                
               Center(
                 child:  Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1,),
                    color: Colors.grey.withOpacity(0.1)
                  ),
                   child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Icon(Icons.location_on_outlined,size: 105,color: Colors.black.withOpacity(0.4),),
                    ),
                 ),
               ),
               Spacer(),
               
               Spacer(),
               const SizedBox(height: 50,),
        
                Center(
                 
                  child: Text('Enable Location',
                 // textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headlineMedium
                  ),
                ),
               // Spacer(flex: 1,),
                
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.7,
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      //'You\'ll need to enable your location in order to use HabeshaWe',
                      'Turning on Location Services allows as to provide features like Nearby matches, calculate your distance from another match...',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w300, fontSize: 12.sp, color: Colors.grey),
                      textAlign: TextAlign.center,
                      )
                  ),
                ),

                // BlocListener<AuthBloc,AuthState>(
                //   listener: (context,state){
                //     if(state.isCompleted == true){
                //       Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

                //     }

                //   },
                // ),
        
        
        
               // Spacer(flex: 2,),
               const SizedBox(height: 40,),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.70,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async{
                        try {
                          var position = await _determineLocation();
                          String hash = MyGeoHash().geoHashForLocation(GeoPoint(position.latitude, position.longitude));
                          var placeMark = await placemarkFromCoordinates(position.latitude, position.longitude);
                          int rep = 0;
                          while(placeMark.isEmpty){
                            if(rep == 5)  break;
                            placeMark = await placemarkFromCoordinates(position.latitude, position.longitude);
                            rep ++;

                          }
                          var choosenPlaceMark = placeMark[0];
                          if(placeMark.isNotEmpty && (placeMark[0].locality==null || placeMark[0].locality =='')){
                            for(var place in placeMark){
                              if(place.locality != '' && place.locality != null){
                                choosenPlaceMark = place;
                                break;
                              }
                            }
                           

                          }
                          // bool conts = !choosenPlaceMark.locality!.contains(RegExp('^[a-zA-Z]+'));
                          // if(conts){
                          //   for(var place in placeMark){
                          //     if(place.locality!.contains(RegExp('^[a-zA-Z]+'))){
                          //       choosenPlaceMark = place;
                          //       break;
                          //     }

                          // }
                          // }
                       
                          if(placeMark.isNotEmpty ){
                            List<dynamic> imageUrls = [...state.user.imageUrls];
                            imageUrls.removeWhere((element) => element == null);

                            context.read<OnboardingBloc>().add(CompleteOnboarding(placeMark: choosenPlaceMark, user: state.user.copyWith(geohash: hash,location: [position.latitude, position.longitude], country: choosenPlaceMark.country, countryCode: position.isMocked?'mocked': choosenPlaceMark.isoCountryCode, city: choosenPlaceMark.locality,imageUrls: imageUrls ), isMocked: position.isMocked));
           
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const SplashScreen()),(route) => false);
                          }

                          if(placeMark.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('somethings not up...check your phone and Try Again')));
                          }


                        
                        } catch (e) {
                          if(e.toString() == 'Location permissions are denied'){
                            List<dynamic> imageUrls = [...state.user.imageUrls];
                            imageUrls.removeWhere((element) => element == null);

                            context.read<OnboardingBloc>().add(CompleteOnboarding(placeMark: Placemark(), user: state.user.copyWith(countryCode: 'LocationDenied', imageUrls: imageUrls, location: [0,0], country: '', city: '',livingIn: ' ' ), isMocked: true,));
           
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const SplashScreen()),(route) => false);

                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Try Again! something went wrong', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),)));
                          }          
                        }
                       
 
                       
                      }
                      , 
                      child: Text(
                        //'ALLOW LOCATION', 
                        'CONTINUE',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17,color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor:  isDark?Colors.teal:Colors.green
                      ),
                      
                      ),
                  ),
                ),
               
                //const SizedBox(height: 20,)
                Spacer(),
               
        
              ],
            ),
          );
            
            
         }else{
          return Center(child: Text('something went wrong'),);
         }

          }
        )
      )
    );
  }
}