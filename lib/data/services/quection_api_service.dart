import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuectionApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'content-Type': 'application/json'},
    ),
  );
}
