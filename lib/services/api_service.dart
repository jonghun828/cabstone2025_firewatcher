import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:8080/api';

  // 2. 토큰 저장소 인스턴스 및 토큰 키 상수
  final _storage = const FlutterSecureStorage();
  static const String ACCESS_TOKEN_KEY = 'access_token';

  ApiService() {
    // Dio 설정 (옵션)
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    _dio.options.headers['Content-Type'] = 'application/json';

    // 3. 인터셉터 추가: 모든 요청 전에 토큰을 헤더에 삽입
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 토큰을 안전한 저장소에서 읽어옴
          final token = await _storage.read(key: ACCESS_TOKEN_KEY);

          // 토큰이 존재하고, 인증이 필요한 API 요청(로그인/회원가입 제외)일 경우
          if (token != null) {
            // 요청 헤더에 Authorization 필드 추가
            options.headers['Authorization'] = 'Bearer $token';
            print('-> Request with Token: ${options.path}');
          }
          return handler.next(options);
        },
        // 토큰 만료 등 오류 처리 로직
      ),
    );
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
      throw _handleDioError(e, 'Signup failed');
    } catch (e) {
      throw Exception('An unexpected error occurred during signup: $e');
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
      throw _handleDioError(e, 'Login failed');
    } catch (e) {
      throw Exception('An unexpected error occurred during login: $e');
    }
  }

  // 공지작성 API 메서드
  Future<Response> createNotice({
    required String title,
    required String content,
    required bool important,
  }) async {
    try {
      final response = await _dio.post(
        '/notices',
        data: {
          "title": title,
          "content": content,
          "important": important,
        },
      );
      return response;
    } on DioException catch (e) {
      // 401(토큰 만료/누락)
      throw _handleDioError(e, 'Failed to create notice');
    } catch (e) {
      throw Exception('An unexpected error occurred during createNotice: $e');
    }
  }

  Exception _handleDioError(DioException e, String defaultMessage) {
    if (e.response != null) {
      print('Dio Error (Server response): ${e.requestOptions.path}');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');

      // 서버 응답에서 오류 메시지를 추출
      final errorMessage = e.response?.data['message'] ?? e.message;

      // 401 Unauthorized 처리
      if (e.response?.statusCode == 401) {
        return Exception('인증 실패: 토큰이 없거나 만료되었습니다.');
      }

      return Exception('$defaultMessage: $errorMessage');
    } else {
      print('Dio Error (Request failed): ${e.message}');
      return Exception('네트워크 오류 또는 요청 실패: ${e.message}');
    }
  }
}