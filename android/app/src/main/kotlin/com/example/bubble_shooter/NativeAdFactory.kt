package com.example.bubble_shooter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class NativeAdFactory(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val nativeAdView = LayoutInflater.from(context)
            .inflate(R.layout.native_ad_layout, null) as NativeAdView

        // Set the headline
        nativeAdView.headlineView = nativeAdView.findViewById<TextView>(R.id.ad_headline)
        (nativeAdView.headlineView as TextView).text = nativeAd.headline

        // Set the body text
        nativeAdView.bodyView = nativeAdView.findViewById<TextView>(R.id.ad_body)
        if (nativeAd.body != null) {
            (nativeAdView.bodyView as TextView).text = nativeAd.body
            nativeAdView.bodyView?.visibility = View.VISIBLE
        } else {
            nativeAdView.bodyView?.visibility = View.INVISIBLE
        }

        // Set the app icon
        nativeAdView.iconView = nativeAdView.findViewById<ImageView>(R.id.ad_icon)
        if (nativeAd.icon != null) {
            (nativeAdView.iconView as ImageView).setImageDrawable(nativeAd.icon?.drawable)
            nativeAdView.iconView?.visibility = View.VISIBLE
        } else {
            nativeAdView.iconView?.visibility = View.GONE
        }

        nativeAdView.setNativeAd(nativeAd)
        return nativeAdView
    }
}