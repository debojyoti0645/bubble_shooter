import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services/ad_helper.dart';
import 'level_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BouncingBallsBackground(),
          Container(
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      'Bubble\nSort',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 48,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 60),
                    // Play Button
                    _buildButton(
                      context,
                      'Play',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LevelScreen()),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Settings Button
                    _buildButton(
                      context,
                      'Settings',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Add this at the bottom of the Stack
          if (_isBannerAdReady)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF4E50),
            Color(0xFFF9D423),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.pressStart2p(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class BouncingBallsBackground extends StatelessWidget {
  const BouncingBallsBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(15, (index) {
        return BallWidget();
      }),
    );
  }
}

class BallWidget extends StatefulWidget {
  const BallWidget({super.key});

  @override
  State<BallWidget> createState() => _BallWidgetState();
}

class _BallWidgetState extends State<BallWidget> with SingleTickerProviderStateMixin {
  late double x;
  late double y;
  late double dx;
  late double dy;
  late double size;
  late Color color;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    size = random.nextDouble() * 30 + 20; // Random size between 20 and 50
    x = random.nextDouble() * 300;
    y = random.nextDouble() * 500;
    dx = (random.nextDouble() - 0.5) * 5;
    dy = (random.nextDouble() - 0.5) * 5;
    color = Colors.primaries[random.nextInt(Colors.primaries.length)];

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1000),
    )..addListener(() {
        setState(() {
          x += dx;
          y += dy;

          if (x < 0 || x > 300) dx *= -1;
          if (y < 0 || y > 500) dy *= -1;
        });
      });

    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }
}
