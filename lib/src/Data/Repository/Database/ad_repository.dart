import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdRepository{
  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  
  NativeAd? _nativeAd;
  static String get rewardAdUnitId{
    return Platform.isAndroid ?
      'ca-app-pub-3940256099942544/5224354917' : '';
  }

  static String get nativeAdUnitId{
    return Platform.isAndroid ?
      'ca-app-pub-3940256099942544/1044960115' : '';
  }

  void createRewardAd({required void Function(RewardedAd) onAdLoaded, required void Function(LoadAdError) onAdFailedToLoad} ){
    RewardedAd.load(
      adUnitId: rewardAdUnitId, 
      request: const AdRequest(), 
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: onAdLoaded, 
        onAdFailedToLoad: onAdFailedToLoad)
      );
  }

  NativeAd createNativeAd({required void Function(Ad) onAdLoaded,required void Function(Ad, LoadAdError) onAdFailedToLoad}){
    return NativeAd(
      adUnitId: nativeAdUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.grey,
        cornerRadius: 15
        )

    )..load();
  }



  
}