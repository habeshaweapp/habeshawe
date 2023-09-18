part of 'ad_bloc.dart';

class AdEvent extends Equatable {
  const AdEvent();

  @override
  List<Object> get props => [];
}

class LoadNativeAd extends AdEvent{}

class LoadRewardedAd extends AdEvent{}

class OnAdLoaded extends AdEvent{
  final Ad ad;

  const OnAdLoaded({required this.ad});

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
