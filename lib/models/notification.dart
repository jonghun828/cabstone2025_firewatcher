import 'package:flutter/material.dart';

enum NotificationType {
  fireDetected,      // 화재 감지
  sensorDisconnected, // 센서 연결 끊김
  majorNotice,       // 주요 공지사항
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp; // 알림 발생 시간
  final NotificationType type; // 알림 타입
  bool isRead;              // 읽음 여부 (true: 읽음, false: 안 읽음)

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false, // 기본값은 읽지 않은 상태
  });

  // isRead 상태를 변경할 수 있는 copyWith 메서드
  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}