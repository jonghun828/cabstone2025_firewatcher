// lib/pages/main_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/videolog.dart';
import '../models/sensor.dart';
import 'videolog_page.dart';
import 'notice_board_page.dart' show NoticeBoardPage, noticeBoardKey;
import 'zone_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';
import 'videolog_detail_page.dart';
import 'zone_detail_page.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // 임시 센서 목록
  final List<Sensor> _sensorList = [
    Sensor(areaName: 'A', sensorNumber: 'C-1', locationName: '숲', sensorType: SensorType.camera, isConnected: false, areaIpAddress: ''),
    Sensor(areaName: 'A', sensorNumber: 'C-2', locationName: '산책로', sensorType: SensorType.smokeSensor, isConnected: false, areaIpAddress: ''),
    Sensor(areaName: 'A', sensorNumber: 'C-3', locationName: '초소', sensorType: SensorType.temperatureSensor, isConnected: false, areaIpAddress: ''),
    Sensor(areaName: 'B', sensorNumber: 'B-1', locationName: '숲', sensorType: SensorType.camera, isConnected: true, areaIpAddress: ''),
    Sensor(areaName: 'C', sensorNumber: 'C-1', locationName: '숲', sensorType: SensorType.smokeSensor, isConnected: true, areaIpAddress: ''),
  ];

  final List<VideoLog> _ongoingIncidents = [
    VideoLog(incidentNumber: 1, detectedArea: 'A-숲', detectorType: DetectorType.camera, detectorNumber: 3, severity: Severity.high, areaManager: '김철수', detectionTime: DateTime(2025, 8, 13, 14, 30), status: '감지', isRealFire: true),
    VideoLog(incidentNumber: 2, detectedArea: 'C-산책로', detectorType: DetectorType.smokeSensor, detectorNumber: 5, severity: Severity.high, areaManager: '박영희', detectionTime: DateTime(2025, 8, 13, 15, 10), status: '처리중', isRealFire: true),
  ];

  late final List<Widget> _pages;
  late final List<String> _appBarTitles;

  @override
  void initState() {
    super.initState();

    _pages = <Widget>[
      _buildHomePage(),
      const VideoLogPage(),
      NoticeBoardPage(key: noticeBoardKey),
      const ZonePage(),
    ];

    _appBarTitles = const ['산불 감지 시스템', '영상 기록', '공지 게시판', '구역'];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      if (noticeBoardKey.currentState != null) {
        noticeBoardKey.currentState!.loadNotices();
      }
    }
  }

  Widget _buildSensorCard(Sensor sensor) {
    return InkWell(
      onTap: () {
        // ZoneDetailPage로 Sensor 객체 전달
        Navigator.push(context, MaterialPageRoute(builder: (context) => ZoneDetailPage(sensor: sensor)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300, width: 1.0)),
        child: Row(
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: sensor.isConnected ? Colors.green : Colors.red)),
            const SizedBox(width: 12),
            Expanded(child: Text(sensor.fullDisplayName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentCard(VideoLog log) {
    Color statusColor;
    switch (log.status) {
      case '감지': statusColor = Colors.orange; break;
      case '처리중': statusColor = Colors.blue; break;
      default: statusColor = Colors.green;
    }
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => VideoLogDetailPage(log: log)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300, width: 1.0)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('${log.detectedArea} (${log.areaManager})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(20)),
                child: Text(log.status, style: const TextStyle(color: Colors.white, fontSize: 12))),
          ],
          ),
          const SizedBox(height: 8),
          Text('감지 시간: ${DateFormat('yyyy-MM-dd HH:mm').format(log.detectionTime)}', style: const TextStyle(color: Colors.black54)),
        ],
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    final List<Sensor> brokenSensors = _sensorList.where((sensor) => !sensor.isConnected).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('비정상 센서 현황', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          brokenSensors.isEmpty
              ? Container(padding: const EdgeInsets.all(16), margin: const EdgeInsets.symmetric(vertical: 4.0), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300, width: 1.0)),
              child: const Center(child: Text('모든 센서가 정상적으로 작동하고 있습니다.', style: TextStyle(fontSize: 16, color: Colors.green))))
              : Column(children: brokenSensors.map((sensor) => _buildSensorCard(sensor)).toList()),

          const SizedBox(height: 16),
          const Text('진행 중인 사건', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (_ongoingIncidents.isEmpty)
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const VideoLogPage()));
              },
              child: Container(padding: const EdgeInsets.all(16), margin: const EdgeInsets.symmetric(vertical: 4.0), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300, width: 1.0)),
                  child: const Center(child: Text('현재 진행 중인 사건이 없습니다.\n(전체 영상 기록 보기)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)))),
            )
          else
            Column(children: _ongoingIncidents.map((log) => _buildIncidentCard(log)).toList()),
        ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          if (_selectedIndex == 0)
            Row(children: [
              IconButton(icon: const Icon(Icons.notifications), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage())); }),
              IconButton(icon: const Icon(Icons.person), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())); }),
              const SizedBox(width: 8),
            ]),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 0, blurRadius: 2, offset: const Offset(0, -5))]),
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