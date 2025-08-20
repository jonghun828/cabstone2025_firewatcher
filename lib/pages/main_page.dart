// lib/pages/main_page.dart

import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../widgets/home_sensor_list_widget.dart';
import 'setting_page.dart';
import 'notice_board_page.dart';
import 'video_log_page.dart';
import 'profile_page.dart';
import 'notification_page.dart'; // 알림 페이지 import는 유지

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<SensorData> _sensorList = [
    // ... (기존 센서 데이터는 그대로 유지)
    SensorData(areaName: '구역 A', sensorNumber: 'CAM-001', isConnected: true),
    SensorData(areaName: '구역 B', sensorNumber: 'CAM-002', isConnected: false),
    SensorData(areaName: '구역 C', sensorNumber: 'CAM-003', isConnected: true),
    SensorData(areaName: '구역 D', sensorNumber: 'CAM-004', isConnected: true),
    SensorData(areaName: '구역 E', sensorNumber: 'CAM-005', isConnected: false),
    SensorData(areaName: '구역 F', sensorNumber: 'CAM-006', isConnected: true),
    SensorData(areaName: '구역 G', sensorNumber: 'CAM-007', isConnected: true),
    SensorData(areaName: '구역 H', sensorNumber: 'CAM-008', isConnected: true),
    SensorData(areaName: '구역 I', sensorNumber: 'CAM-009', isConnected: false),
    SensorData(areaName: '구역 J', sensorNumber: 'CAM-010', isConnected: true),
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      HomeSensorListWidget(sensorList: _sensorList),
      const VideoLogPage(),
      const NoticeBoardPage(),
      const SettingPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
              print('알림 아이콘 클릭');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              );
            },
          ),
          // 프로필 아이콘
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              print('프로필 아이콘 클릭');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
          // 로그아웃 아이콘 <--- 이 아이콘 버튼이 제거되었습니다!
          // IconButton(
          //   icon: const Icon(Icons.logout),
          //   onPressed: () {
          //     Navigator.pushReplacementNamed(context, '/');
          //   },
          // ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.videocam), label: '영상기록'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: '게시판'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}