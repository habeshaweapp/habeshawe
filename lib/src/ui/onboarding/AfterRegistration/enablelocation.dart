import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_icons/line_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/ui/home/home.dart';



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
        'Location permission are permanently denied, we cannot request permission'
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
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
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black),
                  ),
                ),
               // Spacer(flex: 1,),
                
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.7,
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'You\'ll need to enable your location in order to use Tinder',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                      )
                  ),
                ),
        
        
        
               // Spacer(flex: 2,),
               const SizedBox(height: 40,),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.70,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async{
                        Position position = await _determineLocation();
                        context.read<OnboardingBloc>().add(UpdateUser(user: state.user.copyWith(location: GeoPoint(position.latitude, position.longitude) )));
                        GoRouter.of(context).pushReplacementNamed(MyAppRouteConstants.homeRouteName);
                        //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (route) => false);
                      }, 
                      child: Text('ALLOW LOCATION', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17,color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
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