import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdCubit extends Cubit<NativeAd?> {
  NativeAdCubit() : super(null) {
    NativeAd? nativeAd;
    nativeAd = NativeAd(
      adUnitId: 'ca-app-pub-3940256099942544/2247696110',
      factoryId: 'adFactoryChat',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          Fimber.d('Ad loaded');

          emit(nativeAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          Fimber.w('Ad failed to load: $error');
        }
      ),
    )..load();
  }
}