import 'package:flutter/material.dart';
import '../models/sensor.dart';
import '../widgets/sensor_list.dart';
import 'setting_page.dart';
import 'notice_board_page.dart';
import 'videolog_page.dart';
import 'profile_page.dart';
import 'notification_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Sensor> _sensorList = [
    //임시 센서 데이터 리스트
    Sensor(areaName: '구역 A', sensorNumber: 'CAM-001', isConnected: true),
    Sensor(areaName: '구역 B', sensorNumber: 'CAM-002', isConnected: false),
    Sensor(areaName: '구역 C', sensorNumber: 'CAM-003', isConnected: true),
    Sensor(areaName: '구역 D', sensorNumber: 'CAM-004', isConnected: true),
    Sensor(areaName: '구역 E', sensorNumber: 'CAM-005', isConnected: false),
    Sensor(areaName: '구역 F', sensorNumber: 'CAM-006', isConnected: true),
    Sensor(areaName: '구역 G', sensorNumber: 'CAM-007', isConnected: true),
    Sensor(areaName: '구역 H', sensorNumber: 'CAM-008', isConnected: true),
    Sensor(areaName: '구역 I', sensorNumber: 'CAM-009', isConnected: false),
    Sensor(areaName: '구역 J', sensorNumber: 'CAM-010', isConnected: true),
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      HomeSensorListWidget(sensorList: _sensorList),  //0: 홈
      const VideoLogPage(),                           //1: 영상 기록
      const NoticeBoardPage(),                        //2: 공지 게시판
      const SettingPage(),                            //3: 설정
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