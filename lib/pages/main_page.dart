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
    Sensor(areaName: 'A-숲', sensorNumber: 'C-1', isConnected: true),
    Sensor(areaName: 'A-산책로', sensorNumber: 'C-2', isConnected: false),
    Sensor(areaName: 'A-초소', sensorNumber: 'C-3', isConnected: true),
    Sensor(areaName: 'A-주차장', sensorNumber: 'C-4', isConnected: true),
    Sensor(areaName: 'A-계곡', sensorNumber: 'C-5', isConnected: false),
    Sensor(areaName: 'A-야영장', sensorNumber: 'C-6', isConnected: true),
    Sensor(areaName: 'A-등산로', sensorNumber: 'C-7', isConnected: true),
    Sensor(areaName: 'A-정상', sensorNumber: 'C-8', isConnected: true),
    Sensor(areaName: 'A-휴게소', sensorNumber: 'C-9', isConnected: false),
    Sensor(areaName: 'A-둘레길', sensorNumber: 'C-10', isConnected: true),
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