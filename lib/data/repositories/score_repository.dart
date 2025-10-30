import 'package:fidenz_assignment_quizapp/data/services/local_storage_service.dart';

class ScoreRepository {
  final LocalStorageService _service = LocalStorageService();

  // get high score
  Future<int> getHighScore() => _service.getHighScore();

  // save high score
  Future<void> saveHighScore(int newScore) async {
    final currentHighScore = await _service.getHighScore();
    if (newScore > currentHighScore) {
      await _service.saveHighScore(newScore);
    }
  }
}
