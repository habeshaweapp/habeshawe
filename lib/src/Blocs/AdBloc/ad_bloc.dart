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
        super(AdInitial()) {
    on<LoadNativeAd>(_onLoadNativeAd);

    on<OnAdLoaded>(_onAdLoaded);
    on<OnLoadAdError>(_onLoadAdError);
    on<LoadRewardedAd>(_onLoadRewardedAd);
    on<OnRewarededAdLoaded>(_onOnRewarededAdLoaded);

    add(LoadNativeAd());
    add(LoadNativeAd());
  }

  FutureOr<void> _onLoadNativeAd(LoadNativeAd event, Emitter<AdState> emit) {
    var ad = _adRepository.createNativeAd(
      onAdLoaded: (ad){
        add(OnAdLoaded(ad:ad));
        
      }, 
      onAdFailedToLoad: (ad, loadAdError){
        add(OnLoadAdError(ad: ad, error: loadAdError));

      });
      
   // final adState = state as 
    //emit(AdLoaded(nativeAd: ad));
    //return ad;

  }

  FutureOr<void> _onLoadAdError(OnLoadAdError event, Emitter<AdState> emit) {
    print('native Ad loaded');
  }

  FutureOr<void> _onAdLoaded(OnAdLoaded event, Emitter<AdState> emit) {
    print('Native ad loaded');
    if(state is AdLoaded){
     var ads = (state as AdLoaded);
     ads.nativeAd!.add(event.ad);
    emit(AdLoaded(nativeAd: ads.nativeAd ));

    }else{
      emit(AdLoaded(nativeAd: [event.ad]));

    }
    //event.ad.responseInfo.
    //event.ad.dispose();
  }

  FutureOr<void> _onLoadRewardedAd(LoadRewardedAd event, Emitter<AdState> emit) {
    var ad = _adRepository.createRewardAd(
      onAdLoaded: (ad){
        add(OnRewarededAdLoaded(ad: ad));
      }, 
      onAdFailedToLoad: (error){
        print(error);
      });
  }

  FutureOr<void> _onOnRewarededAdLoaded(OnRewarededAdLoaded event, Emitter<AdState> emit) {
    final adState = (state as AdLoaded);
    //emit(adState.copyWith(rewardedAd: event.ad));
      
      //RewardedAdLoaded(ad: event.ad));
  }


}
