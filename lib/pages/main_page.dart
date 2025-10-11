// lib/pages/main_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/videolog.dart';
import '../models/sensor.dart';
import '../widgets/videolog_card.dart'; // VideoLogCard 위젯 import
import '../widgets/sensor_card.dart';   // SensorCard 위젯 import (홈 화면 비정상 센서 현황 카드에서 사용)

// 각 탭 페이지들
import 'videolog_page.dart'; // 영상 기록
import 'notice_board_page.dart'; // 공지 게시판 (게시판)
import 'zone_page.dart'; // 구역 페이지 (하단 바에 포함됨)

// AppBar에서 이동하는 페이지들
import 'notification_page.dart'; // 알림
import 'profile_page.dart'; // 프로필

// 상세 페이지들
import 'videolog_detail_page.dart';
import 'zone_detail_page.dart';

// 설정 상세 페이지들은 main_page에서 직접 사용하지 않으므로 제거했습니다.
// import 'setting_notification_page.dart';
// import 'setting_video_page.dart';
// import 'setting_theme_page.dart';
// import 'setting_language_page.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // 홈 화면에 표시할 임시 센서 데이터 (main_page의 _buildHomePage에서만 사용)
  final List<Sensor> _sensorList = [
    Sensor(areaName: 'A', sensorNumber: 'C-1', locationName: '숲', sensorType: SensorType.camera, isConnected: false), // A-숲
    Sensor(areaName: 'A', sensorNumber: 'C-2', locationName: '산책로', sensorType: SensorType.smokeSensor, isConnected: false), // A-산책로
    Sensor(areaName: 'A', sensorNumber: 'C-3', locationName: '초소', sensorType: SensorType.temperatureSensor, isConnected: false), // A-초소
    Sensor(areaName: 'B', sensorNumber: 'B-1', locationName: '숲', sensorType: SensorType.camera, isConnected: true), // B-숲
    Sensor(areaName: 'C', sensorNumber: 'C-1', locationName: '숲', sensorType: SensorType.smokeSensor, isConnected: true), // C-숲
  ];

  // 홈 화면에 표시할 임시 진행 중인 사건 데이터
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

  // 하단 내비게이션 바에 연결될 페이지들
  late final List<Widget> _pages;
  // 각 페이지에 해당하는 AppBar 타이틀
  late final List<String> _appBarTitles;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      _buildHomePage(),            // 0: 홈
      const VideoLogPage(),        // 1: 영상 기록
      const NoticeBoardPage(),     // 2: 공지 게시판
      const ZonePage(),            // 3: 구역
    ];

    _appBarTitles = const [
      '산불 감지 시스템', // 0: 홈
      '영상 기록',        // 1: 영상 기록
      '공지 게시판',       // 2: 게시판
      '구역',             // 3: 구역
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 센서 카드 위젯 (Home에서 비정상 센서를 표시할 때 사용)
  Widget _buildSensorCard(Sensor sensor) {
    return InkWell(
      onTap: () {
        // ZoneDetailPage로 이동, sensor 객체 전달
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ZoneDetailPage(sensor: sensor),
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
              // 🚨 수정: fullDisplayName을 사용하여 'A-숲'과 같은 형식으로 표시
              child: Text(
                sensor.fullDisplayName,
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

  // 진행 중인 사건 카드 위젯 (Home에서 사용)
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
        statusColor = Colors.green; // '완료'나 기타 상태
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
        title: Text(
          _appBarTitles[_selectedIndex],
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          // 홈 화면(인덱스 0)에서만 알림 및 프로필 아이콘 표시
          if (_selectedIndex == 0)
            Row(
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
                const SizedBox(width: 8), // 오른쪽 여백 추가
              ],
            ),
        ],
      ),
      // 탭 전환을 위해 IndexedStack 사용 (이전 코드와 동일)
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
            BottomNavigationBarItem(icon: Icon(Icons.map), label: '구역'),
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