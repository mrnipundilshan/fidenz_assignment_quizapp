import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _highScoreKey = "highScore";

  // get high score from shared preferences
  Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey) ?? 0;
  }

  // save high score
  Future<void> saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_highScoreKey, score);
  }
}
