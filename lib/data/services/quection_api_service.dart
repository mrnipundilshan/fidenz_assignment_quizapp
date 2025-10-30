import 'dart:convert';
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
        return QuectionModel.fromJson(json.decode(response.data));
      } else {
        throw Exception(
          "Failed to fetch quections, status: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      // Map common network scenarios to friendly messages
      final String message;
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          message = 'Request timed out. Please try again.';
          break;
        case DioExceptionType.connectionError:
          message = 'No internet connection. Check your network and retry.';
          break;
        case DioExceptionType.badResponse:
          final status = e.response?.statusCode;
          if (status != null && status >= 500) {
            message = 'Server is unavailable. Please try again later.';
          } else if (status == 404) {
            message = 'Content not found (404). Please try again later.';
          } else {
            message = 'Unexpected response from server.';
          }
          break;
        case DioExceptionType.cancel:
          message = 'Request was cancelled. Please retry.';
          break;
        case DioExceptionType.unknown:
        default:
          message = 'Unexpected error occurred. Please try again.';
          break;
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
