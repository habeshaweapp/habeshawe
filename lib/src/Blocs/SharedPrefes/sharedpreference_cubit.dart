import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sharedpreference_state.dart';

class SharedpreferenceCubit extends Cubit<Location> with HydratedMixin {
  late Position myLocation;
  SharedpreferenceCubit() : super(const Location());

  Future<Position> getMyLocation() async{
    var loc = await  _determineLocation();
    myLocation = loc;
    emit(Location(myLocation: [loc.latitude, loc.longitude]));
    SharedPreferences prefes = await SharedPreferences.getInstance();
    prefes.setDouble('latitude', loc.latitude);
    prefes.setDouble('longitude', loc.longitude);
    return loc;
  }

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

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
  }
  
  @override
  Location? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    return Location(
      myLocation: [
        json['latitude'] as double,
        json['longitude']as double
      ]
    );
  }
  
  @override
  Map<String, dynamic>? toJson(Location state) {
    // TODO: implement toJson
    return {
      'latitude': state.myLocation?[0],
      'longitude': state.myLocation?[1]
    };
  }
}
