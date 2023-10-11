part of 'ad_bloc.dart';

class AdEvent extends Equatable {
  const AdEvent();

  @override
  List<Object> get props => [];
}

class LoadNativeAd extends AdEvent{}

class LoadRewardedAd extends AdEvent{}

class LoadInterstitialAd extends AdEvent{}

class ShowInterstitialAd extends AdEvent{}

class ShowRewardedAd extends AdEvent{}

class OnNativeAdLoaded extends AdEvent{
  final Ad ad;

  const OnNativeAdLoaded({required this.ad});

  @override
  // TODO: implement props
  List<Object> get props => [ad];
}

class OnLoadAdError extends AdEvent{
  final Ad ad;
  final LoadAdError error;
  const OnLoadAdError({required this.ad, required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [ad, error];
}

class OnRewarededAdLoaded extends AdEvent{
  final RewardedAd ad;

  const OnRewarededAdLoaded({required this.ad});

  @override
  // TODO: implement props
  List<Object> get props => [ad];
}

class InterstitialAdLoaded extends AdEvent{
  final InterstitialAd ad;
  
  const InterstitialAdLoaded({required this.ad});

  @override
  // TODO: implement props
  List<Object> get props => [ad];
}
class RewardEarned extends AdEvent{
  final RewardItem reward;
  
  const RewardEarned({required this.reward});

  @override
  // TODO: implement props
  List<Object> get props => [reward];
}

class ResetReward extends AdEvent{}

class InterstitialAdFailedToLoad extends AdEvent{}
class RewardedAdFailedToLoad extends AdEvent{}