import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../widgets/home_sensor_list_widget.dart';
import 'setting_page.dart';
import 'notice_board_page.dart';
import 'video_log_page.dart';
import 'profile_page.dart';
import 'notification_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 하단 네비게이션 바 선택 인덱스는 '홈' 버튼의 인덱스인 0으로 그대로 유지됩니다.
  int _selectedIndex = 0;
  bool _hasUnreadNotifications = true; // <--- 읽지 않은 알림 존재 여부 (초기값 true로 설정)

  // 임시 센서 데이터 (models/sensor_data.dart 에서 import된 SensorData 사용)
  final List<SensorData> _sensorList = [
    SensorData(areaName: '구역 A', cameraNumber: 'CAM-001', isConnected: true),
    SensorData(areaName: '구역 B', cameraNumber: 'CAM-002', isConnected: false),
    // 연결 끊김/불안정 예시
    SensorData(areaName: '구역 C', cameraNumber: 'CAM-003', isConnected: true),
    SensorData(areaName: '구역 D', cameraNumber: 'CAM-004', isConnected: true),
    SensorData(areaName: '구역 E', cameraNumber: 'CAM-005', isConnected: false),
    // 연결 끊김/불안정 예시
    SensorData(areaName: '구역 F', cameraNumber: 'CAM-006', isConnected: true),
    SensorData(areaName: '구역 G', cameraNumber: 'CAM-007', isConnected: true),
    SensorData(areaName: '구역 H', cameraNumber: 'CAM-008', isConnected: true),
    SensorData(areaName: '구역 I', cameraNumber: 'CAM-009', isConnected: false),
    SensorData(areaName: '구역 J', cameraNumber: 'CAM-010', isConnected: true),
  ];

  // BottomNavigationBar 아이템에 해당하는 페이지 위젯 리스트
  // 순서: 홈(0), 영상기록(1), 게시판(2), 설정(3)
  late final List<Widget> _pages; // late 키워드를 사용하여 initState에서 초기화합니다.

  @override
  void initState() {
    super.initState();
    // _pages 리스트를 initState에서 초기화합니다.
    _pages = <Widget>[
      HomeSensorListWidget(sensorList: _sensorList),
      const VideoLogPage(),
      const NoticeBoardPage(),
      const SettingPage(),
    ];
    // 앱 시작 시 읽지 않은 알림이 있다고 가정 (실제로는 API 호출 등으로 판단)
    _checkUnreadNotifications(); // <--- 초기 상태 체크 메서드 호출
  }

  // 하단 메뉴바 아이템 탭 시 호출되는 함수
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 선택된 인덱스를 업데이트하여 화면 전환
    });
  }

  // 알림 페이지에서 돌아올 때 호출될 콜백 함수
  void _onNotificationsRead(bool hasUnread) {
    setState(() {
      _hasUnreadNotifications = hasUnread; // 알림 읽음 여부 업데이트
    });
  }

  // 임시로 읽지 않은 알림이 있는지 확인하는 메서드 (나중에 실제 로직으로 대체)
  void _checkUnreadNotifications() {
    // TODO: 실제 알림 서비스나 저장된 데이터를 통해 읽지 않은 알림이 있는지 확인
    // 현재는 NotificationPage의 임시 데이터가 섞여있으므로 임시로 true/false를 번갈아 설정
    // 실제 구현 시 NotificationPage의 _notifications 리스트에서 isRead=false인 것이 있는지 체크
    setState(() {
      // _hasUnreadNotifications = !_hasUnreadNotifications; // 테스트용 토글
      _hasUnreadNotifications = true; // 일단 초기에는 알림이 있다고 가정
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('산불 감지 시스템'),
        actions: [
          // 알림 아이콘 (Badge 추가)
          Stack(
            // <--- 아이콘 위에 빨간 점을 겹치기 위해 Stack 사용
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () async {
                  // async-await을 사용하여 NotificationPage에서 결과 받기
                  print('알림 아이콘 클릭');
                  // NotificationPage로 이동하며 읽지 않은 알림 상태 업데이트 콜백 전달
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationPage(
                        onNotificationsRead:
                            _onNotificationsRead, // <--- 콜백 함수 전달
                      ),
                    ),
                  );
                  // NotificationPage에서 반환된 결과가 있다면 (_onNotificationsRead 콜백이 호출되었다면),
                  // result를 통해 추가적인 작업을 할 수도 있습니다.
                  if (result != null && result is bool) {
                    _onNotificationsRead(
                      result,
                    ); // NotificationPage가 pop되면서 상태를 직접 반환할 경우
                  }
                },
              ),
              if (_hasUnreadNotifications) // <--- 읽지 않은 알림이 있을 때만 빨간 점 표시
                Positioned(
                  // <--- Stack 내에서 위치 지정
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: const SizedBox.shrink(), // 내용 없이 크기만 지정
                  ),
                )
              else
                const SizedBox.shrink(), // 알림이 없으면 아무것도 그리지 않음 (혹은 작은 빈 박스)
            ],
          ),
          // 프로필 아이콘
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              print('프로필 아이콘 클릭');
              Navigator.push(
                // <--- 프로필 페이지로 이동!
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          // 로그아웃 아이콘
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        // 하단 메뉴바
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.videocam), label: '영상기록'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: '공지사항'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
        currentIndex: _selectedIndex,
        // 현재 선택된 아이템의 인덱스
        selectedItemColor: Theme.of(context).primaryColor,
        // 선택된 아이템 색상
        unselectedItemColor: Colors.grey,
        // 선택되지 않은 아이템 색상
        onTap: _onItemTapped,
        // 아이템 탭 시 호출될 함수
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
