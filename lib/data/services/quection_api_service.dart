import 'package:dio/dio.dart';
import 'package:fidenz_assignment_quizapp/models/quection_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuectionApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // get quections
  Future<QuectionModel> getQections() async {
    try {
      final response = await _dio.get('');

      if (response.statusCode == 200) {
        return QuectionModel.fromJson(response.data);
      } else {
        throw Exception(
          "Failed to fetch quections, status: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }
}
