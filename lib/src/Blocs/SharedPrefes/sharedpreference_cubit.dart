import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_geo_hash/geohash.dart' as ghash;
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Data/Repository/Remote/remote_config.dart';

part 'sharedpreference_state.dart';

class SharedpreferenceCubit extends Cubit<Location> with HydratedMixin {
  late Position myLocation;
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  final RemoteConfigService remoteConfigService = RemoteConfigService();
  SharedpreferenceCubit({
   required DatabaseRepository databaseRepository,
   required AuthBloc authBloc
  }) : _databaseRepository = databaseRepository,
      _authBloc = authBloc,
   super(const Location());

  Future<Position> getMyLocation() async{
    var loc = await  _determineLocation();
    myLocation = loc;
    if(!loc.isMocked){
      emit(Location(myLocation: [loc.latitude, loc.longitude]));
    }
    // SharedPreferences prefes = await SharedPreferences.getInstance();
    // prefes.setDouble('latitude', loc.latitude);
    // prefes.setDouble('longitude', loc.longitude);
    return loc;
  }

    Future<Position> _determineLocation() async{
    bool serviceEnabled;
    LocationPermission permission;

    // if(!serviceEnabled){
    //   return Future.error('Location services are disabled');
    // }
    try {
      

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
    } catch (e) {
      throw Exception(e);
      
    }
  }

  void checkLocationChange(List<double> firebaseLocation)async{
    var lastLocation = firebaseLocation;
    var currentLocation = await getMyLocation();
    if(!currentLocation.isMocked){
    int val = remoteConfigService.updatLocationAfter();

    var diff =  Geolocator.distanceBetween(lastLocation[0], lastLocation[1], currentLocation.latitude, currentLocation.longitude)/1000;

    if(diff >=val){
      String newHash =  ghash.MyGeoHash().geoHashForLocation(ghash.GeoPoint(currentLocation.latitude, currentLocation.longitude));

     _databaseRepository.updateLocation(userId:_authBloc.state.user!.uid, gender: _authBloc.state.accountType!, newLocation:[currentLocation.latitude,currentLocation.longitude], hash:newHash );
    
    }

    }

  }

  void updateLocOnAppResumed() async{
    try {
      // getMyLocation();
      
    } catch (e) {
      
    }

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
