// lib/pages/video_log_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/video_log.dart'; // 수정된 VideoLog 모델 import
import '../widgets/video_log_table_header.dart';
import '../widgets/video_log_table_row.dart';

class VideoLogPage extends StatefulWidget {
  const VideoLogPage({super.key});

  @override
  State<VideoLogPage> createState() => _VideoLogPageState();
}

class _VideoLogPageState extends State<VideoLogPage> {
  // 임시 영상 기록 데이터
  final List<VideoLog> _allVideoLogs = [
    VideoLog(
      incidentNumber: 1, detectedArea: 'A-숲',
      detectorType: DetectorType.camera, detectorNumber: 3,
      severity: Severity.high, areaManager: '김철수',
      detectionTime: DateTime(2025, 8, 13, 14, 30, 0),
      status: '감지', isRealFire: false,
    ),
    VideoLog(
      incidentNumber: 2, detectedArea: 'C-산책로',
      detectorType: DetectorType.smokeSensor, detectorNumber: 5,
      severity: Severity.high, areaManager: '박영희',
      detectionTime: DateTime(2025, 8, 13, 15, 10, 0),
      status: '처리중', isRealFire: true,
    ),
    VideoLog(
      incidentNumber: 3, detectedArea: 'B-초소',
      detectorType: DetectorType.heatSensor, detectorNumber: 2,
      severity: Severity.medium, areaManager: '이민준',
      detectionTime: DateTime(2025, 8, 12, 10, 0, 0),
      status: '완료', isRealFire: false,
    ),
    VideoLog(
      incidentNumber: 4, detectedArea: 'A-주차장',
      detectorType: DetectorType.camera, detectorNumber: 1,
      severity: Severity.low, areaManager: '김철수',
      detectionTime: DateTime(2025, 8, 11, 23, 45, 0),
      status: '오인', isRealFire: false,
    ),
    VideoLog(
      incidentNumber: 5, detectedArea: 'D-계곡',
      detectorType: DetectorType.smokeSensor, detectorNumber: 8,
      severity: Severity.high, areaManager: '최지우',
      detectionTime: DateTime(2025, 8, 10, 10, 15, 0),
      status: '감지', isRealFire: true,
    ),
    // --- 추가 데이터 시작 ---
    VideoLog(
      incidentNumber: 6, detectedArea: 'E-야영장',
      detectorType: DetectorType.camera, detectorNumber: 7,
      severity: Severity.medium, areaManager: '정민수',
      detectionTime: DateTime(2025, 8, 9, 9, 0, 0),
      status: '감지', isRealFire: false,
    ),
    VideoLog(
      incidentNumber: 7, detectedArea: 'F-등산로',
      detectorType: DetectorType.heatSensor, detectorNumber: 4,
      severity: Severity.high, areaManager: '황지현',
      detectionTime: DateTime(2025, 8, 8, 11, 20, 0),
      status: '처리중', isRealFire: true,
    ),
    VideoLog(
      incidentNumber: 8, detectedArea: 'G-정상',
      detectorType: DetectorType.smokeSensor, detectorNumber: 1,
      severity: Severity.low, areaManager: '김철수',
      detectionTime: DateTime(2025, 8, 7, 16, 40, 0),
      status: '완료', isRealFire: false,
    ),
    VideoLog(
      incidentNumber: 9, detectedArea: 'H-탐방객센터',
      detectorType: DetectorType.camera, detectorNumber: 2,
      severity: Severity.medium, areaManager: '박영희',
      detectionTime: DateTime(2025, 8, 6, 13, 0, 0),
      status: '오인', isRealFire: false,
    ),
    VideoLog(
      incidentNumber: 10, detectedArea: 'I-휴게소',
      detectorType: DetectorType.heatSensor, detectorNumber: 9,
      severity: Severity.high, areaManager: '이민준',
      detectionTime: DateTime(2025, 8, 5, 17, 50, 0),
      status: '감지', isRealFire: true,
    ),
    VideoLog(
      incidentNumber: 11, detectedArea: 'J-둘레길',
      detectorType: DetectorType.smokeSensor, detectorNumber: 6,
      severity: Severity.low, areaManager: '최지우',
      detectionTime: DateTime(2025, 8, 4, 8, 10, 0),
      status: '완료', isRealFire: false,
    ),
    VideoLog(
      incidentNumber: 12, detectedArea: 'K-수목원',
      detectorType: DetectorType.camera, detectorNumber: 5,
      severity: Severity.medium, areaManager: '정민수',
      detectionTime: DateTime(2025, 8, 3, 10, 30, 0),
      status: '처리중', isRealFire: true,
    ),
    VideoLog(
      incidentNumber: 13, detectedArea: 'L-전망대',
      detectorType: DetectorType.heatSensor, detectorNumber: 7,
      severity: Severity.high, areaManager: '황지현',
      detectionTime: DateTime(2025, 8, 2, 14, 0, 0),
      status: '감지', isRealFire: false,
    ),
    VideoLog(
      incidentNumber: 14, detectedArea: 'M-계곡입구',
      detectorType: DetectorType.smokeSensor, detectorNumber: 3,
      severity: Severity.low, areaManager: '박영희',
      detectionTime: DateTime(2025, 8, 1, 19, 15, 0),
      status: '오인', isRealFire: false,
    ),
    VideoLog(
      incidentNumber: 15, detectedArea: 'N-주차구역',
      detectorType: DetectorType.camera, detectorNumber: 8,
      severity: Severity.medium, areaManager: '김철수',
      detectionTime: DateTime(2025, 7, 31, 22, 5, 0),
      status: '완료', isRealFire: false,
    ),
    VideoLog(
      incidentNumber: 16, detectedArea: 'O-숲길',
      detectorType: DetectorType.heatSensor, detectorNumber: 1,
      severity: Severity.high, areaManager: '이민준',
      detectionTime: DateTime(2025, 7, 30, 11, 40, 0),
      status: '감지', isRealFire: true,
    ),
    VideoLog(
      incidentNumber: 17, detectedArea: 'P-쉼터',
      detectorType: DetectorType.smokeSensor, detectorNumber: 2,
      severity: Severity.low, areaManager: '최지우',
      detectionTime: DateTime(2025, 7, 29, 9, 30, 0),
      status: '오인', isRealFire: false,
    ),
    VideoLog(
      incidentNumber: 18, detectedArea: 'Q-관리동',
      detectorType: DetectorType.camera, detectorNumber: 6,
      severity: Severity.medium, areaManager: '정민수',
      detectionTime: DateTime(2025, 7, 28, 13, 0, 0),
      status: '처리중', isRealFire: true,
    ),
    VideoLog(
      incidentNumber: 19, detectedArea: 'R-산등성이',
      detectorType: DetectorType.heatSensor, detectorNumber: 10,
      severity: Severity.high, areaManager: '황지현',
      detectionTime: DateTime(2025, 7, 27, 16, 55, 0),
      status: '감지', isRealFire: false,
    ),
    VideoLog(
      incidentNumber: 20, detectedArea: 'S-정문',
      detectorType: DetectorType.smokeSensor, detectorNumber: 7,
      severity: Severity.low, areaManager: '김철수',
      detectionTime: DateTime(2025, 7, 26, 8, 45, 0),
      status: '완료', isRealFire: false,
    ),
  ];
  // 검색 결과를 표시할 리스트 (초기에는 전체 리스트)
  late List<VideoLog> _filteredVideoLogs;
  // 검색어 입력 컨트롤러
  final TextEditingController _searchController = TextEditingController();

  final Map<String, int> _columnFlex = {
    'date': 11,
    'detectedArea': 26,
    'detector': 12,
    'areaManager': 15,
    'detectionTime': 13,
    'status': 15,
    'isRealFire': 8,
  };

  @override
  void initState() {
    super.initState();
    _filteredVideoLogs = List.from(_allVideoLogs); // 초기에는 모든 로그 표시
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 검색 로직 함수
  void _performSearch(String query) {
    setState(() {
      _filteredVideoLogs = _allVideoLogs.where((log) {
        final lowerQuery = query.toLowerCase();

        // 날짜 검색 (YYYY-MM-DD 또는 MM/DD)
        final formattedDate = DateFormat('yyyy-MM-dd').format(log.detectionTime);
        final shortDate = DateFormat('MM/dd').format(log.detectionTime);
        if (formattedDate.contains(lowerQuery) || shortDate.contains(lowerQuery)) {
          return true;
        }

        // 담당자 검색
        if (log.areaManager.toLowerCase().contains(lowerQuery)) {
          return true;
        }

        // 실화 여부 검색 (O/X 또는 실제 텍스트)
        if (log.isRealFire && ('o'.contains(lowerQuery) || '실화'.contains(lowerQuery))) {
          return true;
        }
        if (!log.isRealFire && ('x'.contains(lowerQuery) || '오인'.contains(lowerQuery))) {
          return true;
        }

        // (선택사항) 기타 필드 검색: 구역, 감지기, 상태 등도 검색에 포함
        if (log.detectedArea.toLowerCase().contains(lowerQuery)) return true;
        if (log.detectorName.toLowerCase().contains(lowerQuery)) return true;
        if (log.status.toLowerCase().contains(lowerQuery)) return true;

        return false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영상 기록'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // 검색 입력창
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '날짜(MM/DD), 담당자, 실화 여부 등으로 검색',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: _performSearch, // 입력할 때마다 검색 실행
            ),
          ),
          VideoLogTableHeader(columnFlex: _columnFlex), // 헤더 부분 분리
          Expanded( // ListView가 남은 공간을 모두 차지하도록
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 16.0), // <-- 여기에 하단 여백 추가!
              itemCount: _filteredVideoLogs.length, // 필터링된 리스트 사용
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final log = _filteredVideoLogs[index]; // 필터링된 리스트 사용
                return VideoLogTableRow(
                  log: log,
                  columnFlex: _columnFlex,
                  onTap: () {
                    print('영상 기록 ${log.incidentNumber} 클릭됨');
                    // TODO: 해당 영상 기록 클릭 시 상세 페이지로 이동
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}