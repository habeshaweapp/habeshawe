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

class ShowRewardedAd extends AdEvent{
  final AdType adType;
  const ShowRewardedAd({required this.adType});
}

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
  final AdType adType;
  
  const RewardEarned({required this.reward, required this.adType});

  @override
  // TODO: implement props
  List<Object> get props => [reward];
}

class ResetReward extends AdEvent{}

class InterstitialAdFailedToLoad extends AdEvent{}
class RewardedAdFailedToLoad extends AdEvent{}
class ResetTotalReON extends AdEvent{}

class TimeOutAd extends AdEvent{
  final DateTime completedTimeAd;
  const TimeOutAd({required this.completedTimeAd});

  @override
  // TODO: implement props
  List<Object> get props => [completedTimeAd];
}

class IncreaseLoadAttempt extends AdEvent{}

class IncreaseReOn extends AdEvent{}