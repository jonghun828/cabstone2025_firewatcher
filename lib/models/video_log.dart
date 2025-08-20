// lib/models/video_log.dart

import 'package:flutter/material.dart';

// 심각도 Enum 및 색상/표시명 Extension 수정
enum Severity {
  low,       // 낮음 (노랑)
  medium,    // 보통 (주황)
  high,      // 높음 (빨강)
}

extension SeverityColor on Severity {
  Color get color {
    switch (this) {
      case Severity.low: return Colors.yellow;    // 노랑
      case Severity.medium: return Colors.orange;  // 주황
      case Severity.high: return Colors.red;       // 빨강
    }
  }

  String get displayName {
    switch (this) {
      case Severity.low: return '낮음';
      case Severity.medium: return '보통';
      case Severity.high: return '높음';
    }
  }
}

// 감지기 타입 Enum 수정 (unknown 제거)
enum DetectorType {
  camera,
  smokeSensor,
  heatSensor,
  // unknown, // <-- 이 부분을 제거합니다.
}

extension DetectorTypeString on DetectorType {
  String toShortString() {
    switch (this) {
      case DetectorType.camera: return 'C';
      case DetectorType.smokeSensor: return 'S';
      case DetectorType.heatSensor: return 'H';
    }
  }
}

// VideoLog 클래스는 그대로 유지됩니다.
class VideoLog {
  final int incidentNumber;
  final String detectedArea;
  final DetectorType detectorType;
  final int detectorNumber;
  final Severity severity;
  final String areaManager;
  final DateTime detectionTime;
  final String status;
  final bool isRealFire;

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

  String get detectorName => '${detectorType.toShortString()}-$detectorNumber';
}