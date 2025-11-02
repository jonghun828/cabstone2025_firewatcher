// lib/models/sensor.dart

import 'package:flutter/material.dart';

enum SensorType {
  camera,
  smokeSensor,
  temperatureSensor,
}

class Sensor {
  final String areaName;
  final String sensorNumber;
  final String locationName;
  final SensorType sensorType;
  final bool isConnected;

  Sensor({
    required this.areaName,
    required this.sensorNumber,
    required this.locationName,
    required this.sensorType,
    required this.isConnected,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    SensorType parseSensorType(String type) {
      final lowerType = type.toLowerCase();
      if (lowerType.contains('camera')) return SensorType.camera;
      if (lowerType.contains('smoke')) return SensorType.smokeSensor;
      if (lowerType.contains('temperature') || lowerType.contains('열')) return SensorType.temperatureSensor;

      // 정의된 3가지 타입 외에는 카메라로 처리
      return SensorType.camera;
    }

    final isConnected = json['areaIpAddress'] != null && json['areaIpAddress'] != '';
    final deviceTypeStr = json['deviceType'] as String? ?? 'camera';

    return Sensor(
      areaName: json['areaName'] as String? ?? 'N/A',
      sensorNumber: json['id']?.toString() ?? 'N/A',
      locationName: json['areaName'] as String? ?? 'N/A',
      sensorType: parseSensorType(deviceTypeStr),
      isConnected: isConnected,
    );
  }

  String get fullDisplayName => '$areaName-$locationName';

  String get sensorTypeName {
    switch (sensorType) {
      case SensorType.camera: return '카메라';
      case SensorType.smokeSensor: return '연기 센서';
      case SensorType.temperatureSensor: return '열 센서';
    }
  }
}