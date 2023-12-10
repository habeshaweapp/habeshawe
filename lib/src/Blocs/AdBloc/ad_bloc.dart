import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lomi/src/Data/Repository/Database/ad_repository.dart';

part 'ad_event.dart';
part 'ad_state.dart';

class AdBloc extends Bloc<AdEvent, AdState> with HydratedMixin{
  final AdRepository _adRepository;
  AdBloc({
    required AdRepository adRepository,
  }) : _adRepository = adRepository,
        super(AdState()) {
    on<LoadNativeAd>(_onLoadNativeAd);

    on<OnNativeAdLoaded>(_onNativeAdLoaded);
    on<OnLoadAdError>(_onLoadAdError);
    on<LoadRewardedAd>(_onLoadRewardedAd);
    on<OnRewarededAdLoaded>(_onOnRewarededAdLoaded);
    on<LoadInterstitialAd>(_onLoadInterstitialAd);
    on<ShowInterstitialAd>(_onShowInterstitialAd);
    on<ShowRewardedAd>(_onShowRewardedAd);
    on<InterstitialAdLoaded>(_onInterstitialAdLoaded);
    on<RewardEarned>(_onRewardEarned);
    on<ResetReward>(_onResetReward);
    on<InterstitialAdFailedToLoad>(_onInterstitialAdFailedToLoad);
    on<RewardedAdFailedToLoad>(_onRewardedAdFailedToLoad);
    on<ResetTotalReON>(_onResetTotalReOn);
    on<TimeOutAd>(_onTimeOutAd);
    

    //add(LoadNativeAd());
    add(LoadRewardedAd());
   // add(LoadInterstitialAd());
  }

  FutureOr<void> _onLoadNativeAd(LoadNativeAd event, Emitter<AdState> emit) {
    var ad = _adRepository.createNativeAd(
      onAdLoaded: (ad){
        add(OnNativeAdLoaded(ad:ad));
        
      }, 
      onAdFailedToLoad: (ad, loadAdError){
        //add(OnLoadAdError(ad: ad, error: loadAdError));
        if(state.numNativeLoadAttempts < 5){
          add(LoadNativeAd());
          if(state.numNativeLoadAttempts <5){
            add(LoadNativeAd());
            emit(state.copyWith(numNativeLoadAttempts: state.numNativeLoadAttempts +1)); 
          }
        }

      });
      
   // final adState = state as 
    //emit(AdLoaded(nativeAd: ad));
    //return ad;

  }

  FutureOr<void> _onLoadAdError(OnLoadAdError event, Emitter<AdState> emit) {
    print('native Ad loaded');
  }

  FutureOr<void> _onNativeAdLoaded(OnNativeAdLoaded event, Emitter<AdState> emit) {

    emit(state.copyWith(nativeAd: event.ad, isLoadedNativeAd: true, numNativeLoadAttempts: 0));
    print('Native ad loaded');
   
  }

  FutureOr<void> _onLoadRewardedAd(LoadRewardedAd event, Emitter<AdState> emit) {
    //emit(state.copyWith(isLoadedRewardedAd: false));
     _adRepository.createRewardAd(
      onAdLoaded: (ad){
        add(OnRewarededAdLoaded(ad: ad));
      }, 
      onAdFailedToLoad: (error){
        print(error);
        if(state.numRewardedLoadAttempts <5){
          //add(LoadRewardedAd());
          emit(state.copyWith(numRewardedLoadAttempts: state.numRewardedLoadAttempts+1));
        }
        add(RewardedAdFailedToLoad());
      });
  }

  FutureOr<void> _onOnRewarededAdLoaded(OnRewarededAdLoaded event, Emitter<AdState> emit) {
    
    emit(state.copyWith(rewardedAd: event.ad, isLoadedRewardedAd: true, reward: null));
      
      //RewardedAdLoaded(ad: event.ad));
  }

  FutureOr<void> _onInterstitialAdLoaded(InterstitialAdLoaded event, Emitter<AdState> emit) {

      emit(state.copyWith(interstitialAd: event.ad, isLoadedInterstitialAd: true, numInterstitialLoadAttempts: 0 ));
      state.interstitialAd!.setImmersiveMode(true);
    }

  FutureOr<void> _onLoadInterstitialAd(LoadInterstitialAd event, Emitter<AdState> emit) {
    _adRepository.createInterstitialAd(
      onAdLoaded: (ad){
        add(InterstitialAdLoaded(ad: ad));

      }, 
      onAdFailedToLoad: (error){

        add(InterstitialAdFailedToLoad());

      });
  }

  FutureOr<void> _onShowInterstitialAd(ShowInterstitialAd event, Emitter<AdState> emit){
    if(state.interstitialAd != null){
      state.interstitialAd!.fullScreenContentCallback =FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) =>
          print('ad onAdshowedflullscreencontent'),
        onAdDismissedFullScreenContent: (ad){
          print('$ad onAdDismissedFullScreenContent');
          ad.dispose();
          add(LoadInterstitialAd());
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('$ad onAdFailedToshowFullscreen');
          ad.dispose();
          add(LoadInterstitialAd());
        },
      );

      state.interstitialAd!.show();
      emit(state.copyWith(interstitialAd: null, isLoadedInterstitialAd: false));
      add(LoadInterstitialAd());
    }
  }

  FutureOr<void> _onShowRewardedAd(ShowRewardedAd event, Emitter<AdState> emit) {
    if(state.rewardedAd != null){
      //emit(state.copyWith(rewardedAdType: null));
      state.rewardedAd!.fullScreenContentCallback =FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) =>
          print('ad onAdshowedflullscreencontent'),
        onAdDismissedFullScreenContent: (ad){
          print('$ad onAdDismissedFullScreenContent');
          ad.dispose();
          add(LoadRewardedAd());
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('$ad onAdFailedToshowFullscreen');
          ad.dispose();
          add(LoadRewardedAd());
        },
      );
      state.rewardedAd!.setImmersiveMode(true);
      state.rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward){
          //emit(state.copyWith(reward: reward));
          print('*********************************************');
          add(RewardEarned(reward:reward, adType: event.adType));
          
        });

      // if(event.adType == AdType.rewardedPrincess){
      //   emit(state.copyWith(rewardedAd: null,isLoadedRewardedAd: false, reward: null,adWatchedPrincess: state.adWatchedPrincess! +1 ));

      // }else if(event.adType == AdType.rewardedQueen){

      //   emit(state.copyWith(rewardedAd: null,isLoadedRewardedAd: false, reward: null, adWatchedQueen: state.adWatchedQueen! +1 ));

      // }
      emit(state.copyWith(rewardedAd: null, numRewardedLoadAttempts: 0));
     // add(LoadRewardedAd());
    }
  }

  FutureOr<void> _onRewardEarned(RewardEarned event, Emitter<AdState> emit) {
    if(event.adType == AdType.rewardedRandom){
      emit(state.copyWith(totalAdWatchedReOn: state.totalAdWatchedReOn+1));
      
    }
    if(event.adType == AdType.rewardedOnline ){
      emit(state.copyWith(reward: event.reward,  rewardedAdType: event.adType, adWatchedOnline: state.adWatchedOnline == 0? state.adWatchedOnline!+1 : 0, totalAdWatchedReOn: state.totalAdWatchedReOn+1 ));
      

    }else if(event.adType == AdType.rewardedPrincess){
      int num = state.adWatchedPrincess! >= 9? 0 : state.adWatchedPrincess!+1;
      emit(state.copyWith(reward: event.reward,  rewardedAdType: event.adType, adWatchedPrincess: num  ));
    }else if(event.adType == AdType.rewardedQueen){
      emit(state.copyWith(reward: event.reward,  rewardedAdType: event.adType, adWatchedQueen: state.adWatchedQueen!+1 ));

    }else{
    emit(state.copyWith(reward: event.reward,  rewardedAdType: event.adType  ));
    }
  }

  FutureOr<void> _onResetReward(ResetReward event, Emitter<AdState> emit) {
    emit(state.copyWith(reward: null, rewardedAdType: null));
  }

  FutureOr<void> _onInterstitialAdFailedToLoad(InterstitialAdFailedToLoad event, Emitter<AdState> emit) {
    if(state.numInterstitialLoadAttempts < 5){
          add(LoadInterstitialAd());
          emit(state.copyWith(numInterstitialLoadAttempts: state.numInterstitialLoadAttempts +1));
        }
  }

  FutureOr<void> _onRewardedAdFailedToLoad(RewardedAdFailedToLoad event, Emitter<AdState> emit) {
    if(state.numRewardedLoadAttempts < 5){
          add(LoadRewardedAd());
          emit(state.copyWith(numRewardedLoadAttempts: state.numRewardedLoadAttempts+1));
        }
  }

  FutureOr<void> _onResetTotalReOn(ResetTotalReON event, Emitter<AdState> emit) {
    emit(state.copyWith(totalAdWatchedReOn: 0));
  }

  FutureOr<void> _onTimeOutAd(TimeOutAd event, Emitter<AdState> emit) {
    emit(state.copyWith(completedTimeAd: event.completedTimeAd,totalAdWatchedReOn: 100 ));
  }
  
  @override
  AdState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    return AdState.fromJson(json);
  }
  
  @override
  Map<String, dynamic>? toJson(AdState state) {
    // TODO: implement toJson
    return state.toJson();
  }
}
