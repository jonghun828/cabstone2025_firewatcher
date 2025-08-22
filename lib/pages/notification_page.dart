import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notification.dart';

class NotificationPage extends StatefulWidget {

  const NotificationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // 임시 알림 데이터
  List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'noti_1',
      title: '화재 감지! A-숲 구역 비상!',
      message: 'A-숲 구역에서 고온 감지. 즉시 확인 필요.',
      timestamp: DateTime(2025, 8, 18, 17, 30),
      type: NotificationType.fireDetected,
      isRead: false,
    ),
    NotificationItem(
      id: 'noti_2',
      title: '시스템 업데이트 완료 안내',
      message: 'v1.5 업데이트가 완료되었습니다. 새로운 기능 확인.',
      timestamp: DateTime(2025, 8, 18, 10, 0),
      type: NotificationType.majorNotice,
      isRead: false,
    ),
    NotificationItem(
      id: 'noti_3',
      title: '센서 오류: C-산책로 센서 연결 불안정',
      message: 'C-산책로 구역의 연기 센서 S-5번이 일시적으로 연결이 끊겼습니다.',
      timestamp: DateTime(2025, 8, 17, 23, 15),
      type: NotificationType.sensorDisconnected,
      isRead: false,
    ),
    NotificationItem(
      id: 'noti_4',
      title: '관리자 공지: 정기 시스템 점검 예정',
      message: '8월 25일 정기 시스템 점검이 예정되어 있습니다. 자세한 내용은 공지 게시판 참조.',
      timestamp: DateTime(2025, 8, 17, 14, 0),
      type: NotificationType.majorNotice,
      isRead: true,
    ),
    NotificationItem(
      id: 'noti_5',
      title: '화재 감지! B-초소 구역 경보 발생!',
      message: 'B-초소 구역에서 화재 감지 경보가 발생했습니다. 담당자는 즉시 확인바랍니다.',
      timestamp: DateTime(2025, 8, 16, 9, 45),
      type: NotificationType.fireDetected,
      isRead: false,
    ),
     NotificationItem(
      id: 'noti_6',
      title: '새로운 로그인 기기 감지 알림',
      message: '미등록 기기에서 로그인이 감지되었습니다. 본인 여부 확인 요망.',
      timestamp: DateTime(2025, 8, 15, 18, 30),
      type: NotificationType.majorNotice,
      isRead: false,
    ),
    NotificationItem(
      id: 'noti_7',
      title: '센서 복구: C-산책로 센서 연결 정상화',
      message: '이전에 불안정했던 C-산책로 구역의 연기 센서 S-5번이 정상화되었습니다.',
      timestamp: DateTime(2025, 8, 15, 10, 0),
      type: NotificationType.sensorDisconnected,
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // 알림 리스트 최신순 정렬
    _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // 알림 클릭 시 읽음 상태로 변경하는 함수
  void _markAsRead(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((noti) => noti.id == notificationId);
      if (index != -1 && !_notifications[index].isRead) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
      ),
      body: _notifications.isEmpty
          ? const Center(child: Text('도착한 알림이 없습니다.'))
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return InkWell(
                  onTap: () {
                    print('알림 클릭됨: ${notification.title}');
                    _markAsRead(notification.id);
                    // TODO: 알림 상세 내용을 보여주는 다이얼로그나 페이지로 이동
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.title,
                                style: TextStyle(
                                  fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                                  fontSize: 16,
                                  color: notification.isRead ? Colors.grey[800] : Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notification.message,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: notification.isRead ? Colors.grey[600] : Colors.grey[700],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                DateFormat('yyyy.MM.dd HH:mm').format(notification.timestamp),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 8.0),
                          child: notification.isRead
                              ? const SizedBox(width: 8, height: 8)
                              : Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}