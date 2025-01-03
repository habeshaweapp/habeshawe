part of 'ad_bloc.dart';

enum AdType {rewardedNearby, rewardedOnline, rewardedQueen, rewardedPrincess, rewardedRandom }
class AdState extends Equatable {
  const AdState({
    this.rewardedAd,
    this.nativeAd,
    this.interstitialAd,
    this.isLoadedRewardedAd = false,
    this.isLoadedNativeAd = false,
    this.numInterstitialLoadAttempts=0,
    this.numNativeLoadAttempts =0,
    this.numRewardedLoadAttempts = 0,
    this.isLoadedInterstitialAd = false,
    this.reward,
    this.adWatchedQueen=0,
    this.rewardedAdType,
    this.adWatchedPrincess =0,
    this.adWatchedOnline=0,
    this.totalAdWatchedReOn=0,
    this.completedTimeAd

  });

  final RewardedAd? rewardedAd;
  final Ad? nativeAd;
  final InterstitialAd? interstitialAd;
  final bool isLoadedRewardedAd;
  final bool isLoadedNativeAd;
  final bool isLoadedInterstitialAd;
  final int numInterstitialLoadAttempts;
  final int numRewardedLoadAttempts;
  final int numNativeLoadAttempts;
  final RewardItem? reward;
  final int? adWatchedQueen;
  final int? adWatchedPrincess;
  final AdType? rewardedAdType;
  final int? adWatchedOnline;
  final int totalAdWatchedReOn;
  final DateTime? completedTimeAd;


  AdState copyWith({
    RewardedAd? rewardedAd,
    Ad? nativeAd,
    InterstitialAd? interstitialAd,
    bool? isLoadedRewardedAd,
    bool? isLoadedNativeAd,
    bool? isLoadedInterstitialAd,
    int? numInterstitialLoadAttempts,
    int? numNativeLoadAttempts,
    int? numRewardedLoadAttempts,
    RewardItem? reward,
    int? adWatchedQueen,
    AdType? rewardedAdType,
    int? adWatchedPrincess,
    int? adWatchedOnline,
    int? totalAdWatchedReOn,
    DateTime? completedTimeAd
  }){
    return AdState(
      rewardedAd: rewardedAd ?? this.rewardedAd,
      nativeAd: nativeAd ?? this.nativeAd,
      interstitialAd: interstitialAd??this.interstitialAd,
      isLoadedNativeAd: isLoadedNativeAd ?? this.isLoadedNativeAd,
      isLoadedRewardedAd: isLoadedRewardedAd ?? this.isLoadedRewardedAd,
      numInterstitialLoadAttempts: numInterstitialLoadAttempts ?? this.numInterstitialLoadAttempts,
      numNativeLoadAttempts: numNativeLoadAttempts ?? this.numNativeLoadAttempts,
      numRewardedLoadAttempts: numRewardedLoadAttempts ?? this.numRewardedLoadAttempts,
      isLoadedInterstitialAd: isLoadedInterstitialAd ?? this.isLoadedInterstitialAd,
      reward: reward??this.reward,
      adWatchedQueen: adWatchedQueen??this.adWatchedQueen,
      rewardedAdType: rewardedAdType?? this.rewardedAdType,
      adWatchedPrincess: adWatchedPrincess?? this.adWatchedPrincess,
      adWatchedOnline: adWatchedOnline?? this.adWatchedOnline,
      totalAdWatchedReOn: totalAdWatchedReOn?? this.totalAdWatchedReOn,
      completedTimeAd: completedTimeAd??this.completedTimeAd
    );
  }
  
  @override
  List<Object?> get props => [rewardedAd, nativeAd,isLoadedNativeAd,isLoadedRewardedAd, isLoadedInterstitialAd,interstitialAd, numInterstitialLoadAttempts,numNativeLoadAttempts,numRewardedLoadAttempts, reward,adWatchedQueen, rewardedAdType, adWatchedPrincess, adWatchedOnline,totalAdWatchedReOn,completedTimeAd ];

  Map<String,dynamic> toJson(){
    return{
      'adWatchedQueen': adWatchedQueen,
      'adWatchedPrincess':adWatchedPrincess,
      'adWatchedOnline': adWatchedOnline,
      'totalAdWatchedReOn':totalAdWatchedReOn,
      'completedTimeAd':completedTimeAd?.toIso8601String()
    };

  }

  factory AdState.fromJson(Map<String,dynamic> json){
    return AdState(
      adWatchedQueen: json['adWatchedQueen'] as int,
      adWatchedPrincess: json['adWatchedPrincess'] as int,
      adWatchedOnline: json['adWatchedOnline'] as int,
      totalAdWatchedReOn: json['totalAdWatchedReOn'] as int,
      completedTimeAd: json['completedTimeAd'] == null?null: DateTime.parse(json['completedTimeAd'] as String)
    );
  }
}

class AdInitial extends AdState {}

// class AdLoaded extends AdState{
//   final List<Ad>? nativeAd;
//   final RewardedAd? rewardedAd;


//    const AdLoaded({this.nativeAd, this.rewardedAd});

//   // AdLoaded copyWith({
//   //   List<Ad?> nativeAd, 
//   //   RewardedAd? rewardedAd}){
    
//   //   return AdLoaded(
//   //     nativeAd: nativeAd ?? this.nativeAd,
//   //     rewardedAd: rewardedAd ?? this.rewardedAd
//   //   );
//   //}
//   @override
//   // TODO: implement props
//   List<Object?> get props => [nativeAd, rewardedAd];
// }

class RewardedAdLoaded extends AdState{
  final RewardedAd ad;

  const RewardedAdLoaded({required this.ad});
  @override
  // TODO: implement props
  List<Object?> get props => [ad];
}