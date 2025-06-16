import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  static const String _musicEnabledKey = 'musicEnabled';

  factory AudioService() => _instance;

  AudioService._internal();

  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  bool _isMusicEnabled = true;
  bool _isInitialized = false;
  bool _isInForeground = true;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Load saved preferences
      final prefs = await SharedPreferences.getInstance();
      _isMusicEnabled = prefs.getBool(_musicEnabledKey) ?? true;

      // Setup background music
      await _backgroundMusicPlayer.setAsset('assets/audio/bgm.mp3');
      await _backgroundMusicPlayer.setLoopMode(LoopMode.all);
      
      // Only play if music is enabled
      if (_isMusicEnabled && _isInForeground) {
        await _backgroundMusicPlayer.play();
      } else {
        await _backgroundMusicPlayer.pause();
      }
      
      _isInitialized = true;
    } catch (e) {
      print("Error initializing audio: $e");
      _isInitialized = false;
    }
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _isMusicEnabled = enabled;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_musicEnabledKey, enabled);

      if (_isInitialized) {
        if (enabled && _isInForeground) {
          await _backgroundMusicPlayer.play();
        } else {
          await _backgroundMusicPlayer.pause();
        }
      }
      
      notifyListeners();
    } catch (e) {
      print("Error toggling music: $e");
    }
  }

  void onAppPaused() {
    _isInForeground = false;
    if (_backgroundMusicPlayer.playing) {
      _backgroundMusicPlayer.pause();
    }
  }

  void onAppResumed() {
    _isInForeground = true;
    if (_isMusicEnabled && _isInitialized) {
      _backgroundMusicPlayer.play();
    }
  }

  bool get isMusicEnabled => _isMusicEnabled;

  @override
  void dispose() {
    _backgroundMusicPlayer.dispose();
    super.dispose();
  }
}