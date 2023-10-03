part of 'ad_bloc.dart';

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
    this.reward

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
    RewardItem? reward
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
      reward: reward??this.reward
    );
  }
  
  @override
  List<Object?> get props => [rewardedAd, nativeAd,isLoadedNativeAd,isLoadedRewardedAd, isLoadedInterstitialAd,interstitialAd, numInterstitialLoadAttempts,numNativeLoadAttempts,numRewardedLoadAttempts, reward];
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