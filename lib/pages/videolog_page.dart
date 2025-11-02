import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

import '../models/videolog.dart';
import '../widgets/videolog_card.dart';
import 'videolog_detail_page.dart';
import '../services/api_service.dart'; // ApiService 임포트

class VideoLogPage extends StatefulWidget {
  const VideoLogPage({super.key});

  @override
  State<VideoLogPage> createState() => _VideoLogPageState();
}

class _VideoLogPageState extends State<VideoLogPage> {
  final ApiService _apiService = ApiService();

  List<VideoLog> _videoLogs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  // API 호출 및 데이터 변환 로직
  Future<void> _fetchLogs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiService.fetchIncidents();

      final List<dynamic> jsonResponse = response.data;

      final List<VideoLog> fetchedLogs = jsonResponse
          .map((json) => _mapJsonToVideoLog(json as Map<String, dynamic>))
          .toList();

      setState(() {
        _videoLogs = fetchedLogs;
        _isLoading = false;
      });

    } on DioException catch (e) {
       setState(() {
         // ApiService의 _handleDioError에서 던진 메시지 사용
         _error = e.message;
         _isLoading = false;
       });
    } catch (e) {
      setState(() {
        _error = '데이터를 불러오는 중 오류가 발생했습니다: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  // JSON 데이터를 VideoLog 모델 객체로 변환하는 핵심 로직
  VideoLog _mapJsonToVideoLog(Map<String, dynamic> json) {
    // 1. 구역 이름 변환 (area_id -> A/B/C/D)
    String getAreaName(int areaId, String zoneName) {
      final areaPrefix = {0: 'A', 1: 'B', 2: 'C', 3: 'D'}[areaId] ?? 'Unknown';
      return '$areaPrefix-$zoneName';
    }

    // 2. 진행 상황 변환 (isIncidentResolved -> 감지/완료)
    String getStatus(bool isResolved) {
      // '처리중' 상태가 API에 명시되지 않아 '감지' 또는 '완료'로만 처리
      return isResolved ? '완료' : '감지';
    }

    // 3. 탐지 유형 변환
    DetectorType getDetectorType(String deviceType) {
        if (deviceType.toLowerCase().contains('camera')) return DetectorType.camera;
        if (deviceType.toLowerCase().contains('sensor')) return DetectorType.smokeSensor;
        return DetectorType.camera;
    }

    // 4. 날짜/시간 파싱
    DateTime detectionTime;
    try {
      detectionTime = DateTime.parse(json['createdAt'].toString().replaceAll(' ', 'T'));
    } catch (e) {
      detectionTime = DateTime.now();
    }

    // 5. 기타 임시값 및 매핑 (JSON에 없는 항목 처리)
    Severity severity = json['incidentType'] == 'fire' ? Severity.high : Severity.medium;

    // 💡 담당자 정보 (areaManager)는 현재 API에 없으므로 빈 문자열 할당 후 상세 페이지에서 주석 처리
    String areaManager = '';

    bool isRealFire = json['incidentType'] == 'fire';

    return VideoLog(
      incidentNumber: json['id'] as int,
      detectedArea: getAreaName(json['area_id'] as int, json['zone_name'] as String),
      detectorType: getDetectorType(json['deviceType'] as String),
      detectorNumber: json['zone_id'] as int, // 임시로 zone_id 사용
      severity: severity,
      areaManager: areaManager, // 빈 문자열 할당
      detectionTime: detectionTime,
      status: getStatus(json['isIncidentResolved'] as bool),
      isRealFire: isRealFire,
    );
  }


  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchLogs,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    } else if (_videoLogs.isEmpty) {
      content = const Center(child: Text('영상 기록이 없습니다.'));
    } else {
      content = ListView.builder(
        reverse: false,
        padding: const EdgeInsets.all(16.0),
        itemCount: _videoLogs.length,
        itemBuilder: (context, index) {
          final log = _videoLogs[index];
          return VideoLogCard(
            log: log,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoLogDetailPage(log: log),
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      body: content,
    );
  }
}