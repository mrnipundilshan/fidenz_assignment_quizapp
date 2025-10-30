import 'package:fidenz_assignment_quizapp/data/services/quection_api_service.dart';
import 'package:fidenz_assignment_quizapp/models/quection_model.dart';

class QuectionRepository {
  final QuectionApiService _apiService;

  QuectionRepository(this._apiService);

  // get quections
  Future<QuectionModel> getQections() async {
    return _apiService.getQections();
  }
}
