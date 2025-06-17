import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../models/level_data.dart';
import '../services/ad_helper.dart';
import '../widgets/animated_star.dart';
import '../widgets/bubble_points_display.dart';
import '../widgets/coin_notification.dart';
import 'game_screen.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  int unlockedLevel = 1;
  Map<String, int> stars = {};
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;
  List<NativeAd?> _nativeAds = [];
  List<bool> _isNativeAdReady = [];
  static const int _adInterval = 6;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _loadBannerAd();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeNativeAds();
  }

  void _initializeNativeAds() {
    // Calculate visible items based on screen height
    final screenHeight = MediaQuery.of(context).size.height;
    final visibleItems = (screenHeight / 120).ceil() * 3;
    final numberOfAds = (visibleItems / _adInterval).ceil();
    
    // Only initialize if not already initialized with same size
    if (_nativeAds.length != numberOfAds) {
      // Dispose existing ads
      for (var ad in _nativeAds) {
        ad?.dispose();
      }
      
      _nativeAds = List.generate(numberOfAds, (index) => null);
      _isNativeAdReady = List.generate(numberOfAds, (index) => false);

      for (int i = 0; i < numberOfAds; i++) {
        _loadNativeAd(i);
      }
    }
  }

  void _loadNativeAd(int index) {
    if (_nativeAds[index] != null) {
      _nativeAds[index]!.dispose();
    }

    _nativeAds[index] = NativeAd(
      adUnitId: AdHelper.nativeAdUnitId,
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isNativeAdReady[index] = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _nativeAds[index] = null;
          // Retry loading after a delay
          Future.delayed(Duration(seconds: 30), () {
            if (mounted) {
              _loadNativeAd(index);
            }
          });
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    for (var ad in _nativeAds) {
      ad?.dispose();
    }
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _isBannerAdReady = false;
        },
      ),
    );

    _bannerAd?.load();
  }

  Future<void> _loadProgress() async {
    final level = await LevelData.getUnlockedLevel();
    final savedStars = await LevelData.getStars();
    setState(() {
      unlockedLevel = level;
      stars = savedStars;
    });
  }

  Widget _buildStarRow(int level) {
    int starCount = stars[level.toString()] ?? 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: AnimatedStar(filled: index < starCount),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final levels = List.generate(5000, (i) => i + 1);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF2A0845),
            const Color(0xFF6441A5),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Level',
            style: GoogleFonts.pressStart2p(
              fontSize: 20,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: BubblePointsDisplay(),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: levels.length + (levels.length / _adInterval).floor(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  // Calculate if this position should be an ad
                  final adIndex = (index + 1) / (_adInterval + 1);
                  if (adIndex.floor() == adIndex) {
                    final nativeAdIndex = adIndex.toInt() - 1;
                    if (nativeAdIndex < _nativeAds.length && _isNativeAdReady[nativeAdIndex]) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.withOpacity(0.3),
                              Colors.blue.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: AdWidget(ad: _nativeAds[nativeAdIndex]!),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }

                  // Calculate the actual level index
                  final levelIndex = index - (index / (_adInterval + 1)).floor();
                  final level = levels[levelIndex];
                  final isLocked = level > unlockedLevel;

                  return GestureDetector(
                    onTap: isLocked
                        ? () => _showLockedDialog(context, level)
                        : () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GameScreen(level: level),
                              ),
                            );
                            // Refresh level data when returning from game screen
                            if (mounted) {
                              _loadProgress();
                            }
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: isLocked
                            ? LinearGradient(
                                colors: [
                                  Colors.grey.shade800,
                                  Colors.grey.shade700,
                                ],
                              )
                            : LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 78, 178, 255),
                                  Color.fromARGB(255, 54, 110, 240),
                                ],
                              ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isLocked
                                ? Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black38,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.lock_rounded,
                                      size: 28,
                                      color: Colors.white70,
                                    ),
                                  )
                                : Text(
                                    '$level',
                                    style: GoogleFonts.pressStart2p(
                                      fontSize: 24,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                            SizedBox(height: 8),
                            if (!isLocked) _buildStarRow(level),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isBannerAdReady)
              Container(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
          ],
        ),
      ),
    );
  }

  void _showSkipLevelDialog(BuildContext context, int level) async {
    final points = await LevelData.getBubblePoints();
    if (points < 5) {
      CoinNotification.show(context, 5);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2A0845),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Skip Level',
          style: GoogleFonts.pressStart2p(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        content: Text(
          'Use 5 Bubble Points to unlock this level?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await LevelData.updateBubblePoints(-5);
              await LevelData.unlockNextLevel(level);
              Navigator.pop(context);
              setState(() {
                unlockedLevel = level + 1;
              });
            },
            child: Text(
              'Skip',
              style: TextStyle(color: Color(0xFFF9D423)),
            ),
          ),
        ],
      ),
    );
  }

  void _showLockedDialog(BuildContext context, int level) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2A0845),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.lock_rounded, color: Color(0xFFF9D423)),
            SizedBox(width: 8),
            Text(
              'Level Locked',
              style: GoogleFonts.pressStart2p(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Complete the previous level to unlock this one!',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Or use 5 Bubble Points to skip',
              style: TextStyle(color: Colors.amber),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSkipLevelDialog(context, level);
            },
            child: Text(
              'Skip Level',
              style: TextStyle(color: Color(0xFFF9D423)),
            ),
          ),
        ],
      ),
    );
  }
}
