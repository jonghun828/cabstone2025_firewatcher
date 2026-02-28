// lib/pages/videolog_page.dart

import 'package:flutter/material.dart';
import '../models/videolog.dart'; // VideoLog 모델 임포트
import '../widgets/videolog_card.dart'; // VideoLogCard 위젯 임포트
import 'videolog_detail_page.dart'; // 상세 페이지 임포트

class VideoLogPage extends StatefulWidget {
  const VideoLogPage({super.key});

  @override
  State<VideoLogPage> createState() => _VideoLogPageState();
}

class _VideoLogPageState extends State<VideoLogPage> {
  // 임시 영상 기록 데이터
  final List<VideoLog> _videoLogs = [
    VideoLog(
      incidentNumber: 1,
      detectedArea: 'A-숲',
      detectorType: DetectorType.camera,
      detectorNumber: 3,
      severity: Severity.high,
      areaManager: '김철수',
      detectionTime: DateTime(2025, 8, 13, 14, 30),
      status: '완료',
      isRealFire: true,
    ),
    VideoLog(
      incidentNumber: 2,
      detectedArea: 'C-산책로',
      detectorType: DetectorType.smokeSensor,
      detectorNumber: 5,
      severity: Severity.high,
      areaManager: '박영희',
      detectionTime: DateTime(2025, 8, 13, 15, 10),
      status: '처리중',
      isRealFire: true,
    ),
    VideoLog(
      incidentNumber: 3,
      detectedArea: 'B-주차장',
      detectorType: DetectorType.camera,
      detectorNumber: 1,
      severity: Severity.medium,
      areaManager: '이민준',
      detectionTime: DateTime(2025, 8, 12, 10, 00),
      status: '감지',
      isRealFire: false, // 오인
    ),
    VideoLog(
      incidentNumber: 4,
      detectedArea: 'A-정문',
      detectorType: DetectorType.temperatureSensor,
      detectorNumber: 2,
      severity: Severity.low,
      areaManager: '최영희',
      detectionTime: DateTime(2025, 8, 11, 09, 20),
      status: '완료',
      isRealFire: true,
    ),
    VideoLog(
      incidentNumber: 5,
      detectedArea: 'D-놀이터',
      detectorType: DetectorType.camera,
      detectorNumber: 4,
      severity: Severity.medium,
      areaManager: '홍길동',
      detectionTime: DateTime(2025, 8, 10, 18, 45),
      status: '오인',
      isRealFire: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🚨 AppBar 제거: MainPage에서 이미 AppBar를 관리하고 있습니다.
      // body만 제공하여 MainPage의 탭으로 동작하도록 합니다.
      body: _videoLogs.isEmpty
          ? const Center(child: Text('영상 기록이 없습니다.'))
          : ListView.builder(
              // 최신 로그가 위에 오도록 역순으로 표시 (선택적)
              reverse: false,
              padding: const EdgeInsets.all(16.0),
              itemCount: _videoLogs.length,
              itemBuilder: (context, index) {
                final log = _videoLogs[index];
                return VideoLogCard(
                  log: log,
                  onTap: () {
                    // 상세 페이지로 이동하며 VideoLog 객체를 전달
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoLogDetailPage(log: log),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}