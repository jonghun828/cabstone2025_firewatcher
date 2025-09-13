// lib/pages/main_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/videolog.dart';
import '../models/sensor.dart';

// 각 탭 페이지들 (IndexedStack에 포함될 페이지들)
import 'videolog_page.dart';
import 'notice_board_page.dart';
import 'profile_page.dart';
import 'notification_page.dart';
import 'setting_page.dart';
import 'videolog_detail_page.dart';

// import 'area_detail_page.dart'; // 👈 AreaDetailPage import 제거
import 'zone_detail_page.dart'; // 👈 ZoneDetailPage import 추가

// 설정 상세 페이지들 (설정 페이지에서 이동하므로, main_page에는 직접 사용 안 함)
import 'setting_notification_page.dart';
import 'setting_video_page.dart';
import 'setting_theme_page.dart';
import 'setting_language_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Sensor> _sensorList = [
    Sensor(areaName: 'A-숲', sensorNumber: 'C-1', isConnected: false),
    Sensor(areaName: 'A-산책로', sensorNumber: 'C-2', isConnected: false),
    Sensor(areaName: 'A-초소', sensorNumber: 'C-3', isConnected: false),
    Sensor(areaName: 'B-숲', sensorNumber: 'B-1', isConnected: true),
    Sensor(areaName: 'C-숲', sensorNumber: 'C-1', isConnected: true),
  ];

  final List<String> _notices = [
    '새로운 시스템 업데이트 안내 (v1.2.0)',
    '정기 점검으로 인한 서비스 일시 중단 안내',
    '화재 발생 시 대처 요령 공지',
  ];

  final List<VideoLog> _ongoingIncidents = [
    VideoLog(
      incidentNumber: 1,
      detectedArea: 'A-숲',
      detectorType: DetectorType.camera,
      detectorNumber: 3,
      severity: Severity.high,
      areaManager: '김철수',
      detectionTime: DateTime(2025, 8, 13, 14, 30),
      status: '감지',
      isRealFire: true,
    ),
    VideoLog(
      incidentNumber: 2,
      detectedArea: 'C-산책로',
      detectorType: DetectorType.smokeSensor,
      detectorNumber: 5,
      severity: Severity.high,
      areaManager: '박영희',
      detectionTime: DateTime(2025, 8, 13, 15, 10),
      status: '처리중',
      isRealFire: true,
    ),
  ];

  late final List<Widget> _pages;
  late final List<String> _appBarTitles;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      _buildHomePage(),
      const VideoLogPage(),
      const NoticeBoardPage(),
      const SettingPage(),
    ];

    _appBarTitles = const ['산불 감지 시스템', '영상 기록', '공지 게시판', '설정'];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 센서 카드 위젯 (클릭 기능 추가, ZoneDetailPage로 변경)
  Widget _buildSensorCard(Sensor sensor) {
    return InkWell(
      onTap: () {
        // ZoneDetailPage로 이동, sensor 객체 전달
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ZoneDetailPage(sensor: sensor), // 👈 ZoneDetailPage 사용
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1.0),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: sensor.isConnected ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${sensor.areaName} (${sensor.sensorNumber})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 진행 중인 사건 카드 위젯 (클릭 기능 유지)
  Widget _buildIncidentCard(VideoLog log) {
    Color statusColor;
    switch (log.status) {
      case '감지':
        statusColor = Colors.orange;
        break;
      case '처리중':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.green;
    }
    return InkWell(
      onTap: () {
        // 영상 기록 상세 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoLogDetailPage(log: log)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${log.detectedArea} (${log.areaManager})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    log.status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '감지 시간: ${DateFormat('yyyy-MM-dd HH:mm').format(log.detectionTime)}',
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  // 홈 페이지의 본문 위젯
  Widget _buildHomePage() {
    final List<Sensor> brokenSensors = _sensorList
        .where((sensor) => !sensor.isConnected)
        .toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 센서 현황 섹션
            const Text(
              '비정상 센서 현황',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (brokenSensors.isEmpty)
              // 모든 센서가 정상일 때의 메시지 (클릭 기능 없음)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 1.0),
                ),
                child: const Center(
                  child: Text(
                    '모든 센서가 정상적으로 작동하고 있습니다.',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
              )
            else
              Column(
                children: brokenSensors
                    .map((sensor) => _buildSensorCard(sensor))
                    .toList(),
              ),
            const SizedBox(height: 16),

            // 2. 감지/처리중인 사건 현황
            const Text(
              '진행 중인 사건',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_ongoingIncidents.isEmpty)
              // 진행 중인 사건이 없을 때의 메시지 (클릭 가능)
              InkWell(
                onTap: () {
                  // 영상 기록 전체 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VideoLogPage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 1.0),
                  ),
                  child: const Center(
                    child: Text(
                      '현재 진행 중인 사건이 없습니다.\n(전체 영상 기록 보기)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
              )
            else
              Column(
                children: _ongoingIncidents
                    .map((log) => _buildIncidentCard(log))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            _appBarTitles[_selectedIndex],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          if (_selectedIndex == 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
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
            ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.videocam), label: '영상기록'),
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: '게시판'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.black.withOpacity(0.2),
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
