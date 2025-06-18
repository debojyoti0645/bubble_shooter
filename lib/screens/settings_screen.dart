import 'package:bubble_shooter/services/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool soundEnabled = true;
  NativeAd? _settingsNativeAd;
  bool _isSettingsAdLoaded = false;
  BannerAd? _settingsBannerAd;
  bool _isSettingsBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadSettingsNativeAd();
    _loadSettingsBannerAd();
  }

  void _loadSettingsNativeAd() {
    _settingsNativeAd = NativeAd(
      adUnitId: AdHelper.settingsNativeAdUnitId,
      factoryId: 'settings',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isSettingsAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _settingsNativeAd = null;
          // Retry loading after delay
          Future.delayed(Duration(seconds: 30), () {
            if (mounted) {
              _loadSettingsNativeAd();
            }
          });
        },
      ),
    )..load();
  }

  void _loadSettingsBannerAd() {
    _settingsBannerAd = BannerAd(
      adUnitId: AdHelper.settings2BannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isSettingsBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _settingsBannerAd = null;
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _settingsNativeAd?.dispose();
    _settingsBannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2A0845).withOpacity(0.9),
              const Color(0xFF6441A5).withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back Button and Title
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Settings',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.pressStart2p(
                        fontSize: 26,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Settings Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: _buildSettingSwitch('Sound Effects', soundEnabled, (value) {
                  setState(() => soundEnabled = value);
                }),
              ),
              const SizedBox(height: 20),
              // Native Ad
              if (_isSettingsAdLoaded && _settingsNativeAd != null)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black12,
                  ),
                  height: 100,
                  child: AdWidget(ad: _settingsNativeAd!),
                ),
              const Spacer(),
              // Banner Ad
              if (_isSettingsBannerAdLoaded && _settingsBannerAd != null)
                Container(
                  alignment: Alignment.bottomCenter,
                  width: _settingsBannerAd!.size.width.toDouble(),
                  height: _settingsBannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _settingsBannerAd!),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingSwitch(
    String label,
    bool value,
    void Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF4E50), Color(0xFFF9D423)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.pressStart2p(fontSize: 14, color: Colors.white),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: Colors.white.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
