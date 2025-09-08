import 'package:shared_preferences/shared_preferences.dart';

class PointsService {
  static const String _pointsKey = 'bubble_points';
  static const String _lastAdWatchKey = 'last_ad_watch';
  static const String _welcomeBonusClaimedKey = 'welcome_bonus_claimed';

  static Future<int> getPoints() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_pointsKey) ?? 0;
  }

  static Future<void> setPoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pointsKey, points);
  }

  static Future<void> addPoints(int amount) async {
    final current = await getPoints();
    await setPoints(current + amount);
  }

  static Future<void> deductPoints(int amount) async {
    final current = await getPoints();
    await setPoints(current - amount);
  }

  static Future<DateTime?> getLastAdWatch() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString(_lastAdWatchKey);
    return dateStr != null ? DateTime.tryParse(dateStr) : null;
  }

  static Future<void> setLastAdWatch(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastAdWatchKey, time.toIso8601String());
  }

  static Future<bool> hasClaimedWelcomeBonus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_welcomeBonusClaimedKey) ?? false;
  }

  static Future<void> claimWelcomeBonus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasBeenClaimed = await hasClaimedWelcomeBonus();
    
    if (!hasBeenClaimed) {
      await addPoints(10); // Add 10 points welcome bonus
      await prefs.setBool(_welcomeBonusClaimedKey, true);
    }
  }
}