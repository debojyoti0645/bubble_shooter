package com.example.bubble_shooter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class SettingsNativeAdFactory(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val nativeAdView = LayoutInflater.from(context)
            .inflate(R.layout.settings_native_ad_layout, null) as NativeAdView

        with(nativeAdView) {
            headlineView = findViewById<TextView>(R.id.ad_headline)
            bodyView = findViewById<TextView>(R.id.ad_body)
            iconView = findViewById<ImageView>(R.id.ad_icon)

            (headlineView as TextView).text = nativeAd.headline
            
            if (nativeAd.body != null) {
                (bodyView as TextView).text = nativeAd.body
                bodyView?.visibility = View.VISIBLE
            } else {
                bodyView?.visibility = View.INVISIBLE
            }

            if (nativeAd.icon != null) {
                (iconView as ImageView).setImageDrawable(nativeAd.icon?.drawable)
                iconView?.visibility = View.VISIBLE
            } else {
                iconView?.visibility = View.GONE
            }

            setNativeAd(nativeAd)
        }

        return nativeAdView
    }
}