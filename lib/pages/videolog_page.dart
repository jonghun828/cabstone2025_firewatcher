// lib/pages/videolog_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/videolog.dart';
import '../widgets/videolog_card.dart';
import 'videolog_detail_page.dart'; // 👈 새로 추가된 상세 페이지 import

class VideoLogPage extends StatefulWidget {
  const VideoLogPage({super.key});

  @override
  State<VideoLogPage> createState() => _VideoLogPageState();
}

class _VideoLogPageState extends State<VideoLogPage> {
  final List<VideoLog> _allVideoLogs = [
    // 기존 영상 기록 데이터...
    VideoLog(
      incidentNumber: 1, detectedArea: 'A-숲',
      detectorType: DetectorType.camera, detectorNumber: 3,
      severity: Severity.high, areaManager: '김철수',
      detectionTime: DateTime(2025, 8, 13, 14, 30),
      status: '감지', isRealFire: false,
    ),
    VideoLog(
      incidentNumber: 2, detectedArea: 'C-산책로',
      detectorType: DetectorType.smokeSensor, detectorNumber: 5,
      severity: Severity.high, areaManager: '박영희',
      detectionTime: DateTime(2025, 8, 13, 15, 10),
      status: '처리중', isRealFire: true,
    ),
    VideoLog(
      incidentNumber: 3, detectedArea: 'B-초소',
      detectorType: DetectorType.heatSensor, detectorNumber: 2,
      severity: Severity.medium, areaManager: '이민준',
      detectionTime: DateTime(2025, 8, 12, 10, 0),
      status: '오인', isRealFire: false,
    ),
    VideoLog(
      incidentNumber: 4, detectedArea: 'A-주차장',
      detectorType: DetectorType.camera, detectorNumber: 1,
      severity: Severity.low, areaManager: '김철수',
      detectionTime: DateTime(2025, 8, 11, 23, 45),
      status: '완료', isRealFire: false,
    ),
    VideoLog(
      incidentNumber: 5, detectedArea: 'D-계곡',
      detectorType: DetectorType.smokeSensor, detectorNumber: 8,
      severity: Severity.high, areaManager: '최지우',
      detectionTime: DateTime(2025, 8, 10, 10, 15),
      status: '완료', isRealFire: true,
    ),
  ];
  late List<VideoLog> _filteredVideoLogs;
  final TextEditingController _searchController = TextEditingController();

  // 필터링 상태
  String? _selectedAreaFilter;
  String? _selectedStatusFilter;
  bool? _isRealFireFilter;

  @override
  void initState() {
    super.initState();
    _applyFiltersAndSearch('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFiltersAndSearch(String query) {
    setState(() {
      _filteredVideoLogs = _allVideoLogs.where((log) {
        final lowerQuery = query.toLowerCase();
        bool matchesSearch = true;
        if (lowerQuery.isNotEmpty) {
          final formattedDate = DateFormat('yyyy-MM-dd').format(log.detectionTime);
          final shortDate = DateFormat('MM/dd').format(log.detectionTime);
          if (!(formattedDate.contains(lowerQuery) ||
              shortDate.contains(lowerQuery) ||
              log.areaManager.toLowerCase().contains(lowerQuery) ||
              log.detectedArea.toLowerCase().contains(lowerQuery) ||
              log.status.toLowerCase().contains(lowerQuery))) {
            matchesSearch = false;
          }
        }
        bool matchesFilter = true;
        if (_selectedAreaFilter != null && log.detectedArea != _selectedAreaFilter) {
          matchesFilter = false;
        }
        if (_selectedStatusFilter != null && log.status != _selectedStatusFilter) {
          matchesFilter = false;
        }
        if (_isRealFireFilter != null && log.isRealFire != _isRealFireFilter) {
          matchesFilter = false;
        }
        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _onSearchButtonPressed() {
    _applyFiltersAndSearch(_searchController.text);
  }

  Future<void> _showFilterDialog() async {
    final List<String> allAreas = _allVideoLogs.map((log) => log.detectedArea).toSet().toList();
    final List<String> allStatuses = _allVideoLogs.map((log) => log.status).toSet().toList();
    String? tempSelectedArea = _selectedAreaFilter;
    String? tempSelectedStatus = _selectedStatusFilter;
    bool? tempIsRealFire = _isRealFireFilter;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateInDialog) {
            return AlertDialog(
              title: const Text('필터 설정'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('구역별 필터'),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: tempSelectedArea,
                      hint: const Text('모든 구역'),
                      onChanged: (String? newValue) {
                        setStateInDialog(() {
                          tempSelectedArea = newValue;
                        });
                      },
                      items: [
                        const DropdownMenuItem(value: null, child: Text('모든 구역')),
                        ...allAreas.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('상태별 필터'),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: tempSelectedStatus,
                      hint: const Text('모든 상태'),
                      onChanged: (String? newValue) {
                        setStateInDialog(() {
                          tempSelectedStatus = newValue;
                        });
                      },
                      items: [
                        const DropdownMenuItem(value: null, child: Text('모든 상태')),
                        ...allStatuses.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('실화 여부'),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool?>(
                            title: const Text('전체'),
                            value: null,
                            groupValue: tempIsRealFire,
                            onChanged: (bool? value) {
                              setStateInDialog(() => tempIsRealFire = value);
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool?>(
                            title: const Text('실화'),
                            value: true,
                            groupValue: tempIsRealFire,
                            onChanged: (bool? value) {
                              setStateInDialog(() => tempIsRealFire = value);
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool?>(
                            title: const Text('오인'),
                            value: false,
                            groupValue: tempIsRealFire,
                            onChanged: (bool? value) {
                              setStateInDialog(() => tempIsRealFire = value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop({
                      'area': tempSelectedArea,
                      'status': tempSelectedStatus,
                      'isRealFire': tempIsRealFire,
                    });
                  },
                  child: const Text('적용'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedAreaFilter = result['area'];
        _selectedStatusFilter = result['status'];
        _isRealFireFilter = result['isRealFire'];
        _applyFiltersAndSearch(_searchController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. 검색 입력창 및 필터 버튼 (좌우 패딩 20.0으로 통일)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '날짜(MM/DD), 담당자 등으로 검색',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _onSearchButtonPressed,
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: _showFilterDialog,
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSubmitted: (_) => _onSearchButtonPressed(),
            ),
          ),
          // 2. 카드 목록 (남은 공간을 모두 차지)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: _filteredVideoLogs.length,
              itemBuilder: (context, index) {
                final log = _filteredVideoLogs[index];
                return VideoLogCard(
                  log: log,
                  onTap: () {
                    // TODO: 상세 페이지로 이동 -> 수정된 부분
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoLogDetailPage(log: log),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // 3. 하단 메뉴바와의 여백 추가
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}