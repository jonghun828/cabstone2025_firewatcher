// lib/models/sensor.dart

import 'package:flutter/material.dart'; // IconData 사용을 위해 필요할 수 있습니다.

enum SensorType {
  camera,
  smokeSensor,
  temperatureSensor,
  humiditySensor,
  windSensor,
  // 필요한 다른 센서 유형 추가
}

class Sensor {
  final String areaName;        // 구역 이름 (예: 'A')
  final String sensorNumber;    // 센서 고유 번호 (예: 'C-001')
  final String locationName;    // 구역 내 상세 위치 이름 (예: '숲', '산책로')
  final SensorType sensorType;  // 센서 유형 (예: 카메라, 연기 센서 등) 👈 추가
  final bool isConnected;       // 연결 상태

  Sensor({
    required this.areaName,
    required this.sensorNumber,
    required this.locationName,
    this.sensorType = SensorType.camera, // 기본값 설정 (필요에 따라 변경)
    required this.isConnected,
  });

  // 'A-숲'과 같이 구역 이름과 위치 이름을 합쳐서 표시하는 getter
  String get fullDisplayName => '$areaName-$locationName';

  // 센서 유형을 사람이 읽을 수 있는 문자열로 반환하는 getter
  String get sensorTypeName {
    switch (sensorType) {
      case SensorType.camera: return '카메라';
      case SensorType.smokeSensor: return '연기 센서';
      case SensorType.temperatureSensor: return '온도 센서';
      case SensorType.humiditySensor: return '습도 센서';
      case SensorType.windSensor: return '풍향 센서';
    }
  }
}