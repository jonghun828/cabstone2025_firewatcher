// lib/models/videolog.dart

import 'package:flutter/material.dart'; // 필요시

enum DetectorType {
  camera,
  smokeSensor,
  temperatureSensor,
  // ... 기타 감지기 유형
}

enum Severity {
  low,
  medium,
  high,
}

class VideoLog {
  final int incidentNumber; // 사건 번호
  final String detectedArea; // 감지된 구역 (예: A-숲)
  final DetectorType detectorType; // 감지기 유형
  final int detectorNumber; // 감지기 번호
  final Severity severity; // 심각도
  final String areaManager; // 담당자
  final DateTime detectionTime; // 감지 시간
  final String status; // 상태 (감지, 처리중, 완료, 오인)
  final bool isRealFire; // 실제 화재 여부

  VideoLog({
    required this.incidentNumber,
    required this.detectedArea,
    required this.detectorType,
    required this.detectorNumber,
    required this.severity,
    required this.areaManager,
    required this.detectionTime,
    required this.status,
    required this.isRealFire,
  });
}