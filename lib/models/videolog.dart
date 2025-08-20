import 'package:flutter/material.dart';

enum Severity {
  low,
  medium,
  high,
}

extension SeverityColor on Severity {
  Color get color {
    switch (this) {
      case Severity.low: return Colors.yellow;
      case Severity.medium: return Colors.orange;
      case Severity.high: return Colors.red;
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

enum DetectorType {
  camera,
  smokeSensor,
  heatSensor,
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

class VideoLog {
  final int incidentNumber;     // 사건 번호
  final String detectedArea;    // 감지된 구역
  final DetectorType detectorType;  // 감지한 장치의 타입
  final int detectorNumber;        // 감지한 장치의 번호
  final Severity severity;         // 감지 심각도
  final String areaManager;        // 구역 담당자 이름
  final DateTime detectionTime;    // 최초 감지 시간
  final String status;             // 사건 상태
  final bool isRealFire;           // 실제 화재 여부

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