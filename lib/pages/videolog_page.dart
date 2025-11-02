import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

import '../models/videolog.dart';
import '../widgets/videolog_card.dart';
import 'videolog_detail_page.dart';
import '../services/api_service.dart';

// 🚨 WidgetsBindingObserver 믹스인 추가
class _VideoLogPageState extends State<VideoLogPage> with WidgetsBindingObserver {
  final ApiService _apiService = ApiService();

  List<VideoLog> _videoLogs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // 1. 앱 라이프사이클 옵저버 등록
    WidgetsBinding.instance.addObserver(this);
    _fetchLogs();
  }

  @override
  void dispose() {
    // 2. 앱 라이프사이클 옵저버 해제
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 🚨 3. 라이프사이클 상태 변경 감지 메서드 추가
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // 상태가 'resumed' (다른 화면에서 이 화면으로 돌아옴) 일 때 데이터 다시 불러오기
    if (state == AppLifecycleState.resumed) {
      print("VideoLogPage resumed. Refreshing data.");
      _fetchLogs();
    }
  }

  // API 호출 및 데이터 변환 로직 (기존과 동일)
  Future<void> _fetchLogs() async {
    // ... (API 호출 및 데이터 처리 로직은 기존과 동일)
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

  // JSON 데이터를 VideoLog 모델 객체로 변환하는 핵심 로직 (기존과 동일)
  VideoLog _mapJsonToVideoLog(Map<String, dynamic> json) {
    // 1. 구역 이름 변환 (area_id -> A/B/C/D)
    String getAreaName(int areaId, String zoneName) {
      final areaPrefix = {0: 'A', 1: 'B', 2: 'C', 3: 'D'}[areaId] ?? 'Unknown';
      return '$areaPrefix-$zoneName';
    }

    // 2. 진행 상황 변환 (isIncidentResolved -> 감지/완료)
    String getStatus(bool isResolved) {
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

    // 5. 기타 임시값 및 매핑
    Severity severity = json['incidentType'] == 'fire' ? Severity.high : Severity.medium;
    String areaManager = '';
    bool isRealFire = json['incidentType'] == 'fire';

    return VideoLog(
      incidentNumber: json['id'] as int,
      detectedArea: getAreaName(json['area_id'] as int, json['zone_name'] as String),
      detectorType: getDetectorType(json['deviceType'] as String),
      detectorNumber: json['zone_id'] as int,
      severity: severity,
      areaManager: areaManager,
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