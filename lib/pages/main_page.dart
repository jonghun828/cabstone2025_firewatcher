// lib/pages/main_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/videolog.dart'; // VideoLog 모델 추가
import '../models/sensor.dart';

// 각 탭 페이지들 (IndexedStack에 포함될 페이지들)
import 'videolog_page.dart'; // 영상 기록 페이지 (파일명 수정 반영)
import 'notice_board_page.dart'; // 공지 게시판 페이지
import 'profile_page.dart'; // 프로필 페이지
import 'notification_page.dart'; // 알림 페이지
import 'setting_page.dart'; // 설정 페이지

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
  int _selectedIndex = 0; // 현재 선택된 BottomNavigationBar 아이템의 인덱스

  // 센서 데이터 리스트 (임시 데이터)
  final List<Sensor> _sensorList = [
    // 다양한 연결 상태를 가진 센서 데이터를 포함합니다.
    Sensor(areaName: 'A-숲', sensorNumber: 'C-1', isConnected: false),
    Sensor(areaName: 'A-산책로', sensorNumber: 'C-2', isConnected: false),
    // 연결 불안정 센서
    Sensor(areaName: 'A-초소', sensorNumber: 'C-3', isConnected: false),
    Sensor(areaName: 'B-숲', sensorNumber: 'B-1', isConnected: true),
    Sensor(areaName: 'C-숲', sensorNumber: 'C-1', isConnected: true),
  ];

  // 예시 데이터: 공지 게시판
  final List<String> _notices = [
    '새로운 시스템 업데이트 안내 (v1.2.0)',
    '정기 점검으로 인한 서비스 일시 중단 안내',
    '화재 발생 시 대처 요령 공지',
  ];

  // 예시 데이터: 진행 중인 사건 (VideoLog 모델 재사용)
  final List<VideoLog> _ongoingIncidents = [
    // 비어있는 상태를 테스트하려면 이 리스트를 비우세요.
    VideoLog(
      incidentNumber: 1,
      detectedArea: 'A-숲',
      detectorType: DetectorType.camera,
      detectorNumber: 3,
      severity: Severity.high,
      areaManager: '김철수',
      detectionTime: DateTime(2025, 8, 13, 14, 30, 0),
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
      detectionTime: DateTime(2025, 8, 13, 15, 10, 0),
      status: '처리중',
      isRealFire: true,
    ),
  ];

  late final List<Widget> _pages; // BottomNavigationBar 탭에 해당하는 위젯 리스트
  late final List<String> _appBarTitles; // 각 탭에 표시될 AppBar 타이틀 목록

  @override
  void initState() {
    super.initState();
    // _pages 리스트 초기화: 각 탭이 보여줄 실제 화면 위젯들을 정의합니다.
    _pages = <Widget>[
      _buildHomePage(), // 0번 인덱스: 홈 탭 (새로 정의된 홈 페이지 위젯)
      const VideoLogPage(), // 1번 인덱스: 영상기록 탭 (파일명 수정 반영)
      const NoticeBoardPage(), // 2번 인덱스: 게시판 탭
      const SettingPage(), // 3번 인덱스: 설정 탭
    ];

    // _appBarTitles 리스트 초기화: 각 탭 인덱스에 매핑되는 AppBar의 타이틀을 정의합니다.
    _appBarTitles = const [
      '산불 감지 시스템', // 0번 탭 (홈)의 타이틀
      '영상 기록', // 1번 탭 (영상기록)의 타이틀
      '공지 게시판', // 2번 탭 (게시판)의 타이틀
      '설정', // 3번 탭 (설정)의 타이틀
    ];
  }

  // BottomNavigationBar 아이템 탭 시 호출되는 함수
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 선택된 인덱스 업데이트하여 화면 전환 트리거
    });
  }

  // 센서 카드 위젯을 구성하는 새로운 함수
  Widget _buildSensorCard(Sensor sensor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // boxShadow 제거
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // 진행 중인 사건 카드 위젯
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // boxShadow 제거
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            '감지 시간: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(log.detectionTime)}',
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // 홈 페이지의 본문 위젯을 구성하는 새로운 함수
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
            // 1. 센서 현황 섹션 (개별 박스로 변경)
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
                  // boxShadow 제거
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
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  // boxShadow 제거
                  border: Border.all(color: Colors.grey.shade300, width: 1.0),
                ),
                child: const Center(
                  child: Text(
                    '현재 진행 중인 사건이 없습니다.',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
              )
            else
              Column(
                children: _ongoingIncidents
                    .map((log) => _buildIncidentCard(log))
                    .toList(),
              ),
            const SizedBox(height: 16),

            // 3. 공지 게시판 요약
            const Text(
              '공지 게시판',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                // boxShadow 제거
                border: Border.all(color: Colors.grey.shade300, width: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _notices
                    .map(
                      (notice) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.volume_up,
                              size: 18,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                notice,
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
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
        // 하단바 그림자 효과는 유지
        decoration: BoxDecoration(
          color: Colors.white, // 하단바와 같은 배경색 설정
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