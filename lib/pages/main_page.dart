import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../widgets/home_sensor_list_widget.dart';
import 'setting_page.dart';
import 'notice_board_page.dart';
import 'video_log_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 하단 네비게이션 바 선택 인덱스는 '홈' 버튼의 인덱스인 0으로 그대로 유지됩니다.
  int _selectedIndex = 0;

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
      // 인덱스 0: 홈 (HomeSensorListWidget에 _sensorList 전달)
      const VideoLogPage(),
      // 인덱스 1: 영상기록 (나중에 VideoLogPage 등으로 대체)
      const NoticeBoardPage(),
      // <--- 인덱스 2: 게시판 (NoticeBoardPage 사용)
      const SettingPage(),
      // 인덱스 3: 설정
    ];
  }

  // 하단 메뉴바 아이템 탭 시 호출되는 함수
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 선택된 인덱스를 업데이트하여 화면 전환
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('산불 감지 시스템'),
        actions: [
          // 알림 아이콘
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: 알림 페이지로 이동 또는 알림 기능 구현
              print('알림 아이콘 클릭');
            },
          ),
          // 프로필 아이콘
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              print('프로필 아이콘 클릭');
              Navigator.push( // <--- 프로필 페이지로 이동!
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
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
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar( // 하단 메뉴바
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.videocam), label: '영상기록'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: '공지사항'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
        currentIndex: _selectedIndex,
        // 현재 선택된 아이템의 인덱스
        selectedItemColor: Theme
            .of(context)
            .primaryColor,
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