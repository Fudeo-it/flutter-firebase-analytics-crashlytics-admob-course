package it.fudeo.telegram_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;
import it.fudeo.telegram_app.ads.NativeAdFactoryChat

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        flutterEngine.plugins.add(GoogleMobileAdsPlugin())
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "adFactoryChat", NativeAdFactoryChat(layoutInflater))

        super.configureFlutterEngine(flutterEngine)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "adFactoryChat")

        super.cleanUpFlutterEngine(flutterEngine)
    }

}
