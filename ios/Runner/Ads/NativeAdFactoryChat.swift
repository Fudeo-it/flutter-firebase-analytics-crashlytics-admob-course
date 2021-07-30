import google_mobile_ads

class NativeAdFactoryChat : NSObject, FLTNativeAdFactory {
    func createNativeAd(_ nativeAd: GADNativeAd, customOptions: [AnyHashable: Any]? = nil) -> GADNativeAdView? {
        let nibView = Bundle.main.loadNibNamed("NativeAdChatView", owner: nil, options: nil)?.first
        
        guard let nativeAdView = nibView as? GADNativeAdView else {
            return nil
        }
        
        nativeAdView.nativeAd = nativeAd
        (nativeAdView.headlineView as! UILabel).text = nativeAd.headline
        (nativeAdView.bodyView as! UILabel).text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        
        return nativeAdView
    }
}
