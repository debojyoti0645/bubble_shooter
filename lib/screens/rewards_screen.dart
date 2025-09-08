import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services/ad_helper.dart';
import '../services/points_service.dart';
import '../widgets/bubble_points_display.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;
  DateTime? _lastAdWatchTime;
  Timer? _countdownTimer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
    _loadLastAdWatchTime();
  }

  Future<void> _loadLastAdWatchTime() async {
    final lastWatch = await PointsService.getLastAdWatch();
    setState(() {
      _lastAdWatchTime = lastWatch;
      if (lastWatch != null) {
        _startCountdownTimer();
      }
    });
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    
    // Calculate remaining time
    final difference = DateTime.now().difference(_lastAdWatchTime!);
    final remainingTime = Duration(seconds: 10) - difference;
    if (remainingTime.isNegative) {
      setState(() {
        _remainingSeconds = 0;
      });
      return;
    }

    setState(() {
      _remainingSeconds = remainingTime.inSeconds;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
            _isRewardedAdReady = true;
          });
        },
        onAdFailedToLoad: (error) {
          print('Failed to load rewarded ad: ${error.message}');
        },
      ),
    );
  }

  bool get _canWatchAd {
    if (_lastAdWatchTime == null) return true;
    final difference = DateTime.now().difference(_lastAdWatchTime!);
    return difference.inSeconds >= 10;
  }

  void _showRewardedAd() {
    if (!_isRewardedAdReady) return;

    bool hasEarnedReward = false;

    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        // When ad is shown, prevent interaction with background
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      },
      onAdDismissedFullScreenContent: (ad) {
        // Restore system UI when ad is dismissed
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        ad.dispose();
        _loadRewardedAd();
        if (hasEarnedReward) {
          setState(() {
            _lastAdWatchTime = DateTime.now();
          });
          PointsService.setLastAdWatch(_lastAdWatchTime!);
          _startCountdownTimer();
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        // Restore system UI on error
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        ad.dispose();
        _loadRewardedAd();
      },
    );

    _rewardedAd?.show(
      onUserEarnedReward: (_, reward) async {
        hasEarnedReward = true;
        await PointsService.addPoints(1);
      },
    );
  }

  String _getTimeText() {
    if (_remainingSeconds <= 0) return 'Ready to watch!';
    return 'Wait ${_remainingSeconds}s for next ad';
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Widget _buildRewardCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
    required bool isAvailable,
    String? cooldownText,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: isAvailable ? onTap : null,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors:
                  isAvailable
                      ? [
                        Colors.purple.withOpacity(0.7),
                        Colors.blue.withOpacity(0.7),
                      ]
                      : [Colors.grey.shade700, Colors.grey.shade600],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.pressStart2p(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      if (cooldownText != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          cooldownText,
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Rewards',
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
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            _buildRewardCard(
              title: 'Watch Ad',
              description: 'Watch a video ad to earn 1 bubble point',
              icon: Icons.movie,
              onTap: _showRewardedAd,
              isAvailable: _isRewardedAdReady && _canWatchAd,
              cooldownText: !_canWatchAd ? _getTimeText() : null,
            ),
            // Add more reward options as needed
          ],
        ),
      ),
    );
  }
}
