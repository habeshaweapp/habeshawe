import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserPreference extends Equatable{
  final String userId;
  final String? phoneNumber;
  final bool? global;
  final List<int>? ageRange;
  final String? showMe;
  final bool? showMeOnLomi;
  final bool? recentlyActiveStatus;
  final bool? onlineStatus;
  final String? showDistancesIn;
  final int? maximumDistance;
  final bool? onlyShowInThisRange;

  final int? discoverBy;
  final bool? onlyShowFromMyCity;
  final bool? onlyShowOnlineMatches;
  final bool? onlyShowFromMyCountry;
  final Timestamp? lastTime;


  UserPreference({
    required this.userId,
     this.phoneNumber,
     this.global = true,
     this.ageRange = const [18,28],
     this.showMe,
     this.showMeOnLomi = true ,
     this.recentlyActiveStatus = true,
     this.onlineStatus = true,
     this.showDistancesIn = 'km',
     this.maximumDistance = 2,
     this.onlyShowInThisRange = true,
     this.discoverBy = 0,
     this.onlyShowFromMyCity=false,
     this.onlyShowOnlineMatches=false,
     this.onlyShowFromMyCountry = false,
     this.lastTime
  })
  
  ;

  @override
  // TODO: implement props
  List<Object?> get props => [userId,phoneNumber,global,ageRange,showDistancesIn,showMe,showMeOnLomi,recentlyActiveStatus,onlineStatus,maximumDistance,onlyShowInThisRange, discoverBy,onlyShowFromMyCity, onlyShowOnlineMatches,onlyShowFromMyCountry,lastTime];

  UserPreference copyWith({
    String? userId,
    String? phoneNumber,
    bool? global,
    List<int>? ageRange,
    String? showMe,
    bool? showMeOnLomi,
    bool? recentlyActiveStatus,
    bool? onlineStatus,
    String? showDistancesIn,
    int? maximumDistance,
    bool? onlyShowInThisRange,
    int? discoverBy,
    bool? onlyShowFromMyCity,
    bool? onlyShowOnlineMatches,
    bool? onlyShowFromMyCountry,
    Timestamp? lastTime


  }){
    return UserPreference(
      userId: userId ?? this.userId, 
      phoneNumber: phoneNumber ?? this.phoneNumber, 
      global: global ?? this.global, 
      ageRange: ageRange ?? this.ageRange, 
      showMe: showMe ?? this.showMe, 
      showMeOnLomi: showMeOnLomi ?? this.showMeOnLomi, 
      recentlyActiveStatus: recentlyActiveStatus ?? this.recentlyActiveStatus, 
      onlineStatus: onlineStatus ?? this.onlineStatus, 
      showDistancesIn: showDistancesIn ?? this.showDistancesIn,
      maximumDistance: maximumDistance ?? this.maximumDistance,
      onlyShowInThisRange: onlyShowInThisRange ?? this.onlyShowInThisRange,
      discoverBy: discoverBy ?? this.discoverBy,
      onlyShowFromMyCity: onlyShowFromMyCity ?? this.onlyShowFromMyCity,
      onlyShowOnlineMatches: onlyShowOnlineMatches?? this.onlyShowOnlineMatches,
      onlyShowFromMyCountry: onlyShowFromMyCountry?? this.onlyShowFromMyCountry,
      lastTime: lastTime?? this.lastTime
      );
  }

  static UserPreference fromSnapshoot(DocumentSnapshot snap){
    var asMap = snap.data() as Map<String, dynamic>;
    return UserPreference(
      userId: snap['userId'],
      phoneNumber: snap['phoneNumber'], 
      global: snap['global'], 
      ageRange: List<int>.from(snap['ageRange']), 
      showMe: snap['showMe'], 
      showMeOnLomi: snap['showMeOnLomi'], 
      recentlyActiveStatus: snap['recentlyActiveStatus'], 
      onlineStatus: snap['onlineStatus'], 
      showDistancesIn: snap['showDistancesIn'],
      maximumDistance: snap['maximumDistance'],
      onlyShowInThisRange: snap['onlyShowInThisRange'],
      discoverBy: (snap.data() as Map<String, dynamic>).containsKey('discoverBy') ? snap['discoverBy'] : null,
      onlyShowFromMyCity: asMap.containsKey('onlyShowFromMyCity') ? snap['onlyShowFromMyCity']: null,
      onlyShowOnlineMatches: asMap.containsKey('onlyShowOnlineMatches') ? snap['onlyShowOnlineMatches']: null,
      onlyShowFromMyCountry: asMap.containsKey('onlyShowFromMyCountry') ? snap['onlyShowFromMyCountry']: null,
      lastTime: asMap.containsKey('lastTime') ? snap['lastTime']: null,

      );
  }

  Map<String, dynamic> toMap(){
    return {
      'userId': userId,
      'phoneNumber': phoneNumber,
      'global': global,
      'ageRange': ageRange,
      'showMe': showMe,
      'showMeOnLomi': showMeOnLomi,
      'recentlyActiveStatus': recentlyActiveStatus,
      'onlineStatus': onlineStatus,
      'showDistancesIn': showDistancesIn,
      'maximumDistance': maximumDistance,
      'onlyShowInThisRange': onlyShowInThisRange,
      'discoverBy': discoverBy,
      'onlyShowFromMyCity': onlyShowFromMyCity,
      'onlyShowOnlineMatches':onlyShowOnlineMatches,
      'onlyShowFromMyCountry':onlyShowFromMyCountry,
      'lastTime': lastTime
    };
  }




}