// lib/services/api_service.dart

import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:8080/api';

  ApiService() {
    // Dio 설정 (옵션)
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  // 회원가입 API 메서드
  Future<Response> signup({
    required String username,
    required String password,
    required String author,
    required String email,
    required String phoneNumber,
    required int zoneId,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/signup',
        data: {
          "username": username,
          "password": password,
          "author": author,
          "email": email,
          "phone_number": phoneNumber,
          "zone_id": zoneId,
        },
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
        throw Exception('Signup failed: ${e.response?.data['message'] ?? e.message}');
      } else {
        print('Error sending request!');
        print(e.message);
        throw Exception('Network error or request failed: ${e.message}');
      }
    } catch (e) {
      print('Unknown error during signup: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // 로그인 API 메서드
  Future<Response> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          "username": username,
          "password": password,
        },
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio error (Server response) for login!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
        throw Exception('Login failed: ${e.response?.data['message'] ?? e.message}');
      } else {
        print('Dio error (Request failed) for login!');
        print(e.message);
        throw Exception('Network error or request failed: ${e.message}');
      }
    } catch (e) {
      print('Unknown error during login: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}