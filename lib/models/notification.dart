enum NotificationType {
  fireDetected,
  sensorDisconnected,
  majorNotice,
}

class NotificationItem {
  final String id;          // 알림 고유 ID
  final String title;       // 알림 제목
  final String message;     // 알림 상세 메시지
  final DateTime timestamp; // 알림 발생 시간
  final NotificationType type; // 알림 타입
  bool isRead;              // 읽음 여부

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });

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