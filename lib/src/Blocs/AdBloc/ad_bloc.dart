import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lomi/src/Data/Repository/Database/ad_repository.dart';

part 'ad_event.dart';
part 'ad_state.dart';

class AdBloc extends Bloc<AdEvent, AdState> {
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
    

    //add(LoadNativeAd());
    add(LoadRewardedAd());
    add(LoadInterstitialAd());
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
     _adRepository.createRewardAd(
      onAdLoaded: (ad){
        add(OnRewarededAdLoaded(ad: ad));
      }, 
      onAdFailedToLoad: (error){
        print(error);
        add(RewardedAdFailedToLoad());
      });
  }

  FutureOr<void> _onOnRewarededAdLoaded(OnRewarededAdLoaded event, Emitter<AdState> emit) {
    
    emit(state.copyWith(rewardedAd: event.ad, isLoadedRewardedAd: true, reward: null, numRewardedLoadAttempts: 0));
      
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
          add(RewardEarned(reward:reward));
          
        });

     
      emit(state.copyWith(rewardedAd: null,isLoadedRewardedAd: false, reward: null));
      add(LoadRewardedAd());
    }
  }

  FutureOr<void> _onRewardEarned(RewardEarned event, Emitter<AdState> emit) {
    emit(state.copyWith(reward: event.reward));
  }

  FutureOr<void> _onResetReward(ResetReward event, Emitter<AdState> emit) {
    emit(state.copyWith(reward: null));
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
}
