part of 'ad_bloc.dart';

class AdState extends Equatable {
  const AdState();
  
  @override
  List<Object?> get props => [];
}

class AdInitial extends AdState {}

class AdLoaded extends AdState{
  final List<Ad>? nativeAd;
  final RewardedAd? rewardedAd;


   const AdLoaded({this.nativeAd, this.rewardedAd});

  // AdLoaded copyWith({
  //   List<Ad?> nativeAd, 
  //   RewardedAd? rewardedAd}){
    
  //   return AdLoaded(
  //     nativeAd: nativeAd ?? this.nativeAd,
  //     rewardedAd: rewardedAd ?? this.rewardedAd
  //   );
  //}
  @override
  // TODO: implement props
  List<Object?> get props => [nativeAd, rewardedAd];
}

class RewardedAdLoaded extends AdState{
  final RewardedAd ad;

  const RewardedAdLoaded({required this.ad});
  @override
  // TODO: implement props
  List<Object?> get props => [ad];
}