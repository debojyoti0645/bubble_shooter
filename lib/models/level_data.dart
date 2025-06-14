import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelData {
  static const String _starsKey = 'stars';
  static const String _unlockedLevelKey = 'unlockedLevel';

  // Get stars map from prefs
  static Future<Map<String, int>> getStars() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_starsKey);
    if (jsonStr == null) return {};
    return Map<String, int>.from(jsonDecode(jsonStr));
  }

  // Set stars for a level
  static Future<void> setStars(int level, int stars) async {
    final prefs = await SharedPreferences.getInstance();
    final starsMap = await getStars();
    starsMap[level.toString()] = stars;
    await prefs.setString(_starsKey, jsonEncode(starsMap));
  }

  // Get highest unlocked level
  static Future<int> getUnlockedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_unlockedLevelKey) ?? 1;
  }

  // Unlock next level if current level >= unlocked
  static Future<void> unlockNextLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    final currentUnlocked = await getUnlockedLevel();
    if (level >= currentUnlocked) {
      await prefs.setInt(_unlockedLevelKey, level + 1);
    }
  }
}

class LevelIndicator extends StatelessWidget {
  final int currentLevel;

  const LevelIndicator({
    Key? key,
    required this.currentLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Level $currentLevel',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
