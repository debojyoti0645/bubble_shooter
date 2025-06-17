import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // real ad unit ID for Android
      //return 'ca-app-pub-7104002362240268/6147965125';
      // For testing, uncomment the line below and comment the line above
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    throw UnsupportedError('This app only supports Android platform');
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      // real ad unit ID for Android
      //return 'ca-app-pub-7104002362240268/9594022595';
      // For testing
      return 'ca-app-pub-3940256099942544/2247696110';
    }
    throw UnsupportedError('This app only supports Android platform');
  }
}