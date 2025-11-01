// lib/pages/zone_page.dart

import 'package:cabstone2025_firewatcher/pages/video_test_page.dart';
import 'package:flutter/material.dart';
import '../models/sensor.dart';
import '../services/api_service.dart';
import 'zone_detail_page.dart';

class ZonePage extends StatefulWidget {
  const ZonePage({super.key});

  @override
  State<ZonePage> createState() => _ZonePageState();
}

class _ZonePageState extends State<ZonePage> {
  final ApiService _apiService = ApiService();

  Set<String> _selectedZoneName = {'A'};
  List<Sensor> _filteredSensors = [];
  bool _isLoading = true;
  String? _errorMessage;

  final Map<String, int> _zoneMap = const {'A': 0, 'B': 1, 'C': 2, 'D': 3};
  final List<String> availableZones = const ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    _fetchSensorsByZone();
  }

  // API를 통해 선택된 구역의 센서 목록을 불러오는 함수
  Future<void> _fetchSensorsByZone() async {
    if (!mounted) return;

    final currentZoneName = _selectedZoneName.isEmpty ? 'A' : _selectedZoneName.first;
    final currentZoneId = _zoneMap[currentZoneName]!;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _filteredSensors = [];
    });

    try {
      final response = await _apiService.fetchZoneSensors(currentZoneId);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        final List<Sensor> sensors = jsonList
            .map((json) => Sensor.fromJson(json))
            .toList();

        if (mounted) {
          setState(() {
            _filteredSensors = sensors;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = '장치 목록 로드 실패 (코드: ${response.statusCode})';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '데이터 로드 중 오류 발생';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 구역 선택 변경 핸들러
  void _onZoneSelectionChanged(Set<String> newSelection) {
    if (newSelection.isNotEmpty) {
      setState(() {
        _selectedZoneName = newSelection;
      });
      _fetchSensorsByZone();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 구역 선택 SegmentedButton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: availableZones.map((zone) => ButtonSegment<String>(
                  value: zone,
                  label: Text('$zone 구역'),
                )).toList(),
                selected: _selectedZoneName,
                onSelectionChanged: _onZoneSelectionChanged,
                multiSelectionEnabled: false,
                emptySelectionAllowed: false,
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  selectedForegroundColor: Colors.white,
                  selectedBackgroundColor: Colors.blue,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 필터링된 센서 목록 표시
          Expanded(
            child: _buildSensorListContent(),
          ),
        ],
      ),
    );
  }

  // 센서 목록 UI 빌더
  Widget _buildSensorListContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('데이터 로드 오류: $_errorMessage', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _fetchSensorsByZone, child: const Text('다시 시도')),
          ],
        ),
      );
    }

    if (_filteredSensors.isEmpty) {
      return Center(child: Text('${_selectedZoneName.first} 구역에 등록된 장치가 없습니다.'));
    }

    // 목록 (Card와 ListTile 사용) 표시
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _filteredSensors.length,
      itemBuilder: (context, index) {
        final sensor = _filteredSensors[index];

        return InkWell(
          onTap: () {
            // 상세 페이지로 Sensor 객체 전달
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoStreamPage(sensor: ),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              // 제목: areaName 사용 (이름 중복 문제 해결)
              title: Text(
                sensor.areaName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              // 부제 제거됨
              leading: Icon(
                sensor.isConnected ? Icons.check_circle : Icons.error,
                color: sensor.isConnected ? Colors.green : Colors.red,
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}