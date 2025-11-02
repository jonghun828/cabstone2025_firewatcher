// lib/services/api_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ----------------------------------------------------
// [공통 오류 처리 함수]
// ----------------------------------------------------

Exception _handleDioError(DioException e, String defaultMessage) {
  if (e.response != null) {
    print('Dio Error (Server response): ${e.requestOptions.path}');
    print('STATUS: ${e.response?.statusCode}');
    print('DATA: ${e.response?.data}');

    final statusCode = e.response?.statusCode;
    final errorMessage = e.response?.data['message'] ?? e.message;

    if (statusCode == 401) {
      return Exception('인증 실패: 토큰이 없거나 만료되었습니다. 다시 로그인해주세요.');
    }

    return Exception('$defaultMessage: $errorMessage (코드: $statusCode)');
  } else {
    print('Dio Error (Request failed): ${e.message}');
    return Exception('네트워크 오류: 서버에 연결할 수 없습니다.');
  }
}

// ----------------------------------------------------
// [API 서비스 클래스]
// ----------------------------------------------------

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:8080/api';

  final _storage = const FlutterSecureStorage();
  static const String ACCESS_TOKEN_KEY = 'access_token';

  ApiService() {
    // 1. Dio 기본 설정
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    _dio.options.headers['Content-Type'] = 'application/json';

    // 2. 인터셉터 추가: 모든 요청 전에 토큰을 헤더에 자동 삽입
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: ACCESS_TOKEN_KEY);

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            print('-> Request with Token: ${options.path}');
          }
          return handler.next(options);
        },
      ),
    );
  }

  // ----------------------------------------------------
  // [데이터 추가 (POST)]
  // ----------------------------------------------------

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
          "phoneNumber": phoneNumber,
          "zone_id": zoneId,
        },
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Signup failed');
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
      throw _handleDioError(e, 'Failed to create notice');
    }
  }

  // 댓글 작성 API 메서드
  Future<Response> createComment({
    required int noticeId,
    required String content,
  }) async {
    try {
      final response = await _dio.post(
        '/notices/$noticeId/comments',
        data: {
          "content": content,
        },
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to create comment');
    } catch (e) {
      throw Exception('An unexpected error occurred during createComment: ${e.toString()}');
    }
  }

  // ----------------------------------------------------
  // [데이터 조회 (GET)]
  // ----------------------------------------------------

  // 구역 목록 데이터 조회 API 메서드
  Future<Response> fetchZones() async {
    try {
      final response = await _dio.get('/zones');
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to fetch zone data');
    } catch (e) {
      throw Exception('An unexpected error occurred during fetchZones: ${e.toString()}');
    }
  }

  // 영상 기록 목록 데이터 조회 API 메서드
  Future<Response> fetchVideoRecords() async {
    try {
      final response = await _dio.get('/videos');
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to fetch video records');
    } catch (e) {
      throw Exception('An unexpected error occurred during fetchVideoRecords: ${e.toString()}');
    }
  }

  // 공지 게시판 목록 데이터 조회 API 메서드
  Future<Response> fetchNotices() async {
    try {
      final response = await _dio.get('/notices');
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to fetch notices');
    } catch (e) {
      throw Exception('An unexpected error occurred during fetchNotices: ${e.toString()}');
    }
  }
  // 단일 게시글 상세 정보 및 댓글 목록 조회
  Future<Response> fetchNoticeDetail(int noticeId) async {
    try {
      final response = await _dio.get('/notices/$noticeId');
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to fetch notice detail');
    } catch (e) {
      throw Exception('An unexpected error occurred during fetchNoticeDetail: ${e.toString()}');
    }
  }

  // zoneId에 해당하는 구역의 모든 장치 목록을 조회합니다.
  Future<Response> fetchZoneSensors(int zoneId) async {
    try {
      final response = await _dio.get('/zone/$zoneId');
      return response;
    } on DioException catch (e) {
      // Dio 오류 처리 로직
      throw Exception('구역($zoneId) 센서 로드 실패: ${e.message}');
    } catch (e) {
      // 기타 예외 처리
      throw Exception('예상치 못한 오류 발생: ${e.toString()}');
    }
  }
}